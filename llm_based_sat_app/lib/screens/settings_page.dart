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

class SettingsPage extends StatelessWidget {
  static const Color primaryTextColor = Color(0xFF687078);
  static const Color secondaryTextColor = Color(0xFF123659);
  static const Color primaryButtonColor = Color(0xFF2F4A79);
  static const Color arrowColor = Color(0xFF1C548C);

  final Function(int) onItemTapped;
  final int selectedIndex;

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

            MenuItem(
              title: 'Security',
              icon: 'assets/icons/profile/security-safe.svg',
              onTap: () {},
            ),

            MenuItem(
              title: 'Accessibility',
              icon: 'assets/icons/profile/accessibility.svg',
              onTap: () {},
            ),

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
              },
            ),

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
            _buildSettingsItem(
              context,
              'Reset Setting',
              'assets/icons/profile/rotate-left.svg',
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ResetSettingsPage(),
                  ),
                );
              },
            ),
            _buildSettingsItem(
              context,
              'Delete Account',
              'assets/icons/profile/trash.svg',
              () {
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
