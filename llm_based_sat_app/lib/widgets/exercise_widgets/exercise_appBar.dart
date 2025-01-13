import 'package:flutter/material.dart';

class ExerciseAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final double fontSize;
  final FontWeight fontWeight;
  final Color textColor;
  final EdgeInsetsGeometry padding;

  const ExerciseAppBar({
    Key? key,
    required this.title,
    this.fontSize = 20.0,
    this.fontWeight = FontWeight.w600,
    this.textColor = const Color(0xFF687078),
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
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
