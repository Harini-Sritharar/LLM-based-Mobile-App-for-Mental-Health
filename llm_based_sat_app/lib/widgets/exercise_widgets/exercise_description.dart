import 'package:flutter/material.dart';

class ExerciseDescription extends StatelessWidget {
  final String description;

  const ExerciseDescription({required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        description,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}
