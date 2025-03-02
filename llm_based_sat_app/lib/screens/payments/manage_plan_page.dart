import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:llm_based_sat_app/firebase/firebase_helpers.dart';
import 'package:llm_based_sat_app/services/stripe_service.dart';
import 'package:llm_based_sat_app/theme/app_colours.dart';
import '../../widgets/main_layout.dart';
import '../../widgets/custom_app_bar.dart';

class ManagePlanPage extends StatefulWidget {
  final Function(int) onItemTapped;
  final int selectedIndex;

  const ManagePlanPage({
    super.key,
    required this.onItemTapped,
    required this.selectedIndex,
  });

  @override
  _ManagePlanPageState createState() => _ManagePlanPageState();
}

class _ManagePlanPageState extends State<ManagePlanPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  String? _currentTier;
  DateTime? _expiryDate;

  @override
  void initState() {
    super.initState();
    _fetchUserTier();
  }

  Future<void> _fetchUserTier() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    String? tier = await getTier(user.uid);
    DateTime? expiryDate = tier == "monthly" || tier == "yearly"
        ? await getTierExpiry(user.uid)
        : null; // Don't fetch expiry for free tier
    if (!mounted) return;

    setState(() {
      _currentTier = tier;
      _expiryDate = expiryDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      selectedIndex: widget.selectedIndex,
      body: Container(
        color: AppColours.backgroundColor,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomAppBar(
              title: "Subscription",
              onItemTapped: widget.onItemTapped,
              selectedIndex: widget.selectedIndex,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                scrollDirection: Axis.horizontal,
                children: [
                  _buildPlanCard(
                    title: "Free Tier",
                    price: "£0/month",
                    benefits: [
                      "Basic access to all core features without any cost.",
                      "Access to core courses.",
                      "Community support through forums and help sections.",
                    ],
                    color: Colors.grey.shade200,
                    tierName: "free",
                  ),
                  _buildPlanCard(
                    title: "Monthly Plan",
                    price: "£10.00/month",
                    benefits: [
                      "Unlimited access to all courses with no restrictions.",
                      "Priority support with faster response times.",
                      "Exclusive content and early feature releases for subscribers.",
                    ],
                    color: Colors.blue.shade100,
                    showButton:
                        _currentTier != "monthly" && _currentTier != "yearly",
                    tierName: "monthly",
                  ),
                  _buildPlanCard(
                    title: "Yearly Plan",
                    price: "£100.00/year",
                    benefits: [
                      "All benefits from the monthly plan at a discounted rate.",
                      "Even more storage for long-term users.",
                      "Early access to new and experimental features.",
                      "Premium support with dedicated assistance.",
                    ],
                    color: Color(0xFF91a0f0),
                    showButton:
                        _currentTier != "monthly" && _currentTier != "yearly",
                    tierName: "yearly",
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  width: _currentPage == index ? 12.0 : 8.0,
                  height: _currentPage == index ? 12.0 : 8.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPage == index ? Colors.blue : Colors.grey,
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanCard({
    required String title,
    required String price,
    required List<String> benefits,
    required Color color,
    bool showButton = false,
    required String tierName,
  }) {
    bool isActiveTier = _currentTier == tierName;
    bool showExpiry = isActiveTier &&
        (tierName == "monthly" || tierName == "yearly") &&
        _expiryDate != null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        color: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
          side: isActiveTier
              ? const BorderSide(color: Colors.orange, width: 3)
              : BorderSide.none,
        ),
        elevation: 6,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: Text(
                  price,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: benefits
                    .map((benefit) => _buildBenefitItem(benefit))
                    .toList(),
              ),
              if (showExpiry)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Center(
                    child: Text(
                      "Expires on: ${_expiryDate!.toLocal().toString().split(' ')[0]}",
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                    ),
                  ),
                ),
              const Spacer(), // Pushes the button to the bottom
              if (showButton)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        print("Go Premium button pressed for $title");
                        int amount = tierName == "monthly" ? 10 : 100;
                        await StripeService.instance.makePayment(amount);
                        await _fetchUserTier();
                        setState(() {});
                      },
                      child: const Text("Go Premium"),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBenefitItem(String benefit) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              benefit,
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
