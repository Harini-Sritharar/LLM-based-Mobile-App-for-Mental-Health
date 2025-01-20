import 'package:flutter/material.dart';
import 'package:llm_based_sat_app/theme/app_colours.dart';

class CourseCard extends StatelessWidget {
  final String imageUrl;
  final String courseType;
  final String courseTitle;
  final String duration;
  final double rating;
  final int ratingsCount;
  final void Function(BuildContext) onButtonPress;

  const CourseCard({
    super.key,
    required this.imageUrl,
    required this.courseType,
    required this.courseTitle,
    required this.duration,
    required this.rating,
    required this.ratingsCount,
    required this.onButtonPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onButtonPress(context),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF4F9FF), // Light blue background
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                imageUrl,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    courseType,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColours.supportingYellowMain,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    courseTitle,
                    style: const TextStyle(
                      fontSize: 18,
                      color: AppColours.brandBluePlusTwo,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Duration: $duration',
                    style: const TextStyle(fontSize: 14, color: Color(0xFF32A666)),
                  ),
                  const SizedBox(height: 4),
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
                      const SizedBox(width: 8),
                      Text(
                        '$ratingsCount ratings',
                        style: const TextStyle(fontSize: 14, color: AppColours.brandBlueMinusOne),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}