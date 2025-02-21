import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/firebase-exercise-uploader/interface/chapter_interface.dart';
import '../models/firebase-exercise-uploader/interface/course_interface.dart';
import '../models/firebase-exercise-uploader/interface/exercise_interface.dart';
import '../models/firebase-exercise-uploader/interface/final_step_interface.dart';
import '../models/firebase-exercise-uploader/interface/step_interface.dart';

Future<String> getName(String uid) async {
  try {
    // Reference to the Firestore collection
    final collection = FirebaseFirestore.instance.collection('Profile');

    // Get the document for the user with the given UID
    final snapshot = await collection.doc(uid).get();

    // Check if the document exists and return the name
    if (snapshot.exists) {
      final firstName = snapshot.data()?['firstname'] as String?;
      final surname = snapshot.data()?['surname'] as String?;

      if (firstName != null &&
          firstName.isNotEmpty &&
          surname != null &&
          surname.isNotEmpty) {
        return firstName + " " + surname;
      }
    }
    // Return a default value if the name is null or the document doesn't exist
    return 'No Name Found';
  } catch (e) {
    // Handle errors and return a default value
    print('Error fetching user name: $e');
    return 'Error Fetching Name';
  }
}

Future<String> getTier(String uid) async {
  try {
    // Reference to the Firestore collection
    final collection = FirebaseFirestore.instance.collection('Profile');

    // Get the document for the user with the given UID
    final snapshot = await collection.doc(uid).get();

    // Check if the document exists and return the name
    if (snapshot.exists) {
      final tier = snapshot.data()?['tier'] as String?;

      if (tier != null && tier.isNotEmpty) return tier;
    }
    // Return a default value if the name is null or the document doesn't exist
    return 'free';
  } catch (e) {
    // Handle errors and return a default value
    print('Error fetching tier $e');
    return 'Error Fetching Tier';
  }
}

Future<DateTime> getTierExpiry(String uid) async {
  try {
    // Reference to the Firestore collection
    final collection = FirebaseFirestore.instance.collection('Profile');

    // Get the document for the user with the given UID
    final snapshot = await collection.doc(uid).get();

    // Check if the document exists
    if (snapshot.exists) {
      // Get the tier_expiry field from the document
      final tierExpiryTimestamp = snapshot.data()?['tier_expiry'] as Timestamp?;

      if (tierExpiryTimestamp != null) {
        // Return the expiry date as DateTime
        return tierExpiryTimestamp.toDate();
      } else {
        // Handle the case where tier_expiry is not found, for "free" tier
        // Setting a default far future date for free tier
        return DateTime(2100, 1, 1);
      }
    }
    // If the document doesn't exist or there's no expiry, return the default far future date
    return DateTime(2100, 1, 1);
  } catch (e) {
    // Handle errors and return a default far future date
    print('Error fetching tier expiry: $e');
    return DateTime(2100, 1, 1); // Default far future date on error
  }
}

Future<void> setTier(String uid, String tier) async {
  try {
    // Reference to the Firestore collection
    final collection = FirebaseFirestore.instance.collection('Profile');

    // Initialize expiryDate based on the tier
    DateTime expiryDate;
    if (tier == 'monthly') {
      expiryDate =
          DateTime.now().add(Duration(days: 30)); // 30 days for monthly
    } else if (tier == 'yearly') {
      expiryDate =
          DateTime.now().add(Duration(days: 365)); // 365 days for yearly
    } else if (tier == 'free') {
      expiryDate =
          DateTime(2100, 1, 1); // Set expiry far in the future for free tier
    } else {
      throw Exception('Invalid tier type');
    }

    // Update the user's tier and expiry date in Firestore
    await collection.doc(uid).set(
      {
        'tier': tier,
        'tier_expiry':
            Timestamp.fromDate(expiryDate), // Store expiry date for all tiers
      },
      SetOptions(merge: true), // Merge to avoid overwriting other fields
    );

    print('Tier updated successfully to $tier with expiry on $expiryDate');
  } catch (e) {
    print('Error setting tier: $e');
  }
}

Future<String> getProfilePictureUrl(String uid) async {
  try {
    // Reference to the Firestore collection
    final collection = FirebaseFirestore.instance.collection('Profile');

    // Get the document for the user with the given UID
    final snapshot = await collection.doc(uid).get();

    // Check if the document exists and return the profile picture URL
    if (snapshot.exists) {
      final profilePictureUrl =
          snapshot.data()?['profilePictureUrl'] as String?;

      if (profilePictureUrl != null && profilePictureUrl.isNotEmpty) {
        return profilePictureUrl;
      }
    }
    // Return a default value if the URL is null or the document doesn't exist
    return 'No Profile Picture Found';
  } catch (e) {
    // Handle errors and return a default value
    print('Error fetching profile picture URL: $e');
    return 'Error Fetching Profile Picture';
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

// Remove all user documents from a given collection
Future<void> removeUserDocuments({
  required String userId,
  required String collectionName,
}) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  try {
    // Query all documents with the given userId
    QuerySnapshot querySnapshot = await firestore
        .collection(collectionName) // Target the specified collection
        .where('userId', isEqualTo: userId)
        .get();

    // Iterate through the documents and delete them
    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      await doc.reference.delete();
    }

    print(
        "All documents for userId: $userId in collection: $collectionName have been removed.");
  } catch (e) {
    print("Error removing documents for userId: $userId. Details: $e");
  }
}

