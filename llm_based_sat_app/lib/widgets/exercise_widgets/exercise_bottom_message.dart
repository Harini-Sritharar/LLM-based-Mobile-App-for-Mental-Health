import 'package:flutter/material.dart';
import 'package:llm_based_sat_app/theme/app_colours.dart';
import 'package:llm_based_sat_app/utils/exercise_timer_manager.dart';

import '../../main.dart';

/* ExerciseBottomMessage is a widget that displays a cautionary message to the user and when clicked directs the user to the Courses page and resets cached time.

## Usage
ExerciseBottomMessage(messageText: 'Leave and lose your progress.');

## Parameters
- `messageText`: A string to display as the message in the widget.
*/

class ExerciseBottomMessage extends StatelessWidget {
  final String messageText; // Text to display

  const ExerciseBottomMessage({super.key, required this.messageText});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
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
