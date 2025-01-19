import 'package:flutter/material.dart';
import 'package:llm_based_sat_app/models/chapter_exercise_interface.dart';
import 'package:llm_based_sat_app/models/chapter_interface.dart';
import 'package:llm_based_sat_app/screens/course_page.dart';
import 'package:llm_based_sat_app/utils/exercise_page_caller.dart';
import 'package:llm_based_sat_app/widgets/course_widgets/course_exercise_duration.dart';
import 'package:llm_based_sat_app/widgets/course_widgets/course_type_rating.dart';
import 'package:llm_based_sat_app/widgets/course_widgets/pre_course_list.dart';
import 'package:llm_based_sat_app/widgets/expandable_text.dart';

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
            CourseExerciseDuration(
                exercises: "10 Exercises", duration: '2 weeks'),
            const SizedBox(height: 20),
            ExpandableText(
                text:
                    "Self-attachment course allows you to practise the core exercises necessary for other courses. This course if important because you create a connection and an affectional bond with your childhood self. Self-attachment course allows you to practise the core exercises necessary for other courses. This course if important because you create a connection and an affectional bond with your childhood self."),
            const SizedBox(height: 40),
            PreCourseList(
              prerequisites: [],
              onUploadChildhoodPhotosPressed: (BuildContext context) {},
              onWatchIntroductoryVideoPressed: (BuildContext context) {},
              onStartCoursePressed: (BuildContext context) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CoursePage(
                      courseTitle: courseTitle,
                      chapters: getChapters(),
                    ),
                  ),
                );
              },
              watchedIntroductoryVideo: true,
              childhoodPhotosUploaded: true,
            )
          ],
        ),
      ),
    );
  }

  getChapters() {
    return [
      ChapterInterface(
          chapterNumber: 01,
          isLocked: false,
          chapterTitle: "Companionate connection",
          exercises: [
            ChapterExerciseInterface(
              letter: "A",
              title: "Initial Connection",
              practised: 3,
              totalSessions: 14,
              onButtonPress: (BuildContext context) {
                // Navigate to ExercisePageCaller when the button is pressed
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ExercisePageCaller(id: "A_1"),
                  ),
                );
              },
            ),
            ChapterExerciseInterface(
                letter: "B",
                title: "Positive Recall",
                practised: 0,
                totalSessions: 14,
                onButtonPress: (BuildContext context) {}),
            ChapterExerciseInterface(
                letter: "C",
                title: "Negative Recall",
                practised: 0,
                totalSessions: 14,
                onButtonPress: (BuildContext context) {})
          ]),
      ChapterInterface(
          chapterNumber: 02,
          isLocked: true,
          chapterTitle: "Loving relationship",
          exercises: [
            ChapterExerciseInterface(
              letter: "D",
              title: "Affectionate Singing",
              practised: 0,
              totalSessions: 0,
              onButtonPress: (BuildContext context) {
                // Navigate to ExercisePageCaller when the button is pressed
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ExercisePageCaller(id: "A_2"),
                  ),
                );
              },
            ),
            ChapterExerciseInterface(
                letter: "E",
                title: "Expressing Love",
                practised: 0,
                totalSessions: 0,
                onButtonPress: (BuildContext context) {}),
            ChapterExerciseInterface(
                letter: "F",
                title: "Vow to care",
                practised: 0,
                totalSessions: 0,
                onButtonPress: (BuildContext context) {})
          ])
    ];
  }
}
