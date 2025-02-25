/// This file defines the `SettingsPage` widget, which provides a user interface
/// for navigating and configuring various application settings. It utilizes
/// the `MainLayout` for consistent structure and a `CustomAppBar` for navigation.

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:llm_based_sat_app/screens/language_page.dart';
import 'package:llm_based_sat_app/screens/notifications_settings_page.dart';
import 'package:llm_based_sat_app/widgets/custom_app_bar.dart';
import 'package:llm_based_sat_app/widgets/custom_button.dart';
import 'package:llm_based_sat_app/widgets/menu_item.dart';

import '../widgets/main_layout.dart';
import 'help_centre_page.dart';
import 'terms_and_conditions_page.dart';

/// A stateless widget that represents the Settings page.
/// This page allows users to navigate to various configuration and information sections.
class SettingsPage extends StatelessWidget {
// Color constants used throughout the page.
  static const Color primaryTextColor = Color(0xFF687078);
  static const Color secondaryTextColor = Color(0xFF123659);
  static const Color primaryButtonColor = Color(0xFF2F4A79);
  static const Color arrowColor = Color(0xFF1C548C);
  final Function(int) onItemTapped; // Receive function to update navbar index
  final int selectedIndex; // Keep track of selected index

  SettingsPage({required this.onItemTapped, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      selectedIndex: selectedIndex,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Custom app bar for the page.
            CustomAppBar(
              title: "Personal Profile",
              onItemTapped: onItemTapped,
              selectedIndex: selectedIndex,
            ),
            SizedBox(height: 10),
            // Settings options displayed as list items.
            MenuItem(
                title: 'Notifications',
                icon: 'assets/icons/profile/notification-bing.svg',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NotificationSettingsPage(
                        onItemTapped: onItemTapped,
                        selectedIndex: selectedIndex,
                      ),
                    ),
                  );
                }),
            MenuItem(
                title: 'Security',
                icon: 'assets/icons/profile/security-safe.svg',
                onTap: () {}),
            MenuItem(
                title: 'Accessibility',
                icon: 'assets/icons/profile/accessibility.svg',
                onTap: () {}),
            MenuItem(
                title: 'Language',
                icon: 'assets/icons/profile/language-circle.svg',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LanguagePage(
                        onItemTapped: onItemTapped,
                        selectedIndex: selectedIndex,
                      ),
                    ),
                  );
                }),
            MenuItem(
                title: 'Terms & Conditions',
                icon: 'assets/icons/profile/book.svg',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TermsAndConditionsPage(
                        onItemTapped: onItemTapped,
                        selectedIndex: selectedIndex,
                      ),
                    ),
                  );
                }),
            MenuItem(
                title: 'Help Centre',
                icon: 'assets/icons/profile/message-question.svg',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HelpCentrePage(
                        onItemTapped: onItemTapped,
                        selectedIndex: selectedIndex,
                      ),
                    ),
                  );
                }),
            MenuItem(
                title: 'Reset Setting',
                icon: 'assets/icons/profile/rotate-left.svg',
                onTap: () {}),
            MenuItem(
                title: 'Delete Account',
                icon: 'assets/icons/profile/trash.svg',
                onTap: () {}),

            SizedBox(height: 20),
            CustomButton(
              buttonText: "Back",
              onPress: () => Navigator.pop(
                  context), // Closes the current screen and returns to the previous one
              leftArrowPresent: true,
              rightArrowPresent: false,
              textColor: Colors.white,
            ), // Back button to navigate to the previous page.
          ],
        ),
      ),
    );
  }
}
