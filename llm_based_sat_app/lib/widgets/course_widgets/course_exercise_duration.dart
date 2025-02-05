import 'package:flutter/material.dart';
import 'package:llm_based_sat_app/theme/app_colours.dart';

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
        Icon(Icons.videocam_outlined, color: AppColours.brandBlueMain,),
        const SizedBox(width: 8),
        Text(
          exercises,
          style: const TextStyle(
            fontSize: 14,
            color: AppColours.neutralGreyMinusOne,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 8),
        Icon(Icons.timer_sharp, color: AppColours.brandBlueMain),
        const SizedBox(width: 8),
        Text(
          duration,
          style: const TextStyle(
            fontSize: 14,
            color: AppColours.neutralGreyMinusOne,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
