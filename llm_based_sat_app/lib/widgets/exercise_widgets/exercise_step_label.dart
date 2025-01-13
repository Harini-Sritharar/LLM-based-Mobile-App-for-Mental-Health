import 'package:flutter/material.dart';

class ExerciseStepLabel extends StatelessWidget {
  final int stepNumber;

  const ExerciseStepLabel({required this.stepNumber});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Step $stepNumber',
      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    );
  }
}
