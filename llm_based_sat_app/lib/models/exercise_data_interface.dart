import 'package:flutter/material.dart';

class ExerciseDataInterface {
  final String id; // Format: "{Exercise Letter}_{Step Number}" ... "A_1"
  final String heading;
  final String step;
  final String description;
  final String imageUrl;
  final String buttonText;
  final void Function(BuildContext) onButtonPress;
  final bool rightArrowPresent;
  final String messageText;

  ExerciseDataInterface({
    required this.id,
    required this.heading,
    required this.step,
    required this.description,
    required this.imageUrl,
    required this.buttonText,
    required this.onButtonPress,
    required this.rightArrowPresent,
    required this.messageText,
  });
}
