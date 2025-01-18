import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:llm_based_sat_app/screens/payment_option_page.dart';
import 'package:llm_based_sat_app/screens/auth/sign_in_page.dart';
import '../widgets/main_layout.dart';
import 'edit_profile.dart';
import 'settings_page.dart';
import 'ultimate_goal_page.dart';
import 'childhood_photos_page.dart';
import '../widgets/custom_app_bar.dart';
import '../theme/app_colours.dart';
import '../widgets/menu_item.dart';

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
            CustomAppBar(
                title: "Profile Settings",
                onItemTapped: onItemTapped,
                selectedIndex: selectedIndex),

            /// Spacer to add vertical space between the app bar and the profile avatar.
            SizedBox(height: 20),

            /// Profile avatar with a placeholder icon.
            CircleAvatar(
              radius: 50,
              backgroundColor: AppColours.avatarBackgroundColor,
              child: Icon(
                Icons.person,
                size: 80,
                color: AppColours.avatarForegroundColor,
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
                  MenuItem(
                    title: "Edit Profile",
                    icon: 'assets/icons/user_edit.svg',
                    onTap: () {
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
                  MenuItem(
                    title: "Settings",
                    icon: 'assets/icons/setting-2.svg',
                    onTap: () {
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
                  MenuItem(
                    title: "Ultimate Goal",
                    icon: 'assets/icons/cup.svg',
                    onTap: () {
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
                  MenuItem(
                    title: "Childhood Photos",
                    icon: 'assets/icons/gallery.svg',
                    onTap: () {
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
                  MenuItem(
                    title: "Payment Option",
                    icon: 'assets/icons/empty-wallet.svg',
                    onTap: () {
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
                  MenuItem(
                    title: "Invite Friends",
                    icon: 'assets/icons/send.svg',
                    onTap: () {
                      // Logic for inviting friends goes here.
                    },
                  ),
                  MenuItem(
                    title: "Logout",
                    icon: 'assets/icons/logout.svg',
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Confirm Logout"),
                            content: Text("Are you sure you want to log out?"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  // Close the dialog without logging out
                                  Navigator.of(context).pop();
                                },
                                child: Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: () {
                                  // Log out and navigate to SignInPage
                                  Navigator.of(context)
                                      .pop(); // Close the dialog
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SignInPage()),
                                  );
                                },
                                child: const Text(
                                  "Logout",
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          );
                        },
                      );
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
}
