import 'package:flutter/material.dart';
import 'package:llm_based_sat_app/models/exercise_data_interface.dart';
import 'package:llm_based_sat_app/utils/exercise_page_caller.dart';

final List<ExerciseDataInterface> exerciseDataList = [
  ExerciseDataInterface(
    id: "A_1",
    heading: "Exercise A",
    step: "Step 1",
    description:
        "Look at your happy photo below. Recall positive childhood memories.",
    imageUrl: "assets/icons/exercise_images/exercise_page_A_1.png",
    buttonText: "Next Step",
    onButtonPress: (BuildContext context) {
      // Navigate to ExercisePageCaller when the button is pressed
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const ExercisePageCaller(id: "A_2"),
        ),
        (route) => false,
      );
    },
    rightArrowPresent: true,
    messageText: "Leave and lose your progress. X",
  ),
  ExerciseDataInterface(
    id: "A_2",
    heading: "Exercise A",
    step: "Step 2",
    description:
        "Look at your unhappy photos. Recall negative childhood memories.",
    imageUrl: "assets/icons/exercise_images/exercise_page_A_2.png",
    buttonText: "Next Step",
    rightArrowPresent: true,
    onButtonPress: (BuildContext context) {
      // Navigate to ExercisePageCaller when the button is pressed
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const ExercisePageCaller(id: "A_2"),
        ),
        (route) => false,
      );
    },
    messageText: "Leave and lose your progress. X",
  ),
  // Add more exercises here...
];
