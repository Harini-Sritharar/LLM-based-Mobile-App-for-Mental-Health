/// This file defines the `MenuItem` widget, which represents a reusable menu item
/// that can display an icon, a title, and trigger an action when tapped. The widget
/// supports both SVG icons and standard Flutter icons.

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:llm_based_sat_app/theme/app_colours.dart';

/// A stateless widget that represents a single menu item with an icon, title, and action.
///
/// The `MenuItem` widget is customizable with options for icons, colors, and a tap action.
class MenuItem extends StatelessWidget {
  // The title text of the menu item.
  final String title;

  // The icon for the menu item, which can be an SVG file path (String) or an IconData.
  final dynamic icon;

  // Callback function to be executed when the menu item is tapped.
  final VoidCallback onTap;

  // Custom color for the icon and title text.
  final Color color;

  /// Constructor for `MenuItem`.
  ///
  /// Parameters:
  /// - [title]: The text to display for the menu item.
  /// - [icon]: The icon to display (optional, can be an SVG path or IconData).
  /// - [onTap]: The action to perform when the menu item is tapped.
  /// - [color]: Custom color for the icon and text (default is `AppColours.secondaryBlueTextColor`).
  const MenuItem({
    super.key,
    required this.title,
    this.icon,
    required this.onTap,
    this.color = AppColours.brandBluePlusTwo, // Default color
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      // Display the leading icon if provided.
      leading: (icon != null)
          ? (icon is String)
              ? SvgPicture.asset(
                  icon,
                  width: 24,
                  height: 24,
                  colorFilter: ColorFilter.mode(
                    color,
                    BlendMode.srcIn, // Applies the custom color to the icon.
                  ),
                )
              : Icon(icon, color: color) // Standard Flutter icon.
          : null, // No leading icon if not provided.

      // Display the title of the menu item.
      title: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          color: color, // Applies the custom color to the text.
        ),
      ),

      // Trailing SVG icon for the menu item.
      trailing: SvgPicture.asset(
        'assets/icons/menuitemicon.svg',
      ),

      // Action to perform when the menu item is tapped.
      onTap: onTap,
    );
  }
}
