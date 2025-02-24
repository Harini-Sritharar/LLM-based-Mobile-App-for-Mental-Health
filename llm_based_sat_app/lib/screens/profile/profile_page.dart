import 'package:flutter/material.dart';
import 'package:llm_based_sat_app/firebase/firebase_auth_services.dart';
import 'package:llm_based_sat_app/firebase/firebase_helpers.dart';
import 'package:llm_based_sat_app/screens/payments/payment_option_page.dart';
import 'package:llm_based_sat_app/screens/auth/sign_in_page.dart';
import 'package:llm_based_sat_app/utils/user_provider.dart';
import 'package:llm_based_sat_app/widgets/profile_widgets/profile_avatar.dart';
import '../../widgets/main_layout.dart';
import 'edit_profile.dart';
import '../payments/manage_plan_page.dart';
import '../settings_page.dart';
import '../ultimate_goal_page.dart';
import 'childhood_photos_page.dart';
import '../../widgets/custom_app_bar.dart';
import '../../theme/app_colours.dart';
import '../../widgets/menu_item.dart';
import 'package:provider/provider.dart';
import '../../utils/profile_notifier.dart';

class ProfilePage extends StatelessWidget {
  final Function(int) onItemTapped;
  final int selectedIndex;

  const ProfilePage({
    super.key,
    required this.onItemTapped,
    required this.selectedIndex,
  });

  void _signOut(BuildContext context) async {
    final FirebaseAuthService _auth = FirebaseAuthService();

    await _auth.signOut();
    Navigator.of(context).pop();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SignInPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    String userName = userProvider.getName();
    String? userEmail = userProvider.email;
    return MainLayout(
      selectedIndex: selectedIndex,
      body: Container(
        color: AppColours.white,
        child: Column(
          children: [
            CustomAppBar(
              title: "Profile Settings",
              onItemTapped: onItemTapped,
              selectedIndex: selectedIndex,
            ),
            const SizedBox(height: 20),
            ProfileAvatar(),
            const SizedBox(height: 10),
            buildText(userName),
           
            Text(
              userEmail ?? "No email provided",
              style: const TextStyle(
                fontSize: 16,
                color: AppColours.neutralGreyMinusOne,
              ),
            ),
            const SizedBox(height: 20),
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
                      ).then((_) {
                        // Notify profile updates when returning to this page
                        context.read<ProfileNotifier>().notifyProfileUpdated();
                      });
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
                    title: "Manage Plan",
                    icon: 'assets/icons/empty-wallet.svg',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ManagePlanPage(
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
                                  Navigator.of(context).pop();
                                },
                                child: Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: () => _signOut(context),
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

  Widget buildText(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: AppColours.neutralGreyMinusOne,
      ),
    );
  }
}
