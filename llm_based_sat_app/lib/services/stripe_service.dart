import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'package:llm_based_sat_app/consts.dart';

import '../firebase_helpers.dart';

class StripeService {
  StripeService._();

  static final StripeService instance = StripeService._();

  Future<void> makePayment(int amount) async {
    try {
      print("Creating payment intent for £$amount...");
      String? paymentIntentClientSecret =
          await _createPaymentIntent(amount, "gbp");

      if (paymentIntentClientSecret == null) {
        print("Failed to create payment intent.");
        return;
      }

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentClientSecret,
          merchantDisplayName: "InvinciMind",
        ),
      );

      await _processPayment(amount); // Pass amount to determine the tier
    } catch (e) {
      print("Stripe Payment Error: $e");
    }
  }

  Future<String?> _createPaymentIntent(int amount, String currency) async {
    try {
      final Dio dio = Dio();
      Map<String, dynamic> data = {
        "amount": _calculateAmount(amount),
        "currency": currency,
      };
      var response = await dio.post(
        "https://api.stripe.com/v1/payment_intents",
        data: data,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {
            "Authorization": "Bearer $stripeSecretKey",
            "Content-Type": "application/x-www-form-urlencoded"
          },
        ),
      );
      if (response.data != null) {
        print("Payment Intent Created: ${response.data["client_secret"]}");
        return response.data["client_secret"];
      }
      return null;
    } catch (e) {
      print("Payment Intent Error: $e");
    }
    return null;
  }

  Future<void> _processPayment(int amount) async {
    try {
      await Stripe.instance.presentPaymentSheet();
      print("Payment successful!");

      // Get the current user
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print("Error: No authenticated user found.");
        return;
      }

      // Set user tier based on payment amount
      if (amount == 10) {
        print("Setting user tier to 'monthly' for user ${user.uid}");
        await setTier(user.uid, 'monthly');
      } else if (amount == 100) {
        print("Setting user tier to 'yearly' for user ${user.uid}");
        await setTier(user.uid, 'yearly');
      }
    } catch (e) {
      print("Payment failed: $e");
    }
  }

  String _calculateAmount(int amount) {
    final calculatedAmount = amount * 100; // Convert to pence
    return calculatedAmount.toString();
  }
}
