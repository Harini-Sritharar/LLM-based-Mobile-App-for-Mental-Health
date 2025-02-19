/// This file defines the `BottomNavBar` widget, which provides a customizable
/// bottom navigation bar for the application. It uses icons to represent various
/// navigation tabs and handles user interaction through callbacks.

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// A stateless widget that represents the Bottom Navigation Bar.
/// This widget allows users to navigate between different sections of the app.
class BottomNavBar extends StatelessWidget {
  // The currently selected index in the navigation bar.
  final int selectedIndex;

  // Callback function to handle tab changes.
  final Function(int) onTap;

  /// Constructor for `BottomNavBar`.
  ///
  /// Requires:
  /// - [selectedIndex]: The index of the currently selected tab.
  /// - [onTap]: A callback function that is triggered when a tab is tapped.
  const BottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.grey.shade300,
            width: 1, // Adds a top border for visual separation.
          ),
        ),
      ),
      child: BottomNavigationBar(
        // The current index of the selected tab.
        currentIndex: selectedIndex,

        // Callback triggered when a tab is tapped.
        onTap: onTap,

        // Navigation bar styling.
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black, // Color for the active tab.
        unselectedItemColor: Colors.grey, // Color for inactive tabs.
        selectedFontSize: 12, // Font size for active tab labels.
        unselectedFontSize: 12, // Font size for inactive tab labels.
        type: BottomNavigationBarType.fixed, // Ensures consistent spacing.

        // Navigation bar items representing different app sections.
        items: [
          BottomNavigationBarItem(
            // Community tab icon.
            icon: SvgPicture.asset(
              'assets/icons/people.svg',
              height: 24,
              width: 24,
              color: selectedIndex == 0 ? Colors.black : Colors.grey,
            ),
            label: 'Questionnaire',
          ),
          BottomNavigationBarItem(
            // Calendar tab icon.
            icon: SvgPicture.asset(
              'assets/icons/calendar.svg',
              height: 24,
              width: 24,
              color: selectedIndex == 1 ? Colors.black : Colors.grey,
            ),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            // Home tab icon.
            icon: SvgPicture.asset(
              'assets/icons/people.svg',
              height: 24,
              width: 24,
              color: selectedIndex == 2 ? Colors.black : Colors.grey,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            // Score tab icon.
            icon: SvgPicture.asset(
              'assets/icons/diagram.svg',
              height: 24,
              width: 24,
              color: selectedIndex == 3 ? Colors.black : Colors.grey,
            ),
            label: 'Score',
          ),
          BottomNavigationBarItem(
            // Courses tab icon.
            icon: SvgPicture.asset(
              'assets/icons/book.svg',
              height: 24,
              width: 24,
              color: selectedIndex == 4 ? Colors.black : Colors.grey,
            ),
            label: 'Courses',
          ),
        ],
      ),
    );
  }
}
