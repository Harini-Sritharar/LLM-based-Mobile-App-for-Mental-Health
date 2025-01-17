import 'package:flutter/material.dart';
import 'package:llm_based_sat_app/data/exercise_data_list.dart';
import 'package:llm_based_sat_app/models/exercise_data_interface.dart';
import 'package:llm_based_sat_app/screens/exercise_page.dart';

/* ExercisePageCaller is a utility widget that fetches and
 displays an ExercisePage based on a unique ID passed to it. */

class ExercisePageCaller extends StatelessWidget {
  final String id; // The ID of the exercise to display.

  const ExercisePageCaller({super.key, required this.id});

  ExerciseDataInterface getExerciseById(String id) {
  return exerciseDataList.firstWhere((exercise) => exercise.id == id);
}

  @override
  Widget build(BuildContext context) {
    final data = getExerciseById(id);

    return ExercisePage(
      heading: data.heading,
      step: data.step,
      description: data.description,
      imageUrl: data.imageUrl,
      buttonText: data.buttonText,
      onButtonPress: data.onButtonPress,
      rightArrowPresent: data.rightArrowPresent,
      messageText: data.messageText,
    );
  }
}
