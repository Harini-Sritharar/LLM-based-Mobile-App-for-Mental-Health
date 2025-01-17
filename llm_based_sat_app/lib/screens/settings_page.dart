import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:llm_based_sat_app/screens/notifications_page.dart';
import 'package:llm_based_sat_app/widgets/custom_app_bar.dart';
import '../widgets/main_layout.dart'; // Import MainLayout
import '../widgets/menu_item.dart';
import '../widgets/custom_button.dart';
import './language_page.dart';

class SettingsPage extends StatelessWidget {
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
            CustomAppBar(
                title: "Personal Profile",
                onItemTapped: onItemTapped,
                selectedIndex: selectedIndex),
            SizedBox(height: 10),
            MenuItem(
              title: 'Notifications',
              icon: 'assets/icons/profile/notification-bing.svg',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NotificationsPage(
                      onItemTapped: onItemTapped, // Pass function
                      selectedIndex: selectedIndex, // Pass index
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
                      onItemTapped: onItemTapped, // Pass function
                      selectedIndex: selectedIndex, // Pass index
                    ),
                  ),
                );
              },
            ),
            MenuItem(
              title: 'Terms & Conditions',
              icon: 'assets/icons/profile/book.svg',
              onTap: () {},
            ),
            MenuItem(
              title: 'Help Centre',
              icon: 'assets/icons/profile/message-question.svg',
              onTap: () {},
            ),
            MenuItem(
              title: 'Reset Setting',
              icon: 'assets/icons/profile/rotate-left.svg',
              onTap: () {},
            ),
            MenuItem(
              title: 'Delete Account',
              icon: 'assets/icons/profile/trash.svg',
              onTap: () {},
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: CustomButton(
                buttonText: "Back",
                onPress: () => Navigator.pop(context),
                leftArrowPresent: true,
                rightArrowPresent: false,
                backgroundColor: Color(0xFF1C548C),
                textColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
