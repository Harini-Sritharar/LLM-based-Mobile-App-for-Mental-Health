import 'package:flutter/material.dart';

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
            color: Color(0xFF8C7F1C),
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
                color: Color(0xFF326CA6),
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
