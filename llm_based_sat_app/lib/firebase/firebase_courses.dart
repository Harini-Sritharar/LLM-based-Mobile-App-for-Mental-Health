import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:llm_based_sat_app/models/time_stamp_entry.dart';

import '../models/firebase-exercise-uploader/interface/chapter_interface.dart';
import '../models/firebase-exercise-uploader/interface/course_interface.dart';
import '../models/firebase-exercise-uploader/interface/exercise_interface.dart';
import '../models/firebase-exercise-uploader/interface/final_step_interface.dart';
import '../models/firebase-exercise-uploader/interface/step_interface.dart';

/* Fetches the course progress for a specific user and course ID.
The output for the attribute "Chapter_Exercise_Step" is returned 
in the format: ["Chapter/Exercise/Step"] */
Future<List?> getUserCourseProgress(String uid, String courseId) async {
  try {
    // Reference to the user's course_progress subcollection
    final collection = FirebaseFirestore.instance
        .collection('Profile')
        .doc(uid)
        .collection('course_progress');

    // Fetch all documents in the course_progress subcollection
    final querySnapshot = await collection.get();

    // Iterate through the documents to find the matching course by ID
    for (final doc in querySnapshot.docs) {
      if (doc.id.trim() == courseId.trim()) {
        // Return the "Chapter_Exercise_Step" attribute if found
        final chapterExerciseStep =
            doc.data()['Chapter_Exercise_Step'] as List?;
        return chapterExerciseStep; // Return the value if it exists
      }
    }

    // Return null if no matching course is found
    return null;
  } catch (e) {
    // Handle errors and print them
    print('Error fetching course progress: $e');
    return null;
  }
}

/* Updates the course progress for a specific user and course ID by adding a new
"Chapter_Exercise_Step" entry to the existing list. */
Future<void> updateUserCourseProgress(String uid, String courseId,
    String newChapterExerciseStep, String previousSession) async {
  try {
    // Reference to the user's course_progress subcollection
    final collection = FirebaseFirestore.instance
        .collection('Profile')
        .doc(uid)
        .collection('course_progress');

    // Fetch the document for the given course ID
    final docRef = collection.doc(courseId);

    // Get the document snapshot
    final docSnapshot = await docRef.get();

    // Check if the document exists
    if (docSnapshot.exists) {
      // Fetch the current "Chapter_Exercise_Step" list from the document
      List? currentChapterExerciseStep =
          docSnapshot.data()?['Chapter_Exercise_Step'];

      // If the list is null, initialize it as an empty list
      currentChapterExerciseStep ??= [];

      // Add the new element to the list if not already present and also delete the previous session
      currentChapterExerciseStep.remove(previousSession);
      if (!currentChapterExerciseStep.contains(newChapterExerciseStep)) {
        currentChapterExerciseStep.add(newChapterExerciseStep);
      }

      // Update the document with the new list
      await docRef.update({
        'Chapter_Exercise_Step': currentChapterExerciseStep,
      });

      print('User progress updated successfully');
    } else {
      // If the document doesn't exist, create a new document with the given courseId and new progress
      print('Creating entry for new course ID');

      await docRef.set({
        'Chapter_Exercise_Step': [
          newChapterExerciseStep
        ], // Initialize with the new entry
      });

      print('New course entry created and progress added');
    }
  } catch (e) {
    // Handle errors and print them
    print('Error updating course progress: $e');
  }
}

/* Function to get if childhood photo is uploaded for given user */
Future<bool> getUploadedChildhoodPhoto(String uid) async {
  try {
    // Reference to the user
    final docRef = FirebaseFirestore.instance.collection('Profile').doc(uid);

    // Get the document snapshot
    final docSnapshot = await docRef.get();

    // Check if the document exists and contains 'favouritePhotos' or 'nonFavouritePhotos' attributes
    if (docSnapshot.exists) {
      bool hasFavouritePhotos = docSnapshot
              .data()!
              .containsKey('favouritePhotos') &&
          (docSnapshot.data()!['favouritePhotos'] as List<dynamic>).isNotEmpty;

      bool hasNonFavouritePhotos =
          docSnapshot.data()!.containsKey('nonfavouritePhotos') &&
              (docSnapshot.data()!['nonfavouritePhotos'] as List<dynamic>)
                  .isNotEmpty;

      // Return true if either list contains at least one photo
      return hasFavouritePhotos || hasNonFavouritePhotos;
    }

// Return false if no matching data is found
    return false;
  } catch (e) {
    // Handle errors and print them
    print('Error fetching course progress: $e');
    return false;
  }
}

