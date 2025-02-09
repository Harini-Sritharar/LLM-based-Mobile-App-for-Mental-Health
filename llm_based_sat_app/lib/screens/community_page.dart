import 'package:flutter/material.dart';
import 'profile/profile_page.dart';
import '../widgets/custom_app_bar.dart';

class CommunityPage extends StatelessWidget {
  final Function(int) onItemTapped; // Required for navigation
  final int selectedIndex;

  const CommunityPage(
      {super.key, required this.onItemTapped, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "InvinciMind",
        onItemTapped: onItemTapped,
        selectedIndex: selectedIndex,
        backButton: false,
      ),
      body: const Center(
        child: Text(
          'Community Page',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
