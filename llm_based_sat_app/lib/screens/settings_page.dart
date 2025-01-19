import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:llm_based_sat_app/screens/language_page.dart';
import 'package:llm_based_sat_app/screens/notifications_page.dart';
import 'package:llm_based_sat_app/widgets/custom_app_bar.dart';
import '../widgets/main_layout.dart'; // Import MainLayout

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
            _buildSettingsItem(context, 'Notifications',
                'assets/icons/profile/notification-bing.svg', () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotificationsPage(
                    onItemTapped: onItemTapped,
                    selectedIndex: selectedIndex,
                  ),
                ),
              );
            }),
            _buildSettingsItem(context, 'Security',
                'assets/icons/profile/security-safe.svg', () {}),
            _buildSettingsItem(context, 'Accessibility',
                'assets/icons/profile/accessibility.svg', () {}),
            _buildSettingsItem(
                context, 'Language', 'assets/icons/profile/language-circle.svg',
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
            }),
            _buildSettingsItem(context, 'Terms & Conditions',
                'assets/icons/profile/book.svg', () {}),
            _buildSettingsItem(context, 'Help Centre',
                'assets/icons/profile/message-question.svg', () {}),
            _buildSettingsItem(context, 'Reset Setting',
                'assets/icons/profile/rotate-left.svg', () {}),
            _buildSettingsItem(context, 'Delete Account',
                'assets/icons/profile/trash.svg', () {}),
            SizedBox(height: 20),
            _buildBackButton(context),
          ],
        ),
      ),
    );
  }

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

  Widget _buildBackButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
          onPressed: () => Navigator.pop(context),
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
                      left: 20), // Adjust left padding if needed
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
