import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:llm_based_sat_app/screens/payment_option_page.dart';
import '../widgets/main_layout.dart';
import 'edit_profile.dart';
import 'settings_page.dart';
import 'ultimate_goal_page.dart';
import 'childhood_photos_page.dart';
import '../widgets/custom_app_bar.dart';
import '../theme/app_colours.dart';

class ProfilePage extends StatelessWidget {
  final Function(int) onItemTapped; // Receive function to update navbar index
  final int selectedIndex; // Keep track of selected index

  const ProfilePage(
      {super.key, required this.onItemTapped, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      selectedIndex: selectedIndex,
      body: Column(
        children: [
          CustomAppBar(title: "Profile Page"),
          SizedBox(height: 20),
          CircleAvatar(
            radius: 50,
            backgroundColor: AppColours.avatarBackgroundColor,
            child: Icon(Icons.person,
                size: 80, color: AppColours.avatarForegroundcolor),
          ),
          const SizedBox(height: 10),
          const Text(
            'Neophytos Polydorou',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColours.primaryGreyTextColor,
            ),
          ),
          const Text(
            'neophytos@invincimind.com',
            style: TextStyle(
              fontSize: 16,
              color: AppColours.primaryGreyTextColor,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              children: [
                _buildMenuItem(
                  context,
                  'Edit Profile',
                  'assets/icons/user_edit.svg',
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditProfilePage(
                          onItemTapped: onItemTapped, // Pass function
                          selectedIndex: selectedIndex, // Pass index
                        ),
                      ),
                    );
                  },
                ),
                _buildMenuItem(
                  context,
                  'Settings',
                  'assets/icons/setting-2.svg',
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SettingsPage(
                          onItemTapped: onItemTapped, // Pass function
                          selectedIndex: selectedIndex, // Pass index
                        ),
                      ),
                    );
                  },
                ),
                _buildMenuItem(context, 'Ultimate Goal', 'assets/icons/cup.svg',
                    () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UltimateGoalPage(
                        onItemTapped: onItemTapped, // Pass function
                        selectedIndex: selectedIndex, // Pass index
                      ),
                    ),
                  );
                }),
                _buildMenuItem(
                    context, 'Childhood photos', 'assets/icons/gallery.svg',
                    () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChildhoodPhotosPage(
                        onItemTapped: onItemTapped, // Pass function
                        selectedIndex: selectedIndex, // Pass index
                      ),
                    ),
                  );
                }),
                _buildMenuItem(
                    context, 'Payment Option', 'assets/icons/empty-wallet.svg',
                    () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentOptionPage(
                        onItemTapped: onItemTapped, // Pass function
                        selectedIndex: selectedIndex, // Pass index
                      ),
                    ),
                  );
                }),
                _buildMenuItem(
                    context, 'Invite Friends', 'assets/icons/send.svg', () {}),
                _buildMenuItem(
                    context, 'Logout', 'assets/icons/logout.svg', () {}),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper function to build a menu item in the profile page.
  // Takes in context, menu item string, icon and the event that should happen once the menu item iss tapped on.
  Widget _buildMenuItem(
      BuildContext context, String title, dynamic icon, VoidCallback onTap) {
    return ListTile(
      leading: (icon is String)
          ? SvgPicture.asset(
              icon,
              width: 24,
              height: 24,
              colorFilter: const ColorFilter.mode(
                  AppColours.primaryGreyTextColor, BlendMode.srcIn),
            )
          : Icon(icon, color: AppColours.primaryGreyTextColor),
      title: Text(
        title,
        style: const TextStyle(
            fontSize: 18, color: AppColours.primaryGreyTextColor),
      ),
      trailing: const Icon(Icons.arrow_forward_ios,
          size: 18, color: AppColours.primaryGreyTextColor),
      onTap: onTap,
    );
  }
}
