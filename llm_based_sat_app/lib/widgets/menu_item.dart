import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:llm_based_sat_app/theme/app_colours.dart';

class MenuItem extends StatelessWidget {
  final String title; // Title text of the menu item
  final dynamic
      icon; // Icon for the menu item, can be a String (SVG path) or IconData
  final VoidCallback onTap; // Callback function when the item is tapped
  final Color color; // Custom color for the icon and text

  const MenuItem({
    super.key,
    required this.title,
    this.icon,
    required this.onTap,
    this.color = AppColours.primaryGreyTextColor, // Default color
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: (icon != null)
          ? (icon is String)
              ? SvgPicture.asset(
                  icon,
                  width: 24,
                  height: 24,
                  colorFilter: ColorFilter.mode(
                    color,
                    BlendMode.srcIn,
                  ),
                )
              : Icon(icon, color: color)
          : null,
      title: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          color: color,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 18,
        color: color,
      ),
      onTap: onTap,
    );
  }
}
