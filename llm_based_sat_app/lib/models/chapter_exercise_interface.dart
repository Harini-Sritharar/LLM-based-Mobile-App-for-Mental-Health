import 'package:flutter/material.dart';

class ChapterExerciseInterface {
  final String letter;
  final String title;
  final int practised;
  final int totalSessions;
  final void Function(BuildContext) onButtonPress;

  // Constructor to initialize the parameters
  ChapterExerciseInterface({
    required this.letter,
    required this.title,
    required this.practised,
    required this.totalSessions,
    required this.onButtonPress,
  });
}
