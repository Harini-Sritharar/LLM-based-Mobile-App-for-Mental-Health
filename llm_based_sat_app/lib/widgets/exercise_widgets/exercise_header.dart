import 'package:flutter/material.dart';

class ExerciseHeading extends StatelessWidget {
  final String heading;

  const ExerciseHeading({required this.heading});

  @override
  Widget build(BuildContext context) {
    return Text(
      heading,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }
}
