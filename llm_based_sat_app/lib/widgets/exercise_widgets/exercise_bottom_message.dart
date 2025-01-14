import 'package:flutter/material.dart';

class ExerciseBottomMessage extends StatelessWidget {
  const ExerciseBottomMessage();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Leave and lose your progress.',
        style: const TextStyle(fontSize: 16, color: Colors.red),
      ),
    );
  }
}