/* Function to get if Introductory video is watched for given user and course */
Future<bool> getIntroductoryVideoWatched(String uid, String courseId) async {
  try {
    // Reference to the user's course_progress subcollection
    final collection = FirebaseFirestore.instance
        .collection('Profile')
        .doc(uid)
        .collection('course_progress');

    // Fetch all documents in the course_progress subcollection
    final querySnapshot = await collection.get();

    // Iterate through the documents to find the matching course by ID
    for (final doc in querySnapshot.docs) {
      if (doc.id.trim() == courseId.trim()) {
        // Return the "Introductory_video_watched" attribute if found
        bool introductoryVideoWatched =
            doc.data()['Introductory_video_watched'];
        return introductoryVideoWatched; // Return the value if it exists
      }
    }

    // Return null if no matching course is found
    return false;
  } catch (e) {
    // Handle errors and print them
    print('Error fetching course progress: $e');
    return false;
  }
}

/* Updates the 'Introductory_video_watched' parameter for a given user. */
Future<void> updateWatchedIntroductoryVideo(
    String uid, String courseId, bool watchedVideo) async {
  try {
    // Reference to the user's course_progress subcollection
    final collection = FirebaseFirestore.instance
        .collection('Profile')
        .doc(uid)
        .collection('course_progress');

    // Fetch the document for the given course ID
    final docRef = collection.doc(courseId);

    // Get the document snapshot
    final docSnapshot = await docRef.get();

    // Check if the document exists
    if (docSnapshot.exists) {
      // Update the document with the new valye
      await docRef.update({
        'Introductory_video_watched': watchedVideo,
      });

      print('Introductory_video_watched updated successfully');
    } else {
      // If the document doesn't exist, create a new document with the given courseId and Introductory_video_watched
      print('Creating entry for new course ID');

      await docRef.set({
        'Introductory_video_watched':
            watchedVideo, // Initialize with the new entry
      });

      print('New course entry created and Introductory_video_watched added');
    }
  } catch (e) {
    // Handle errors and print them
    print('Error updating Introductory_video_watched: $e');
  }
}

/* Function to get all courses from firebase as a List of Courses */
Future<List<Course>> getAllCourses() async {
  try {
    // Fetch all courses
    final querySnapshot =
        await FirebaseFirestore.instance.collection('Courses').get();

    // Fetch chapters and exercises for each course
    final List<Course> courses = [];

    // Loop through each course document
    for (var doc in querySnapshot.docs) {
      // Convert course data
      final course = Course.fromFirestore(doc.id, doc.data());

      // Fetch chapters for this course
      final chaptersSnapshot = await FirebaseFirestore.instance
          .collection('Courses')
          .doc(doc.id)
          .collection('Chapters')
          .get();

      // List to store all chapters
      final List<Chapter> chapters = [];

      // Loop through each chapter document
      for (var chapterDoc in chaptersSnapshot.docs) {
        // Convert chapter data
        final chapter = Chapter.fromFirestore(chapterDoc.id, chapterDoc.data());

        // Fetch exercises for this chapter
        final exercisesSnapshot = await FirebaseFirestore.instance
            .collection('Courses')
            .doc(doc.id)
            .collection('Chapters')
            .doc(chapterDoc.id)
            .collection('Exercises')
            .get();

        // List to store all exercises
        final List<Exercise> exercises = [];

        // Loop through each exercise document
        for (var exerciseDoc in exercisesSnapshot.docs) {
          // Convert exercise data
          final exercise =
              Exercise.fromFirestore(exerciseDoc.id, exerciseDoc.data());

          // Fetch steps for this exercise
          final stepsSnapshot = await FirebaseFirestore.instance
              .collection('Courses')
              .doc(doc.id)
              .collection('Chapters')
              .doc(chapterDoc.id)
              .collection('Exercises')
              .doc(exerciseDoc.id)
              .collection('Steps')
              .get();

          // List to store steps
          final List<Step> exerciseSteps = [];
          FinalStep? finalStep;

          // Loop through each step document
          for (var stepDoc in stepsSnapshot.docs) {
            final stepData = stepDoc.data();
            if (stepDoc.id.endsWith("Final")) {
              finalStep = FinalStep.fromFirestore(stepDoc.id, stepData);
            } else {
              exerciseSteps.add(Step.fromFirestore(stepDoc.id, stepData));
            }
          }

          // Attach steps and final step to exercise
          final exerciseWithSteps = exercise.withStepsAndFinalStep(
            exerciseSteps,
            finalStep!,
          );

          // Add the exercise to the list
          exercises.add(exerciseWithSteps);
        }

        // Attach exercises to chapter
        final chapterWithExercises = chapter.withExercises(exercises);

        // Add the chapter to the list
        chapters.add(chapterWithExercises);
      }

      // Now that all chapters and exercises are fetched, add course to the list
      courses.add(Course(
        id: course.id,
        title: course.title,
        rating: course.rating,
        duration: course.duration,
        ratingCount: course.ratingCount,
        imageUrl: course.imageUrl,
        aim: course.aim,
        subscription: course.subscription,
        courseType: course.courseType,
        prerequisites: course.prerequisites,
        chapters: chapters,
      ));
    }

    return courses;
  } catch (e) {
    print('Error fetching courses with chapters, exercises, and steps: $e');
    return [];
  }
}

