import 'package:flutter/material.dart';
import 'bottom_nav_bar.dart'; // Import BottomNavBar

class MainLayout extends StatelessWidget {
  final Widget body;
  final int selectedIndex;
  final Function(int) onItemTapped;

  MainLayout(
      {required this.body,
      required this.selectedIndex,
      required this.onItemTapped});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body,
      bottomNavigationBar: BottomNavBar(
        selectedIndex: selectedIndex,
        onTap: onItemTapped,
      ),
    );
  }
}
