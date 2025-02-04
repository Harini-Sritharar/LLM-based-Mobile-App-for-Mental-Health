import 'package:flutter/material.dart';
import 'package:llm_based_sat_app/models/chapter_interface.dart';
import 'package:llm_based_sat_app/theme/app_colours.dart';
import 'package:llm_based_sat_app/widgets/course_widgets/course_page_chapter.dart';
import 'package:llm_based_sat_app/widgets/custom_app_bar.dart';

import '../../models/firebase-exercise-uploader/interface/course_interface.dart';

class CoursePage extends StatelessWidget {
  final Course course;
  final String courseTitle;
  final List<ChapterInterface> chapters;
  final Function(int) onItemTapped; // Function to update navbar index
  final int selectedIndex; // Current selected index

  const CoursePage({
    super.key,
    required this.course,
    required this.courseTitle,
    required this.chapters,
    required this.onItemTapped,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
            title: "Course Page",
            onItemTapped: onItemTapped,
            selectedIndex: selectedIndex),
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
                    color: AppColours.brandBluePlusThree),
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
                      color: AppColours.neutralGreyMinusOne,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              Expanded(
                // Using Expanded to take remaining space for the scrollable list
                child: SingleChildScrollView(
                  child: Column(
                    children: chapters
                        .map((chapter) => CoursePageChapter(chapter: chapter))
                        .toList(), // Convert map result to a List of widgets
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
