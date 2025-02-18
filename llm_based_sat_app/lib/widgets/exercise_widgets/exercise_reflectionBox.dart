import 'package:flutter/material.dart';
import 'package:llm_based_sat_app/theme/app_colours.dart';

class ExerciseReflectionBox extends StatelessWidget {
  final String hintText;

  const ExerciseReflectionBox(String s, {Key? key, required this.hintText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColours.brandBlueMinusFour, // Light blue background
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[600]),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(12),
        ),
        maxLines: 5,
      ),
    );
  }
}
