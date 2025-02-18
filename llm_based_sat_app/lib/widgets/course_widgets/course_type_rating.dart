import 'package:flutter/material.dart';
import 'package:llm_based_sat_app/theme/app_colours.dart';

class CourseTypeRating extends StatelessWidget {
  final String courseType;
  final double rating;

  const CourseTypeRating({
    super.key,
    required this.courseType,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          courseType,
          style: const TextStyle(
            fontSize: 14,
            color: AppColours.supportingYellowMain,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        Row(
          children: [
            Text(
              '$rating',
              style: const TextStyle(
                fontSize: 14,
                color: AppColours.brandBlueMinusOne,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.star, size: 16, color: Colors.amber),
          ],
        ),
      ],
    );
  }
}
