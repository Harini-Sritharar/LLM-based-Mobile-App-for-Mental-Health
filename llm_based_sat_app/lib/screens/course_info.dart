import 'package:flutter/material.dart';
import 'package:llm_based_sat_app/widgets/course_widgets/course_exercise_duration.dart';
import 'package:llm_based_sat_app/widgets/course_widgets/course_type_rating.dart';

class CourseInfo extends StatelessWidget {
  final Function(int) onItemTapped;
  final int selectedIndex;
  final String courseType;
  final double rating;
  final String courseTitle;

  const CourseInfo({
    super.key,
    required this.onItemTapped,
    required this.selectedIndex,
    this.courseType = "Core",
    this.rating = 4.2,
    this.courseTitle = "Self-attachment",
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Course Info',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Handle notification click
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              // Navigate to profile page
            },
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CourseTypeRating(courseType: courseType, rating: rating),
            const SizedBox(height: 10),
            Text(
              courseTitle,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 14),
            CourseExerciseDuration(exercises: "10 Exercises", duration: '2 weeks'),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.book),
              title: const Text("Course Material"),
              onTap: () {
                // Navigate to course material widget
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text("Schedule"),
              onTap: () {
                // Navigate to schedule widget
              },
            ),
            ListTile(
              leading: const Icon(Icons.group),
              title: const Text("Instructors"),
              onTap: () {
                // Navigate to instructors widget
              },
            ),
          ],
        ),
      ),
    );
  }
}
