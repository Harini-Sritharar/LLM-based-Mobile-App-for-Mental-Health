import 'package:flutter/material.dart';

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
        style: const TextStyle(fontSize: 16, color: Color(0xFF8F959B)),
      ),
    );
  }
}
