import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:llm_based_sat_app/firebase/firebase_helpers.dart';
import 'package:llm_based_sat_app/services/stripe_service.dart';
import 'package:llm_based_sat_app/theme/app_colours.dart';
import 'package:llm_based_sat_app/utils/consts.dart';
import '../../widgets/main_layout.dart';
import '../../widgets/custom_app_bar.dart';

/// Manages the subscription plan page, allowing the user to view and modify their subscription tier.
class ManagePlanPage extends StatefulWidget {
  final Function(int)
      onItemTapped; // Callback to handle bottom navigation item taps
  final int
      selectedIndex; // The currently selected index for the bottom navigation

  const ManagePlanPage({
    super.key,
    required this.onItemTapped,
    required this.selectedIndex,
  });

  @override
  _ManagePlanPageState createState() => _ManagePlanPageState();
}

class _ManagePlanPageState extends State<ManagePlanPage> {
  final PageController _pageController =
      PageController(); // Controller for the PageView widget
  int _currentPage =
      0; // The current page index (used to display different subscription tiers)
  String?
      _currentTier; // The current tier of the user (free, monthly, or yearly)
  DateTime? _expiryDate; // The subscription expiry date, if applicable

  @override
  void initState() {
    super.initState();
    _fetchUserTier(); // Fetch the user's current subscription tier on initialization
  }

  /// Fetches the user's current subscription tier and expiry date from Firestore.
  Future<void> _fetchUserTier() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return; // Ensure the user is logged in

    try {
      // Fetch the user document from Firestore
      final userDoc = await FirebaseFirestore.instance
          .collection("Profile")
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        final userData = userDoc.data() as Map<String, dynamic>;
        final tier = userData['tier'] as String? ??
            'free'; // Get the user's subscription tier

        // Get the subscription renewal date if available
        DateTime? expiryDate;
        if ((tier == 'monthly' || tier == 'yearly') &&
            userData.containsKey('subscriptionRenewalDate')) {
          final renewalTimestamp =
              userData['subscriptionRenewalDate'] as Timestamp?;
          expiryDate = renewalTimestamp?.toDate();
        }

        setState(() {
          _currentTier = tier;
          _expiryDate = expiryDate; // Set the expiry date if available
        });
      }
    } catch (e) {
      print("Error fetching user subscription data: $e");
    }
  }

  /// Returns the appropriate text for the action button based on the selected plan and current plan.
  String _getButtonText() {
    final selectedTier = _currentPage == 0
        ? "free"
        : _currentPage == 1
            ? "monthly"
            : "yearly";

    if (selectedTier == _currentTier) {
      return "Current Plan"; // User is already on this plan
    }

    if (selectedTier == "free") {
      return "Downgrade to Free"; // Offer to downgrade to the free plan
    } else if (selectedTier == "monthly") {
      return _currentTier == "free"
          ? "Subscribe to Monthly"
          : "Downgrade to Monthly";
    } else {
      // yearly
      return _currentTier == "free"
          ? "Subscribe to Yearly"
          : "Switch to Yearly";
    }
  }

  /// Checks if the selected plan is the user's current plan.
  bool _isCurrentPlan() {
    final selectedTier = _currentPage == 0
        ? "free"
        : _currentPage == 1
            ? "monthly"
            : "yearly";
    return selectedTier ==
        _currentTier; // Returns true if the selected plan matches the current plan
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      selectedIndex: widget.selectedIndex,
      body: Scaffold(
        appBar: CustomAppBar(
          title: "Subscription", // Title of the screen
          onItemTapped: widget.onItemTapped,
          selectedIndex: widget.selectedIndex,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage =
                        page; // Update the current page when the user swipes
                  });
                },
                children: [
                  _buildPlanCard(tierName: "free"), // Free plan card
                  _buildPlanCard(tierName: "monthly"), // Monthly plan card
                  _buildPlanCard(tierName: "yearly"), // Yearly plan card
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = 0;
                      i < 3;
                      i++) // Dots indicating the selected page
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 4.0),
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentPage == i
                            ? AppColours.brandBlueMain
                            : Colors.grey,
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 24.0, horizontal: 24.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColours.brandBlueMain,
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 50),
                ),
                onPressed: _isCurrentPlan()
                    ? null
                    : () async {
                        User? user = FirebaseAuth.instance.currentUser;
                        if (user == null) return;

                        // Determine what action to take based on selected plan and current tier
                        final selectedTier = _currentPage == 0
                            ? "free"
                            : _currentPage == 1
                                ? "monthly"
                                : "yearly";

                        if (selectedTier == _currentTier) {
                          // No change needed
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    "You are already on the $selectedTier plan.")),
                          );
                          return;
                        }

                        // For free plan, cancel subscription
                        if (selectedTier == "free") {
                          await StripeService.instance
                              .cancelSubscription(user.uid);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    "Your subscription will be canceled at the end of your billing period.")),
                          );
                        } else {
                          // For paid plans, start Stripe checkout
                          final priceId = selectedTier == "monthly"
                              ? stripeMonthlyPriceId
                              : stripeYearlyPriceId;
                          await StripeService.instance
                              .createSubscription(priceId);
                        }

                        // Refresh tier info after the operation
                        await _fetchUserTier();
                      },
                child: Text(
                  _getButtonText(), // Display the appropriate button text
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a card for a subscription plan (free, monthly, or yearly) with relevant details.
  Widget _buildPlanCard({required String tierName}) {
    String title;
    String price;
    List<String> benefits;
    bool showExpiry = false;
    bool isCurrentPlan = _currentTier == tierName;

    switch (tierName) {
      case "monthly":
        title = "Monthly Premium";
        price = "£10.00/month";
        benefits = [
          "Unlimited conversations",
          "Advanced mental health tracking",
          "Personalized recommendations",
          "Priority support"
        ];
        showExpiry = isCurrentPlan;
        break;
      case "yearly":
        title = "Yearly Premium";
        price = "£100.00/year";
        benefits = [
          "All monthly features",
          "Save 17% compared to monthly",
          "Exclusive yearly content",
          "Premium analytics"
        ];
        showExpiry = isCurrentPlan;
        break;
      case "free":
      default:
        title = "Basic Plan";
        price = "Free";
        benefits = [
          "Limited conversations per day",
          "Basic mental health tracking",
          "Standard features"
        ];
        break;
    }

    return Card(
      elevation: 5,
      margin: EdgeInsets.all(20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(
          color: isCurrentPlan ? AppColours.brandBlueMain : Colors.transparent,
          width: 2,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (isCurrentPlan)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColours.brandBlueMain,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "Current Plan",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              price,
              style: TextStyle(
                fontSize: 20,
                color: AppColours.brandBlueMain,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            for (String benefit in benefits)
              _buildBenefitItem(
                  benefit), // Build the benefit items for the plan

            if (showExpiry)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Center(
                  child: Text(
                    "Renews on: ${_expiryDate != null ? DateFormat('MMM d, yyyy').format(_expiryDate!) : 'Unknown'}",
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepOrange),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Builds a row item for each benefit of a subscription plan.
  Widget _buildBenefitItem(String benefit) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: AppColours.brandBlueMain, size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              benefit,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
