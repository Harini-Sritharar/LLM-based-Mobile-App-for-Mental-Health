import 'package:flutter/material.dart';

/// A class representing the interface for a chapter exercise.
/// It holds the data related to a specific chapter exercise such as its
/// letter, title, progress in terms of practiced sessions, and total sessions.
/// It also includes a function to handle a button press action in the UI.
class ChapterExerciseInterface {
  /// The letter identifier of the chapter exercise (e.g., "A", "B", etc.).
  final String letter;

  /// The title or name of the chapter exercise.
  final String title;

  /// The number of sessions that have been practiced for this exercise.
  final int practised;

  /// The total number of sessions available for this exercise.
  final int totalSessions;

  /// A callback function to handle a button press action, which takes the
  /// current [BuildContext] as a parameter. This function is triggered when
  /// the user interacts with the UI button.
  final void Function(BuildContext) onButtonPress;

  /// Constructor to initialize the [ChapterExerciseInterface] with the provided
  /// parameters. This constructor allows setting up the chapter's letter, title,
  /// practice progress, total sessions, and the button press callback.
  ///
  /// [letter] - The letter identifier of the chapter exercise (e.g., "A").
  /// [title] - The title or name of the chapter exercise.
  /// [practised] - The number of sessions the user has already practiced.
  /// [totalSessions] - The total number of sessions for this chapter exercise.
  /// [onButtonPress] - A callback function that is triggered when a button is pressed.
  ChapterExerciseInterface({
    required this.letter,
    required this.title,
    required this.practised,
    required this.totalSessions,
    required this.onButtonPress,
  });
}
