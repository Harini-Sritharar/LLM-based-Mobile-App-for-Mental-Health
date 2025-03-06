import 'package:flutter/material.dart';
import 'package:llm_based_sat_app/theme/app_colours.dart';

/// A custom AppBar widget for exercise screens.
class ExerciseAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final double fontSize;
  final FontWeight fontWeight;
  final Color textColor;

  const ExerciseAppBar({
    Key? key,
    required this.title,
    this.fontSize = 20.0,
    this.fontWeight = FontWeight.w600,
    this.textColor = AppColours.neutralGreyMinusOne,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: textColor,
        ),
      ),
      centerTitle: true,
      automaticallyImplyLeading: false,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
