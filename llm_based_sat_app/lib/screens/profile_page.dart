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

/// A stateless widget that represents the Profile Page of the application.
///
/// This page includes a profile avatar, user information, and navigation options
/// for various user-related actions such as editing the profile, accessing settings,
/// viewing goals, and more.
///
/// The `ProfilePage` widget expects:
/// - A callback function to handle bottom navigation (`onItemTapped`).
/// - The currently selected index for the navigation bar (`selectedIndex`).

class ProfilePage extends StatelessWidget {
  /// Callback function to handle bottom navigation updates.
  final Function(int) onItemTapped;

  /// The index of the currently selected navigation bar item.
  final int selectedIndex;

  /// Constructor for the `ProfilePage` widget.
  ///
  /// - `onItemTapped`: A required function to handle navigation updates.
  /// - `selectedIndex`: A required integer to track the selected navbar index.
  const ProfilePage({
    super.key,
    required this.onItemTapped,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      selectedIndex:
          selectedIndex, // Pass the selected navbar index to MainLayout.
      body: Container(
        color: AppColours.backgroundColor, // Set background color for the page.
        child: Column(
          children: [
            /// Custom app bar for the profile page.
            CustomAppBar(title: "Profile Settings"),

            /// Spacer to add vertical space between the app bar and the profile avatar.
            SizedBox(height: 20),

            /// Profile avatar with a placeholder icon.
            CircleAvatar(
              radius: 50,
              backgroundColor: AppColours.avatarBackgroundColor,
              child: Icon(
                Icons.person,
                size: 80,
                color: AppColours.avatarForegroundcolor,
              ),
            ),
            const SizedBox(height: 10),

            /// Display the user's name.
            const Text(
              'Neophytos Polydorou',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColours.primaryGreyTextColor,
              ),
            ),

            /// Display the user's email address.
            const Text(
              'neophytos@invincimind.com',
              style: TextStyle(
                fontSize: 16,
                color: AppColours.primaryGreyTextColor,
              ),
            ),
            const SizedBox(height: 20),

            /// List of menu items for navigation to different pages.
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
                            onItemTapped: onItemTapped,
                            selectedIndex: selectedIndex,
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
                            onItemTapped: onItemTapped,
                            selectedIndex: selectedIndex,
                          ),
                        ),
                      );
                    },
                  ),
                  _buildMenuItem(
                    context,
                    'Ultimate Goal',
                    'assets/icons/cup.svg',
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UltimateGoalPage(
                            onItemTapped: onItemTapped,
                            selectedIndex: selectedIndex,
                          ),
                        ),
                      );
                    },
                  ),
                  _buildMenuItem(
                    context,
                    'Childhood Photos',
                    'assets/icons/gallery.svg',
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChildhoodPhotosPage(
                            onItemTapped: onItemTapped,
                            selectedIndex: selectedIndex,
                          ),
                        ),
                      );
                    },
                  ),
                  _buildMenuItem(
                    context,
                    'Payment Option',
                    'assets/icons/empty-wallet.svg',
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaymentOptionPage(
                            onItemTapped: onItemTapped,
                            selectedIndex: selectedIndex,
                          ),
                        ),
                      );
                    },
                  ),
                  _buildMenuItem(
                    context,
                    'Invite Friends',
                    'assets/icons/send.svg',
                    () {
                      // Logic for inviting friends goes here.
                    },
                  ),
                  _buildMenuItem(
                    context,
                    'Logout',
                    'assets/icons/logout.svg',
                    () {
                      // Logic for logging out goes here.
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Helper function to build a menu item widget.
  ///
  /// - [context]: The `BuildContext` of the current widget.
  /// - [title]: The title text to display in the menu item.
  /// - [icon]: The icon to display, which can be an asset path or a built-in `IconData`.
  /// - [onTap]: The callback function to execute when the menu item is tapped.
  ///
  /// Returns a `ListTile` widget with the specified parameters.

  Widget _buildMenuItem(
      BuildContext context, String title, dynamic icon, VoidCallback onTap) {
    return ListTile(
      leading: (icon is String)
          ? SvgPicture.asset(
              icon,
              width: 24,
              height: 24,
              colorFilter: const ColorFilter.mode(
                AppColours.primaryGreyTextColor,
                BlendMode.srcIn,
              ),
            )
          : Icon(icon, color: AppColours.primaryGreyTextColor),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          color: AppColours.primaryGreyTextColor,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 18,
        color: AppColours.primaryGreyTextColor,
      ),
      onTap: onTap,
    );
  }
}
