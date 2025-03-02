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
Future<void> updateTimeStampAndComment(
    String uid,
    String courseId,
    String exerciseId,
    String sessionNumber,
    Timestamp startTime,
    Timestamp endTime,
    String comment) async {
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

/// Fetches every exercise in the latest chapter that the user has not completed.
Future<List<String>> getIncompleteExercisesInLatestChapter(
  String uid, String courseId) async {
  try {
  // Reference to the course document inside course_progress
  final docRef = FirebaseFirestore.instance
    .collection('Profile')
    .doc(uid)
    .collection('course_progress')
    .doc(courseId);

  // Fetch the document snapshot
  final docSnapshot = await docRef.get();

  if (docSnapshot.exists) {
    // Extract the Chapter_Exercise_Step field, which contains progress
    final chapterExerciseSteps =
      docSnapshot.data()?['Chapter_Exercise_Step'] as List?;

    if (chapterExerciseSteps != null && chapterExerciseSteps.isNotEmpty) {
    // Sort the chapterExerciseSteps list
    chapterExerciseSteps.sort();

    // Get the latest chapter
    String latestChapter = chapterExerciseSteps.last.split('/')[0];

    // Fetch all exercises in the latest chapter
    final exercisesSnapshot = await FirebaseFirestore.instance
      .collection('Courses')
      .doc(courseId)
      .collection('Chapters')
      .doc(latestChapter)
      .collection('Exercises')
      .get();

    List<String> allExercises =
      exercisesSnapshot.docs.map((doc) => doc.id).toList();

    // Find completed exercises
    List<String> completedExercises = [];
    for (var step in chapterExerciseSteps.where((step) => step.startsWith(latestChapter))) {
      int sessionNumber = int.parse(step.split('/')[3]);
      int requiredSessions = await getNumberSessionsRequired(courseId, latestChapter, step.split('/')[1]);
      if (sessionNumber >= requiredSessions) {
        completedExercises.add(step.split('/')[1]);
      }
    }

    // Find incomplete exercises
    List<String> incompleteExercises = allExercises
      .where((exercise) => !completedExercises.contains(exercise))
      .toList();

    return incompleteExercises;
    }
  }
  return []; // Return empty list if no progress found
  } catch (e) {
  print('Error fetching incomplete exercises for $courseId: $e');
  return [];
  }
}

/// Fetches the last chapter and last exercise that the user has COMPLETED in a given course.
/// Returns a tuple: (chapter, exercise)
Future<(String?, String?)> getCurrentChapterAndExerciseForCourse(
    String uid, String courseId) async {
  try {
    // Reference to the course document inside course_progress
    final docRef = FirebaseFirestore.instance
        .collection('Profile')
        .doc(uid)
        .collection('course_progress')
        .doc(courseId);

    // Fetch the document snapshot
    final docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      // Extract the Chapter_Exercise_Step field, which contains progress
      final chapterExerciseSteps =
          docSnapshot.data()?['Chapter_Exercise_Step'] as List?;

      if (chapterExerciseSteps != null && chapterExerciseSteps.isNotEmpty) {
        // Sort the chapterExerciseSteps list
        chapterExerciseSteps.sort();

        // Search from the back of the list
        for (int i = chapterExerciseSteps.length - 1; i >= 0; i--) {
          String lastStep = chapterExerciseSteps[
              i]; // Example: "Chapter 2/Self-Attachment_2_E/Self-Attachment_2_E_Final/3"
          List<String> parts = lastStep.split(
              '/'); // ["Chapter 2", "Self-Attachment_2_E", "Self-Attachment_2_E_Final" "3"]

          if (parts.length >= 3) {
            String chapter = parts[0]; // "Chapter 2"
            String exercise = parts[1]
                .split('_')
                .last; // Extracts the letter from "Self-Attachment_2_E"
            int sessionNumber = int.parse(parts[3]); // "3"

            // Get the number of steps in the exercise
            int numberOfSteps =
                await getNumberSessionsRequired(courseId, chapter, parts[1]);
            print(
                "number of steps for $courseId, $chapter, $exercise: $numberOfSteps");
            print(
                "step number for course $courseId, $chapter, $exercise $sessionNumber");
            if (sessionNumber == numberOfSteps) {
              return (chapter, exercise);
            }
          }
        }
      }
    }
    return (null, null); // Return null values if no progress found
  } catch (e) {
    print('Error fetching current chapter and exercise for $courseId: $e');
    return (null, null);
  }
}

