import 'package:flutter/material.dart';
import 'package:llm_based_sat_app/utils/user_provider.dart';
import 'package:provider/provider.dart';
import '../../data/cache_manager.dart';
import '../../firebase/firebase_courses.dart';
import '../../models/chapter_exercise_step_interface.dart';
import '../../models/firebase-exercise-uploader/interface/course_interface.dart';
import '../../widgets/course_widgets/course_card.dart';
import '../auth/sign_in_page.dart';
import 'course_info.dart';

/* Generates a list of `CourseCard` widgets dynamically based on course data. */
Future<List<CourseCard>> generateCourseCards(
    Function(int) onItemTapped, int selectedIndex, BuildContext context) async {
  try {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    String uid = userProvider.getUid();
    // Fetch courses from the database
    List<Course> coursesDatabase = await getAllCourses();

    // Handle the case where no courses are found
    if (coursesDatabase.isEmpty) {
      print("No courses found in the database.");
      return []; // Return an empty list if no courses are found
    }

    for (final course in coursesDatabase) {
      final userProgress = await getUserCourseProgress(uid, course.id);
      if (userProgress != null) {
        List<ChapterExerciseStep> progressList = [];
        for (final progressData in userProgress) {
          progressList.add(ChapterExerciseStep.fromString(progressData));
        }
        CacheManager.setValue(course.id, progressList);
      }

      // Update watched intro videos
      final watchedIntroductoryVideo =
          await getIntroductoryVideoWatched(uid, course.id);
      CacheManager.setValue(
          "${course.id}_introductory_video", watchedIntroductoryVideo);

      // Update uploaded childhood photos
      final uploadedChildhoodPhoto = await getUploadedChildhoodPhoto(uid);
      CacheManager.setValue("childhood_photos", uploadedChildhoodPhoto);
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
          onItemTapped: onItemTapped,
          selectedIndex: selectedIndex,
        ),
        isLocked: getIsCourseLocked(),
      );
    }).toList();
  } catch (e) {
    // Log and handle errors
    print("Error while generating course cards: $e");
    return []; // Return an empty list in case of an error
  }
}

getIsCourseLocked() {
  // TODO
  // Implement this
  return false;
}

/* Creates a dynamic `onButtonPress` function that navigates to the `CourseInfo` page with the specified parameters. */
void Function(BuildContext) createOnButtonPress({
  required Course course,
  required Function(int) onItemTapped,
  required int selectedIndex,
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
