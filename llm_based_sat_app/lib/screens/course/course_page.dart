import 'package:flutter/material.dart';
import 'package:llm_based_sat_app/models/chapter_exercise_interface.dart';
import 'package:llm_based_sat_app/models/chapter_interface.dart';
import 'package:llm_based_sat_app/widgets/course_widgets/course_page_chapter.dart';

class CoursePage extends StatelessWidget {
  final String courseTitle;
  final List<ChapterInterface> chapters;

  const CoursePage({
    super.key,
    required this.courseTitle,
    required this.chapters,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Course Page',
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
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Course: $courseTitle",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF062240)),
            ),
            const SizedBox(height: 10),
            Text(
              "Complete the minimum number of sessions in each exercise to move to the next one.",
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Text("Course exercises",
                    style: TextStyle(
                      fontSize: 18,
                    )),
                Spacer(),
                Text(
                  "Practised / Total Sessions",
                  style: TextStyle(
                    color: Color(0xFF687078),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // ...chapters.map((chapter) =>
            //   CoursePageChapter(chapterIndex: chapter., chapterTitle: chapterTitle, exercises: exercises)
            // )
            ...chapters.map((chapter) => CoursePageChapter(chapter: chapter))
          ],
        ),
      ),
    );
  }
}
