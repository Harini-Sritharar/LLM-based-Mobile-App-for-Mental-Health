/// This file defines the `CustomAppBar` widget, which provides a reusable
/// customizable app bar for the application. It includes optional navigation
/// buttons and actions, making it adaptable for different screens.

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:llm_based_sat_app/chatbot/chatpage.dart';
import 'package:llm_based_sat_app/screens/notification/notifications_page.dart';
import 'package:llm_based_sat_app/theme/app_colours.dart';
import '../screens/profile/profile_page.dart';

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
    this.textColor = AppColours.neutralGreyMinusOne, // Default text color
    this.onBack,
    required this.onItemTapped,
    required this.selectedIndex,
    this.backButton = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      // Title text configuration.
      title: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          title,
          style: TextStyle(color: textColor),
        ),
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

      actions: [
        Builder(
          builder: (context) {
            return IconButton(
              icon: Icon(Icons.more_vert, color: textColor),
              onPressed: () async {
                final RenderBox button =
                    context.findRenderObject() as RenderBox;
                final RenderBox overlay =
                    Overlay.of(context).context.findRenderObject() as RenderBox;
                final Offset offset =
                    button.localToGlobal(Offset.zero, ancestor: overlay);
                final result = await showMenu<int>(
                  context: context,
                  position: RelativeRect.fromLTRB(
                    offset.dx,
                    offset.dy + button.size.height,
                    offset.dx + button.size.width,
                    offset.dy + button.size.height + 200,
                  ),
                  items: <PopupMenuEntry<int>>[
                    PopupMenuItem<int>(
                      value: 0,
                      child: ListTile(
                        leading: Icon(Icons.chat, color: textColor),
                        title: Text('Chat', style: TextStyle(color: textColor)),
                      ),
                    ),
                    PopupMenuItem<int>(
                      value: 1,
                      child: ListTile(
                        leading: SvgPicture.asset(
                          'assets/icons/notification.svg',
                          width: 24,
                          height: 24,
                          colorFilter:
                              ColorFilter.mode(textColor, BlendMode.srcIn),
                        ),
                        title: Text('Notifications',
                            style: TextStyle(color: textColor)),
                      ),
                    ),
                    PopupMenuItem<int>(
                      value: 2,
                      child: ListTile(
                        leading: SvgPicture.asset(
                          'assets/icons/profile.svg',
                          width: 24,
                          height: 24,
                          colorFilter:
                              ColorFilter.mode(textColor, BlendMode.srcIn),
                        ),
                        title:
                            Text('Profile', style: TextStyle(color: textColor)),
                      ),
                    ),
                  ],
                );

                switch (result) {
                  case 0:
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Chatpage()),
                    );
                    break;
                  case 1:
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NotificationsPage(
                          onItemTapped: onItemTapped,
                          selectedIndex: selectedIndex,
                        ),
                      ),
                    );
                    break;
                  case 2:
                    if (ModalRoute.of(context)?.settings.name != '/profile') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfilePage(
                            onItemTapped: onItemTapped,
                            selectedIndex: selectedIndex,
                          ),
                          settings: const RouteSettings(
                            name: '/profile',
                          ),
                        ),
                      );
                    }
                    break;
                }
              },
            );
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
