import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';
import '../main.dart'; // For MainScreen

/// A layout widget that provides a consistent structure for the app's main screens.
class MainLayout extends StatelessWidget {
  final Widget body;
  final int selectedIndex;

  const MainLayout({
    super.key,
    required this.body,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body,
      bottomNavigationBar: BottomNavBar(
        selectedIndex: selectedIndex,
        onTap: (index) {
          // Navigate to MainScreen with the selected index
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => MainScreen(initialIndex: index),
            ),
            (route) => false, // Remove all previous routes
          );
        },
      ),
    );
  }
}