Future<List<String>> getFavouritePhotos(String uid) async {
  try {
    final snapshot =
        await FirebaseFirestore.instance.collection('Profile').doc(uid).get();
    if (snapshot.exists) {
      final List<dynamic>? photos = snapshot.data()?['favouritePhotos'];
      if (photos != null) {
        return photos.cast<String>();
      }
    }
    return [];
  } catch (e) {
    print('Error fetching favourite photos: $e');
    return [];
  }
}

Future<List<String>> getNonFavouritePhotos(String uid) async {
  try {
    final snapshot =
        await FirebaseFirestore.instance.collection('Profile').doc(uid).get();
    if (snapshot.exists) {
      final List<dynamic>? photos = snapshot.data()?['nonFavouritePhotos'];
      if (photos != null) {
        return photos.cast<String>();
      }
    }
    return [];
  } catch (e) {
    print('Error fetching non-favourite photos: $e');
    return [];
  }
}

Future<void> setUltimateGoal(String uid, String goal) async {
  try {
    // Reference to the Firestore collection
    final collection = FirebaseFirestore.instance.collection('Profile');

    // Update the user's document with the new ultimate goal
    await collection.doc(uid).set(
      {'ultimateGoal': goal},
      SetOptions(merge: true), // Merge to avoid overwriting other fields
    );

    print("Ultimate goal updated successfully.");
  } catch (e) {
    print("Error setting ultimate goal: $e");
  }
}

Future<String> getUltimateGoal(String uid) async {
  try {
    // Reference to the Firestore collection
    final collection = FirebaseFirestore.instance.collection('Profile');

    // Get the document for the user with the given UID
    final snapshot = await collection.doc(uid).get();

    // Check if the document exists and return the ultimate goal
    if (snapshot.exists) {
      final goal = snapshot.data()?['ultimateGoal'] as String?;

      if (goal != null && goal.isNotEmpty) {
        return goal;
      }
    }
    // Return a default value if the goal is null or the document doesn't exist
    return '';
  } catch (e) {
    // Handle errors and return a default value
    print('Error fetching ultimate goal: $e');
    return 'Error Fetching Goal';
  }
}

/// Uploads a photo to Firebase Storage and returns the download URL.
/// Helper function to be used by childhoodPhotos and helpCentre
Future<String> uploadPhoto(File file, String filePath) async {
  try {
    final storageReference = FirebaseStorage.instance.ref().child(filePath);
    final uploadTask = await storageReference.putFile(file);
    final downloadUrl = await storageReference.getDownloadURL();
    return downloadUrl;
  } catch (e) {
    print("Error uploading photo: $e");
    rethrow;
  }
}

/// Saves a reported issue with the media file being uploaded to Firebase Storage.
Future<void> saveReportedIssue({
  required String userId,
  required String issue,
  required List<String> mediaURLs,
}) async {
  try {
    // Generate a unique file path for the media file
    final String filePath =
        'reported_issues/${DateTime.now().millisecondsSinceEpoch}_${userId}.jpg';

    // Reference to the ReportedIssues collection
    CollectionReference reportedIssues =
        FirebaseFirestore.instance.collection('ReportedIssues');

    // Add the reported issue to Firestore with the uploaded media URL
    await reportedIssues.add({
      'userID': userId, // The ID of the user reporting the issue
      'issue': issue, // The issue description
      'media': mediaURLs, // The uploaded media URL list
    });

    print("Reported issue saved successfully.");
  } catch (e) {
    print("Error saving reported issue: $e");
    rethrow;
  }
}

  Future<List<bool>?> getNotificationPreferences(String userId) async {
    try {
      final collection = FirebaseFirestore.instance.collection('Profile');
      final doc = await collection.doc(userId).get();
      if (doc.exists) {
        final data = doc.data();
        if (data != null && data.containsKey('notificationPreferences')) {
          return List<bool>.from(data['notificationPreferences']);
        }
      }
    } catch (e) {
      print('Error getting notification preferences: $e');
    }
    return null;
  }

   Future<void> saveNotificationPreferences(String userId, List<bool> preferences) async {
    try {
      final collection = FirebaseFirestore.instance.collection('Profile');
      await collection.doc(userId).set({
        'notificationPreferences': preferences,
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error saving notification preferences: $e');
    }
  }
