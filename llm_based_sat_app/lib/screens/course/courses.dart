import 'package:flutter/material.dart';
import 'package:llm_based_sat_app/data/cache_manager.dart';
import 'package:llm_based_sat_app/firebase_helpers.dart';
import 'package:llm_based_sat_app/models/chapter_exercise_step_interface.dart';
import 'package:llm_based_sat_app/models/firebase-exercise-uploader/interface/course_interface.dart';
import 'package:llm_based_sat_app/screens/course/course_info.dart';
import 'package:llm_based_sat_app/widgets/course_widgets/course_card.dart';

import '../auth/sign_in_page.dart'; // Custom reusable widget for course cards

class Courses extends StatelessWidget {
  final Function(int) onItemTapped;
  final int selectedIndex;

  const Courses({
    Key? key,
    required this.onItemTapped,
    required this.selectedIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Courses',
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
            const Text(
              'Select a course to start.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<List<Widget>>(
                future: generateCourseCards(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Show a loading indicator while waiting for data
                    return Center(child: CircularProgressIndicator());
                  } else if (!snapshot.hasData ||
                      snapshot.data!.isEmpty ||
                      snapshot.hasError) {
                    // Handle the case where there is no data
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: Colors.redAccent,
                            size: 60,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'We’re having issues fetching courses.',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Please try again in a bit. If the issue persists, contact our team for assistance.',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }
                  // Return the ListView with the generated widgets
                  return ListView(children: snapshot.data!);
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: selectedIndex,
        onTap: onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Community',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.score),
            label: 'Score',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Courses',
          ),
        ],
      ),
    );
  }

/* Creates a dynamic `onButtonPress` function that navigates to the `CourseInfo` page with the specified parameters. */
  void Function(BuildContext) createOnButtonPress({
    required Course course,
  }) {
    return (BuildContext context) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CourseInfo(
            course: course,
            onItemTapped: onItemTapped,
            selectedIndex: selectedIndex,
          ),
        ),
      );
    };
  }

  /* Generates a list of `CourseCard` widgets dynamically based on course data. */
  Future<List<CourseCard>> generateCourseCards() async {
    try {
      // Fetch courses from the database
      List<Course> coursesDatabase = await getAllCourses();

      // Handle the case where no courses are found
      if (coursesDatabase.isEmpty) {
        print("No courses found in the database.");
        return []; // Return an empty list if no courses are found
      }

      for (final course in coursesDatabase) {
        final userProgress = await getUserCourseProgress(user!.uid, course.id);
        if (userProgress != null) {
          List<ChapterExerciseStep> progressList = [];
          for (final progressData in userProgress) {
            progressList.add(ChapterExerciseStep.fromString(progressData));
          }
          CacheManager.setValue(course.id, progressList);
        }
      }

      // Generate CourseCard widgets for each course
      return coursesDatabase.map((course) {
        return CourseCard(
          imageUrl: course.imageUrl,
          courseType: course.courseType,
          courseTitle: course.title,
          duration: course.duration,
          rating: course.rating,
          ratingsCount: course.ratingCount,
          onButtonPress: createOnButtonPress(
            course: course,
          ),
        );
      }).toList();
    } catch (e) {
      // Log and handle errors
      print("Error while generating course cards: $e");
      return []; // Return an empty list in case of an error
    }
  }
}
