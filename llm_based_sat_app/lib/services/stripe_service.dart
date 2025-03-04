import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:llm_based_sat_app/utils/consts.dart';
import '../firebase/firebase_helpers.dart';

class StripeService {
  // Singleton instance to ensure only one StripeService is used across the app
  StripeService._();
  static final StripeService instance = StripeService._();

  String stripeSecretKey = dotenv.env['STRIPE_SECRET_KEY'] ?? '';
  // log stripeSecretKey to verify it is set correctl

  /* Creates a new subscription for the user. */
  Future<void> createSubscription(String priceId) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print("No authenticated user found.");
        return;
      }

      // Get user's current tier before making changes (for logging)
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection("Profile")
          .doc(user.uid)
          .get();
      String oldPlan = userDoc.exists
          ? (userDoc.data() as Map<String, dynamic>)["tier"] ?? "free"
          : "free";

      // Step 1: Create a customer in Stripe (if not already created)
      String? customerId = await _createCustomer(user.uid, user.email!);
      if (customerId == null) return;

      // Step 2: Create a subscription for the user
      final subscriptionResponse =
          await _createSubscription(customerId, priceId);
      if (subscriptionResponse == null) return;

      // Extract data from response
      String subscriptionId = subscriptionResponse['id'];
      String clientSecret = subscriptionResponse['latest_invoice']
          ['payment_intent']['client_secret'];

      // Get subscription renewal date (current_period_end is in Unix timestamp)
      int periodEndTimestamp = subscriptionResponse['current_period_end'];
      DateTime renewalDate =
          DateTime.fromMillisecondsSinceEpoch(periodEndTimestamp * 1000);

      // Step 3: Present payment sheet to user
      bool paymentSuccess = await _presentPaymentSheet(clientSecret);
      if (!paymentSuccess) return;

      // Step 4: Store subscription details in Firestore after successful payment
      await _saveSubscriptionToFirestore(
          user.uid, subscriptionId, priceId, renewalDate);

      // Step 5: Log the subscription change
      String newPlan = priceId == stripeMonthlyPriceId ? "monthly" : "yearly";
      await logSubscriptionChange(
        userId: user.uid,
        oldPlan: oldPlan,
        newPlan: newPlan,
        changeDate: DateTime.now(),
      );

      print("Subscription created and paid successfully!");
    } catch (e) {
      print("Subscription Error: $e");
    }
  }

  /* Creates a Stripe customer for the given Firebase user if one doesn't exist. Returns the Stripe customer ID. */
  Future<String?> _createCustomer(String uid, String email) async {
    try {
      // First check if user already has a Stripe customer ID in Firestore
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection("Profile").doc(uid).get();

      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        if (userData.containsKey('stripeCustomerId') &&
            userData['stripeCustomerId'] != null) {
          print(
              "Using existing Stripe customer: ${userData['stripeCustomerId']}");
          return userData['stripeCustomerId'];
        }
      }

      // If no customer ID exists, create a new one
      final Dio dio = Dio();

      // Convert to URL-encoded form data
      final formData = {'email': email, 'metadata[firebaseUID]': uid};

      var response = await dio.post(
        "https://api.stripe.com/v1/customers",
        data: formData, // Dio will encode this properly
        options: Options(
          contentType: Headers
              .formUrlEncodedContentType, // Proper way to set content type
          headers: {
            "Authorization": "Bearer $stripeSecretKey",
          },
        ),
      );

      // Store the new customer ID in Firestore
      String customerId = response.data["id"];
      await FirebaseFirestore.instance
          .collection("Profile")
          .doc(uid)
          .update({"stripeCustomerId": customerId});

      print("New customer created: $customerId");
      return customerId;
    } catch (e) {
      // Log detailed error
      if (e is DioException && e.response != null) {
        print("Stripe Error Details: ${e.response?.data}");
      }
      print("Customer Creation Error: $e");
      return null;
    }
  }

  /* Creates a new subscription for a given customer and price ID in Stripe. Returns subscription data or `null` on failure. */
  Future<Map<String, dynamic>?> _createSubscription(
      String customerId, String priceId) async {
    try {
      final Dio dio = Dio();

      // Add these crucial parameters
      final formData = {
        'customer': customerId,
        'items[0][price]': priceId,
        'payment_behavior': 'default_incomplete', // Required for payment sheet
        'expand[]':
            'latest_invoice.payment_intent' // Required to get client_secret
      };

      var response = await dio.post(
        "https://api.stripe.com/v1/subscriptions",
        data: formData,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {
            "Authorization": "Bearer $stripeSecretKey",
          },
        ),
      );

      print("Subscription response: ${response.data}");
      return response.data;
    } catch (e) {
      if (e is DioException && e.response != null) {
        print("Subscription Error Details: ${e.response?.data}");
      }
      print("Subscription Creation Error: $e");
      return null;
    }
  }

  /// Saves subscription details in Firestore for a user.
  Future<void> _saveSubscriptionToFirestore(String uid, String subscriptionId,
      String priceId, DateTime renewalDate) async {
    await FirebaseFirestore.instance.collection("Profile").doc(uid).update({
      "subscriptionId": subscriptionId,
      "tier": priceId == stripeMonthlyPriceId ? "monthly" : "yearly",
      "subscriptionStatus": "active",
      "subscriptionRenewalDate": Timestamp.fromDate(renewalDate),
    });
    print(
        "Saved subscription to Firestore with renewal date: ${renewalDate.toIso8601String()}");
  }

  /// Logs subscription changes in Firestore.
  Future<void> logSubscriptionChange({
    required String userId,
    required String oldPlan,
    required String newPlan,
    required DateTime changeDate,
  }) async {
    try {
      FirebaseFirestore db = FirebaseFirestore.instance;
      DocumentReference userRef = db.collection("Profile").doc(userId);

      // Add subscription change log
      await userRef.collection("subscriptionLogs").add({
        "oldPlan": oldPlan,
        "newPlan": newPlan,
        "changeDate": Timestamp.fromDate(changeDate)
      });

      // Update user's profile with new tier
      await userRef.update({
        "tier": newPlan,
      });

      print(
          "Subscription change logged for user: $userId (${oldPlan} -> ${newPlan})");
    } catch (e) {
      print("Error logging subscription change: $e");
    }
  }

  /// Cancels the subscription for given user
  Future<void> cancelSubscription(String userId) async {
    try {
      // Step 1: Get current subscription info
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection("Profile")
          .doc(userId)
          .get();
      String oldPlan = userDoc.exists ? (userDoc["tier"] ?? "free") : "free";

      if (oldPlan == "free") {
        print("User is already on free tier. No action needed.");
        return;
      }

      // Step 2: Determine when the downgrade should take effect
      DateTime now = DateTime.now();

      // Try to use the stored renewal date if available
      DateTime endOfCurrentBillingCycle;
      if (userDoc.exists && userDoc.data() is Map<String, dynamic>) {
        var data = userDoc.data() as Map<String, dynamic>;
        if (data.containsKey("subscriptionRenewalDate") &&
            data["subscriptionRenewalDate"] is Timestamp) {
          endOfCurrentBillingCycle =
              (data["subscriptionRenewalDate"] as Timestamp).toDate();
        } else {
          // Fallback: use 30 days from now
          endOfCurrentBillingCycle = now.add(Duration(days: 30));
        }
      } else {
        endOfCurrentBillingCycle = now.add(Duration(days: 30));
      }

      // Step 3: Log subscription downgrade in Firestore
      await logSubscriptionChange(
          userId: userId, oldPlan: oldPlan, newPlan: "free", changeDate: now);

      print("Subscription downgrade scheduled for user: $userId");
    } catch (e) {
      print("Error cancelling subscription: $e");
    }
  }

  /* Presents Stripe's payment sheet to the user. Returns `true` if the payment was successful, `false` otherwise */
  Future<bool> _presentPaymentSheet(String clientSecret) async {
    try {
      // Set up payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          merchantDisplayName: 'InvinciMind',
          paymentIntentClientSecret: clientSecret,
          style: ThemeMode.system,
        ),
      );

      // Present payment sheet
      await Stripe.instance.presentPaymentSheet();
      return true;
    } catch (e) {
      print("Error presenting payment sheet: $e");
      return false;
    }
  }
}
