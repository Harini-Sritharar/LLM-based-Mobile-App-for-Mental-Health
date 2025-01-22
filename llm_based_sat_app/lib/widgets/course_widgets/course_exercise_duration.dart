import 'package:flutter/material.dart';

class CourseExerciseDuration extends StatelessWidget {
  final String exercises;
  final String duration;

  const CourseExerciseDuration({
    super.key,
    required this.exercises,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.videocam_outlined, color: Color(0xFF1C548C),),
        const SizedBox(width: 8),
        Text(
          exercises,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF687078),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 8),
        Icon(Icons.timer_sharp, color: Color(0xFF1C548C)),
        const SizedBox(width: 8),
        Text(
          duration,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF687078),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
