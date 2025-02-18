import 'package:flutter/material.dart';
import 'package:llm_based_sat_app/theme/app_colours.dart';

class ExerciseStepLabel extends StatelessWidget {
  final String step;

  const ExerciseStepLabel({super.key, required this.step});

  @override
  Widget build(BuildContext context) {
    return Text(
      step,
      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.normal, color: AppColours.brandBluePlusThree),
    );
  }
}
