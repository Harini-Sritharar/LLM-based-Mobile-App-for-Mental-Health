import 'dart:ui';
import 'package:flutter/material.dart';

/// A class representing the data for a specific exercise in a learning module.
/// This includes details like the exercise's ID, heading, step, description,
/// associated image, button text, and an action to perform when the button is pressed.
class ExerciseDataInterface {
  /// The unique identifier for this exercise, typically formatted as "{Exercise Letter}_{Step Number}".
  /// For example, "A_1" refers to Exercise A, Step 1.
  final String id;

  /// The heading or title of the exercise.
  final String heading;

  /// The specific step associated with the exercise.
  final String step;

  /// A brief description of the exercise, explaining what the user needs to do or learn.
  final String description;

  /// The URL of the image associated with the exercise.
  final String imageUrl;

  /// The text that appears on the button related to the exercise.
  final String buttonText;

  /// A callback function that is triggered when the button is pressed.
  /// The function receives the [BuildContext] as a parameter to perform any necessary
  /// actions in the UI.
  final void Function(BuildContext) onButtonPress;

  /// A boolean flag indicating whether the right arrow should be present in the exercise UI.
  /// This may affect the display logic for navigation or progression.
  final bool rightArrowPresent;

  /// The message text to be displayed in the exercise interface. This could be instructions
  /// or a custom message related to the exercise.
  final String messageText;

  /// Constructor to initialize the [ExerciseDataInterface] with the provided parameters.
  ///
  /// [id] - The unique identifier for the exercise, formatted as "{Exercise Letter}_{Step Number}" (e.g., "A_1").
  /// [heading] - The title or heading of the exercise.
  /// [step] - The specific step number or label for the exercise.
  /// [description] - A brief description of the exercise.
  /// [imageUrl] - The URL to the image associated with the exercise.
  /// [buttonText] - The text that appears on the button in the exercise UI.
  /// [onButtonPress] - A callback function triggered when the button is pressed, which takes [BuildContext] as a parameter.
  /// [rightArrowPresent] - A flag indicating whether the right arrow should be displayed.
  /// [messageText] - A message to display in the exercise interface, such as instructions or additional context.
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
