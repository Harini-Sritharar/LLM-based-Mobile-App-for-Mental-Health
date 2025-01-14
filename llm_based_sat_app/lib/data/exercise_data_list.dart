
import 'package:flutter/material.dart';
import 'package:llm_based_sat_app/models/exercise_data_interface.dart';
import 'package:llm_based_sat_app/screens/home_page.dart';
import 'package:llm_based_sat_app/utils/exercise_page_caller.dart';

final List<ExerciseDataInterface> exerciseDataList = [
  ExerciseDataInterface(
    id: "A_1",
    heading: "Exercise A",
    step: "Step 1",
    description: "Look at your happy photo below. Recall positive childhood memories.",
    imageUrl: "assets/icons/exercise_page_1.png",
    buttonText: "Next Step",
    onButtonPress: (BuildContext context) {
      // Navigate to ExercisePageCaller when the button is pressed
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ExercisePageCaller(id: "A_2"),
        ),
      );
    },
    rightArrowPresent: true,
    messageText: "Leave and lose your progress. X",
  ),
  ExerciseDataInterface(
    id: "A_2",
    heading: "Exercise 2",
    step: "Step 2",
    description: "This is the second exercise.",
    imageUrl: "assets/images/exercise2.png",
    buttonText: "Start Exercise 2",
    onButtonPress: (BuildContext context) {
      // Navigate to ExercisePageCaller when the button is pressed
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
    },
    rightArrowPresent: false,
    messageText: "Focus on this step carefully.",
  ),
  // Add more exercises here...
];
