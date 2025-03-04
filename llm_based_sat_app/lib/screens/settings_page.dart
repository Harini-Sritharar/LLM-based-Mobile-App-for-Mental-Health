import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:llm_based_sat_app/firebase/firebase_auth_services.dart';
import 'package:llm_based_sat_app/screens/auth/sign_in_page.dart';
import 'package:llm_based_sat_app/screens/language_page.dart';
import 'package:llm_based_sat_app/screens/profile/delete_account_page.dart';
import 'package:llm_based_sat_app/screens/profile/reset_settings_page.dart';
import 'package:llm_based_sat_app/screens/notifications_settings_page.dart';
import 'package:llm_based_sat_app/screens/webview_page.dart';
import 'package:llm_based_sat_app/widgets/custom_app_bar.dart';
import 'package:llm_based_sat_app/widgets/custom_button.dart';
import 'package:llm_based_sat_app/widgets/menu_item.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/main_layout.dart';
import 'help_centre_page.dart';

/// A StatelessWidget that represents the Settings Page.
/// This page displays various settings options such as Notifications, Terms & Conditions,
/// Help Centre, Reset Settings, and Delete Account options.
class SettingsPage extends StatelessWidget {
  static const Color primaryTextColor = Color(0xFF687078);
  static const Color secondaryTextColor = Color(0xFF123659);
  static const Color primaryButtonColor = Color(0xFF2F4A79);
  static const Color arrowColor = Color(0xFF1C548C);

  final Function(int) onItemTapped;
  final int selectedIndex;

  /// Creates a [SettingsPage] widget.
  /// [onItemTapped] is a callback function triggered when an item in the navigation menu is tapped.
  /// [selectedIndex] is the index of the selected item in the menu.
  SettingsPage({required this.onItemTapped, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      selectedIndex: selectedIndex,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomAppBar(
              title: "Personal Profile",
              onItemTapped: onItemTapped,
              selectedIndex: selectedIndex,
            ),
            const SizedBox(height: 10),
            // Menu item for Notifications settings.
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
              },
            ),
            // Menu item for viewing Terms & Conditions.
            MenuItem(
              title: 'Terms & Conditions',
              icon: 'assets/icons/profile/book.svg',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WebViewPage(
                      url: 'https://invincimind.com/terms-and-conditions/',
                      title: 'Terms & Conditions',
                    ),
                  ),
                );
              },
            ),
            // Menu item for accessing the Help Centre.
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
              },
            ),
            // Menu item for resetting settings.
            MenuItem(
              title: 'Reset Setting',
              icon: 'assets/icons/profile/rotate-left.svg',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ResetSettingsPage(),
                  ),
                );
              },
            ),
            // Menu item for deleting the user's account.
            MenuItem(
              title: 'Delete Account',
              icon: 'assets/icons/profile/trash.svg',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DeleteAccountPage(),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            CustomButton(
              buttonText: "Back",
              onPress: () => Navigator.pop(context),
              leftArrowPresent: true,
              rightArrowPresent: false,
              textColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
