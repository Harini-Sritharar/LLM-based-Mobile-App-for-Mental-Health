/// This file defines the `CustomAppBar` widget, which provides a reusable
/// customizable app bar for the application. It includes optional navigation
/// buttons and actions, making it adaptable for different screens.

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:llm_based_sat_app/screens/notification/notifications_page.dart';
import 'package:llm_based_sat_app/screens/notification/notifications_page.dart';
import '../screens/profile_page.dart';

/// A stateless widget that represents a custom app bar with configurable options.
///
/// This widget includes a title, optional back button, and action icons for
/// notifications and profile navigation.
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  // The title displayed in the app bar.
  final String title;

  // The color of the title and icon text.
  final Color textColor;

  // Callback for the back button action.
  final VoidCallback? onBack;

  // Callback function to handle navigation bar item taps.
  final Function(int) onItemTapped;

  // The currently selected index in the navigation bar.
  final int selectedIndex;

  // Flag to determine if the back button should be displayed.
  final bool backButton;

  /// Constructor for `CustomAppBar`.
  ///
  /// Parameters:
  /// - [title]: The title text displayed in the app bar.
  /// - [textColor]: The color of the title and icons (default is `Color(0xFF687078)`).
  /// - [onBack]: Optional callback for the back button action.
  /// - [onItemTapped]: A function to handle navigation bar item taps.
  /// - [selectedIndex]: The index of the currently selected navigation bar item.
  /// - [backButton]: A flag to control the visibility of the back button (default is true).
  const CustomAppBar({
    Key? key,
    required this.title,
    this.textColor = const Color(0xFF687078),
    this.onBack,
    required this.onItemTapped,
    required this.selectedIndex,
    this.backButton = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      // Title text configuration.
      title: Text(
        title,
        style: TextStyle(color: textColor),
      ),
      centerTitle: true, // Centers the title text.

      // Background styling.
      backgroundColor:
          Colors.transparent, // Transparent background for clean UI.
      elevation: 0, // Removes the shadow for a flat appearance.

      // Icon theme for app bar icons.
      iconTheme: IconThemeData(color: textColor),

      // Back button configuration.
      leading: backButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed:
                  onBack ?? () => Navigator.pop(context), // Default action.
            )
          : null, // No back button if `backButton` is false.

      // Action buttons on the right side of the app bar.
      actions: [
        // Notification icon button.
        IconButton(
          icon: SvgPicture.asset(
            'assets/icons/notification.svg',
            width: 28,
            height: 28,
          ),
          onPressed: () {
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
        // Profile navigation button.
        IconButton(
          icon: SvgPicture.asset(
            'assets/icons/profile.svg',
            width: 28,
            height: 28,
            colorFilter: ColorFilter.mode(textColor, BlendMode.srcIn),
          ),
          onPressed: () {
            // Navigate to the ProfilePage if the current route is not already '/profile'.
            if (ModalRoute.of(context)?.settings.name != '/profile') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage(
                    onItemTapped: onItemTapped,
                    selectedIndex: selectedIndex,
                  ),
                  settings: const RouteSettings(
                    name:
                        '/profile', // Assign a name to the route for reference.
                  ),
                ),
              );
            }
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
