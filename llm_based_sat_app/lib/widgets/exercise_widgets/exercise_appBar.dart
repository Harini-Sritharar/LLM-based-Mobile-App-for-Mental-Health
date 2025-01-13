import 'package:flutter/material.dart';

class ExerciseAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color backgroundColor;
  final double fontSize;
  final FontWeight fontWeight;
  final Color textColor;
  final EdgeInsetsGeometry padding;

  const ExerciseAppBar({
    Key? key,
    required this.title,
    this.backgroundColor = Colors.blueAccent,
    this.fontSize = 20.0,
    this.fontWeight = FontWeight.bold,
    this.textColor = Colors.white,
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      title: Padding(
        padding: padding,
        child: Text(
          title,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: textColor,
          ),
        ),
      ),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
