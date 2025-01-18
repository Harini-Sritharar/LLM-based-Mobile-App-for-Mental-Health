import 'package:flutter/material.dart';

class ChapterExerciseInterface {
  final String letter;
  final String title;
  final int practised;
  final int total_sessions;
  final void Function(BuildContext) onButtonPress;

  // Constructor to initialize the parameters
  ChapterExerciseInterface({
    required this.letter,
    required this.title,
    required this.practised,
    required this.total_sessions,
    required this.onButtonPress,
  });
}