/// Fetches the last exercise letter from a given chapter.
Future<String?> getLastExerciseFromChapter(
    String courseId, String chapter) async {
  try {
    // Reference to the exercises collection inside the given chapter
    final collectionRef = FirebaseFirestore.instance
        .collection('Courses')
        .doc(courseId)
        .collection('Chapters')
        .doc(chapter)
        .collection('Exercises');

    // Fetch all exercises inside the chapter
    final querySnapshot = await collectionRef.get();

    if (querySnapshot.docs.isNotEmpty) {
      // Extract exercise names and sort them
      List<String> exercises = querySnapshot.docs.map((doc) => doc.id).toList();
      exercises.sort(); // Ensures exercises are sorted alphabetically

      // Extract the last exercise name and return only the last letter
      String lastExercise = exercises.last;
      return lastExercise
          .split('_')
          .last; // Extracts the last letter (A, B, C, etc.)
    }

    return null; // Return null if no exercises are found
  } catch (e) {
    print('Error fetching last exercise from $chapter: $e');
    return null;
  }
}

/// Fetches the list of courses the user has started.
Future<List<String>> getStartedCourses(String uid) async {
  try {
    // Reference to the user's course_progress subcollection
    final collection = FirebaseFirestore.instance
        .collection('Profile')
        .doc(uid)
        .collection('course_progress');

    // Fetch all documents in the course_progress subcollection
    final querySnapshot = await collection.get();

    // Extract course IDs (document IDs)
    List<String> startedCourses =
        querySnapshot.docs.map((doc) => doc.id).toList();

    return startedCourses;
  } catch (e) {
    print('Error fetching started courses: $e');
    return [];
  }
}

/// Fetches the last chapter of a given course from Firebase.
Future<String?> getLastChapter(String courseId) async {
  try {
    final docRef = FirebaseFirestore.instance
        .collection('Courses')
        .doc(courseId)
        .collection('Chapters');
    final docSnapshot = await docRef.get();

    if (docSnapshot.docs.isNotEmpty) {
      List<String>? chapters = docSnapshot.docs.map((doc) => doc.id).toList();
      if (chapters != null && chapters.isNotEmpty) {
        return chapters.last; // Returns the last chapter dynamically
      }
    }
    return null;
  } catch (e) {
    print('Error fetching last chapter for $courseId: $e');
    return null;
  }
}

/// Fetches the number of steps in a given exercise.
Future<int> getNumberSessionsRequired(
    String courseId, String chapterId, String exerciseId) async {
  try {
    // Reference to the exercise document
    final docRef = FirebaseFirestore.instance
        .collection('Courses')
        .doc(courseId)
        .collection('Chapters')
        .doc(chapterId)
        .collection('Exercises')
        .doc(exerciseId);

    // Fetch the document snapshot
    final docSnapshot = await docRef.get();

    // Check if the document exists and contains the 'Steps' field
    if (docSnapshot.exists &&
        docSnapshot.data()!.containsKey('Total sessions')) {
      // Get the 'Steps' field and return its length
      int sessions = docSnapshot.data()!['Total sessions'];
      return sessions;
    }

    return 0; // Return 0 if the document doesn't exist or doesn't contain 'Steps'
  } catch (e) {
    print('Error fetching number of sessions for exercise: $e');
    return 0; // Return 0 if an error occurs
  }
}

/// Fetches all exercises in a given chapter of a course.
Future<List<String>> getAllExercisesInChapter(String courseId, String chapterId) async {
  try {
    // Reference to the exercises collection inside the given chapter
    final collectionRef = FirebaseFirestore.instance
        .collection('Courses')
        .doc(courseId)
        .collection('Chapters')
        .doc(chapterId)
        .collection('Exercises');

    // Fetch all exercises inside the chapter
    final querySnapshot = await collectionRef.get();

    // Extract exercise IDs from the documents
    List<String> exercises = querySnapshot.docs.map((doc) => doc.id).toList();

    return exercises;
  } catch (e) {
    print('Error fetching exercises in chapter $chapterId of course $courseId: $e');
    return [];
  }
}
