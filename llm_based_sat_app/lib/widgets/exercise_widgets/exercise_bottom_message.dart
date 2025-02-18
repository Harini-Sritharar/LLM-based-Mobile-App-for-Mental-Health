import 'package:flutter/material.dart';
import 'package:llm_based_sat_app/theme/app_colours.dart';

/* ExerciseBottomMessage is a widget that displays a cautionary message to the user.

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
    return Center(
      child: Text(
        messageText,
        style: TextStyle(fontSize: 13, color: AppColours.neutralGreyMinusFour),
      ),
    );
  }
}
