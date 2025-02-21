/// This file defines the `SettingsPage` widget, which provides a user interface
/// for navigating and configuring various application settings. It utilizes
/// the `MainLayout` for consistent structure and a `CustomAppBar` for navigation.

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:llm_based_sat_app/firebase/firebase_auth_services.dart';
import 'package:llm_based_sat_app/screens/auth/sign_in_page.dart';
import 'package:llm_based_sat_app/screens/language_page.dart';
import 'package:llm_based_sat_app/screens/notifications_page.dart';
import 'package:llm_based_sat_app/widgets/custom_app_bar.dart';

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
            _buildSettingsItem(
              context,
              'Notifications',
              'assets/icons/profile/notification-bing.svg',
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NotificationsPage(
                      onItemTapped: onItemTapped,
                      selectedIndex: selectedIndex,
                    ),
                  ),
                );
              },
            ),
            _buildSettingsItem(
              context,
              'Security',
              'assets/icons/profile/security-safe.svg',
              () {},
            ),
            _buildSettingsItem(
              context,
              'Accessibility',
              'assets/icons/profile/accessibility.svg',
              () {},
            ),
            _buildSettingsItem(
              context,
              'Language',
              'assets/icons/profile/language-circle.svg',
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LanguagePage(
                      onItemTapped: onItemTapped,
                      selectedIndex: selectedIndex,
                    ),
                  ),
                );
              },
            ),
            _buildSettingsItem(
              context,
              'Terms & Conditions',
              'assets/icons/profile/book.svg',
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TermsAndConditionsPage(
                      onItemTapped: onItemTapped,
                      selectedIndex: selectedIndex,
                    ),
                  ),
                );
              },
            ),
            _buildSettingsItem(
              context,
              'Help Centre',
              'assets/icons/profile/message-question.svg',
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HelpCentrePage(
                      onItemTapped: onItemTapped,
                      selectedIndex: selectedIndex,
                    ),
                  ),
                );
              },
            ),
            _buildSettingsItem(
              context,
              'Reset Setting',
              'assets/icons/profile/rotate-left.svg',
              () {},
            ),
            _buildSettingsItem(
              context,
              'Delete Account',
              'assets/icons/profile/trash.svg',
              () => _confirmDeleteAccount(context),
            ),
            SizedBox(height: 20),
            _buildBackButton(
                context), // Back button to navigate to the previous page.
          ],
        ),
      ),
    );
  }

  void _confirmDeleteAccount(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text("Delete Account"),
          content: Text(
              "Are you sure you want to delete your account? This action cannot be undone."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(dialogContext); // Close dialog
                await _deleteAccountAndRedirect(context);
              },
              child: Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteAccountAndRedirect(BuildContext context) async {
    try {
      await FirebaseAuthService().deleteAccount(context);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => SignInPage())); // Redirect to login
    } catch (e) {
      print("An error occurred while deleting the account.");
    }
  }

  /// Builds a list item for the settings page.
  ///
  /// [context]: The BuildContext of the widget.
  /// [title]: The title displayed for the setting.
  /// [icon]: The icon to be displayed (either a string path to an SVG or an IconData).
  /// [onTap]: The callback function when the item is tapped.
  Widget _buildSettingsItem(
      BuildContext context, String title, dynamic icon, VoidCallback onTap) {
    return ListTile(
      leading: (icon is String)
          ? SvgPicture.asset(
              icon,
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(primaryTextColor, BlendMode.srcIn),
            )
          : Icon(icon, color: primaryTextColor),
      title: Text(
        title,
        style: TextStyle(fontSize: 18, color: primaryTextColor),
      ),
      trailing: Icon(Icons.arrow_forward_ios, size: 18, color: arrowColor),
      onTap: onTap,
    );
  }

  /// Builds the back button at the bottom of the page.
  ///
  /// [context]: The BuildContext of the widget.
  Widget _buildBackButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
          onPressed: () =>
              Navigator.pop(context), // Navigate to the previous page.
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF1C548C),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(
                      left: 20), // Adjust left padding if needed.
                  child: SvgPicture.asset(
                    'assets/icons/back_icon.svg',
                    width: 30,
                    height: 30,
                  ),
                ),
              ),
              Center(
                child: Text(
                  "Back",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
