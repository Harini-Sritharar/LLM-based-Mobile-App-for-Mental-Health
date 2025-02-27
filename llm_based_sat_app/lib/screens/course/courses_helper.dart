import 'dart:async';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../../data/cache_manager.dart';
import '../../firebase/firebase_courses.dart';
import '../../models/chapter_exercise_step_interface.dart';
import '../../models/firebase-exercise-uploader/interface/course_interface.dart';
import '../../widgets/course_widgets/course_card.dart';
import 'course_info.dart';

/* Generates a list of `CourseCard` widgets dynamically based on course data. Loads in user childhood favorite and non-favorite images and stores in cache */
Future<List<CourseCard>> generateCourseCards(
    Function(int) onItemTapped, int selectedIndex, String uid) async {
  try {
    // Start fetching images in the background
    unawaited(_fetchAndCacheChildhoodImages(uid));

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

// Background function to fetch and cache childhood images
Future<void> _fetchAndCacheChildhoodImages(String uid) async {
  try {
    Map<String, List<String>> images = await getChildhoodImages(uid);

    // Store images in CacheManager
    CacheManager.setValue("Happy", images["Happy"] ?? []);
    CacheManager.setValue("Sad", images["Sad"] ?? []);
    CacheManager.setValue("Happy_current_index", 1);
    CacheManager.setValue("Sad_current_index", 1);

    // Preload images into memory
    await preloadImages(images);
  } catch (e) {
    print("Error loading childhood images: $e");
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

Future<void> preloadImages(Map<String, List<String>> images) async {
  for (var entry in images.entries) {
    String imageType = entry.key; // "Happy" or "Sad"
    List<String> urls = entry.value;

    List<Uint8List> imageDataList = [];

    for (String url in urls) {
      try {
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          imageDataList.add(response.bodyBytes);
        }
      } catch (e) {
        print("Error loading image: $url, Error: $e");
      }
    }

    // Store the loaded images in cache
    CacheManager.setValue(imageType, imageDataList);
    CacheManager.setValue("${imageType}_current_index", 0);
  }
}