/* Adds a timestamp entry for a specific user and exercise Id by creating a new entry to the existing collection. */
Future<void> updateTimeStampCommentAndRating(
    String uid,
    String courseId,
    String exerciseId,
    String sessionNumber,
    Timestamp startTime,
    Timestamp endTime,
    String comment,
    double feelingBetter,
    double helpfulness,
    double rating) async {
  try {
    // Reference to the user's course_progress subcollection
    final collection = FirebaseFirestore.instance
        .collection('Profile')
        .doc(uid)
        .collection('course_progress');

    // Fetch the document for the given course ID
    final docRef = collection.doc(courseId);

// Get the document snapshot
    final docSnapshot = await docRef.get();

// Check if the document exists
    if (docSnapshot.exists) {
      // Reference to the 'TimeStamps' subcollection inside courseId
      final timeStampRef =
          docRef.collection('TimeStamps').doc("$exerciseId\\$sessionNumber");

      // Add a new timestamp entry
      await timeStampRef.set({
        'startTime': startTime,
        'endTime': endTime,
        'comment': comment,
        'feelingBetter': feelingBetter,
        'helpfulness': helpfulness,
        'rating': rating,
      }, SetOptions(merge: true));

      print('Timestamp added successfully');
    } else {
      // If the document doesn't exist, create a new document with the given courseId
      print('Creating entry for new course ID');

      await docRef.set({}); // Initialize the courseId document

      // Reference to the 'TimeStamps' subcollection inside courseId
      final timeStampRef =
          docRef.collection('TimeStamps').doc("$exerciseId\\$sessionNumber");

      // Create new timestamp entry
      await timeStampRef.set({
        'startTime': startTime,
        'endTime': endTime,
        'comment': comment,
        'feelingBetter': feelingBetter,
        'helpfulness': helpfulness,
        'rating': rating,
      });

      print('New course entry created and timestamp added');
    }
  } catch (e) {
    // Handle errors and print them
    print('Error updating course progress: $e');
  }
}

Future<TimeStampEntry?> getTimeStamp(String uid, String courseId,
    String exerciseId, String sessionNumber) async {
  try {
// Reference to the user's course_progress subcollection
    final collection = FirebaseFirestore.instance
        .collection('Profile')
        .doc(uid)
        .collection('course_progress');

// Reference to the specific timestamp entry
    final timeStampRef = collection
        .doc(courseId)
        .collection('TimeStamps')
        .doc("$exerciseId\\$sessionNumber");

// Get the document snapshot
    final docSnapshot = await timeStampRef.get();

// Check if the document exists and return the data
    if (docSnapshot.exists) {
      print('Timestamp retrieved successfully');
      return TimeStampEntry.fromMap(docSnapshot.data()!);
    } else {
      print('No timestamp found for the given exercise and session');
      return null;
    }
  } catch (e) {
// Handle errors and print them
    print('Error retrieving timestamp: $e');
    return null;
  }
}

/* Fetches childhood images categorized as "Happy" (Favourite Photos) and "Sad" (Non-Favourite Photos).

The images are categorized into two types:
- "Happy" → Stored under `favouritePhotos`
- "Sad" → Stored under `nonfavouritePhotos`

If the document doesn't exist or an error occurs, it returns an empty map. */
Future<Map<String, List<String>>> getChildhoodImages(String uid) async {
  try {
    // Reference to the user's document in Firestore
    final docSnapshot =
        await FirebaseFirestore.instance.collection('Profile').doc(uid).get();

    // Check if the document exists
    if (!docSnapshot.exists) {
      return {};
    }

    // Extract data from Firestore document
    final data = docSnapshot.data();
    if (data == null) {
      return {};
    }

    // Convert to expected format
    Map<String, List<String>> imagesMap = {
      "Happy": List<String>.from(data["favouritePhotos"] ?? []),
      "Sad": List<String>.from(data["nonfavouritePhotos"] ?? []),
    };

    return imagesMap;
  } catch (e) {
    print("Error fetching childhood images: $e");
    return {};
  }
}
