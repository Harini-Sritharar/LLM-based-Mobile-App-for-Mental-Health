import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:llm_based_sat_app/data/cache_manager.dart';
import 'package:llm_based_sat_app/firebase/firebase_courses.dart';
import 'package:llm_based_sat_app/models/firebase-exercise-uploader/interface/course_interface.dart';
import 'package:llm_based_sat_app/models/firebase-exercise-uploader/interface/exercise_interface.dart';
import 'package:llm_based_sat_app/theme/app_colours.dart';
import 'package:llm_based_sat_app/utils/exercise_helper_functions.dart';
import 'package:llm_based_sat_app/utils/exercise_timer_manager.dart';

import '../../main.dart';

/* ExerciseBottomMessage is a widget that displays a cautionary message to the user and when clicked directs the user to the Courses page and resets cached time. */

class ExerciseBottomMessage extends StatelessWidget {
  final String messageText; // Text to display
  final String userUID;
  final Exercise exercise;
  final Course course;
  final String step;

  const ExerciseBottomMessage(
      {super.key,
      required this.messageText,
      required this.userUID,
      required this.exercise,
      required this.course,
      required this.step});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        // Save unfinished exercise data
        await saveUnfinishedExercise(
            userUID,
            course.id,
            exercise.id,
            CacheManager.getValue(
                "${exercise.id}/${getSessions(exercise, course) + 1}/TimeStamp"),
            Timestamp.now(),
            step);

        print("UserUID: $userUID");

        // Reset the timer
        ExerciseTimerManager().stopTimer();
        ExerciseTimerManager().resetTimer();
        print("Time elapsed: ${ExerciseTimerManager().elapsedTimeMillis}");
        // Reset the navigation stack to Courses
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => MainScreen(initialIndex: 4),
          ),
          (route) => false,
        );
      },
      child: Center(
        child: Text(
          messageText,
          style:
              TextStyle(fontSize: 13, color: AppColours.neutralGreyMinusFour),
        ),
      ),
    );
  }
}
