import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;
import 'package:cloud_firestore/cloud_firestore.dart';

import 'models/firebase-exercise-uploader/interface/chapter_interface.dart';
import 'models/firebase-exercise-uploader/interface/course_interface.dart';
import 'models/firebase-exercise-uploader/interface/exercise_interface.dart';
import 'models/firebase-exercise-uploader/interface/final_step_interface.dart';
import 'models/firebase-exercise-uploader/interface/step_interface.dart';

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
          final exercise = Exercise.fromFirestore(
              exerciseDoc.id, exerciseDoc.data());

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


Future<List<Map<String, dynamic>>> getCoursesTrial() async {
  try {
    // Reference to the Firestore collection
    final collection = FirebaseFirestore.instance.collection('Courses');

    // Get all documents from the collection
    final querySnapshot = await collection.get();

    // Extract the documents as a list of maps
    final courses = querySnapshot.docs.map((doc) => doc.data()).toList();

    // Return the list of courses
    return courses;
  } catch (e) {
    // Handle errors and return an empty list
    if (kDebugMode) {
      print('Error fetching courses: $e');
    }
    return [];
  }
}

Future<void> uploadPhoto({
  required File photoFile,
  required String userId,
  required String photoType,
  required String fileName,
}) async {
  try {
    // Get a reference to Firebase Storage
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference storageRef = storage.ref().child("firebasephotos/$fileName");

    // Upload the photo to Firebase Storage
    UploadTask uploadTask = storageRef.putFile(photoFile);
    TaskSnapshot snapshot = await uploadTask;

    // Get the photo's download URL
    String photoUrl = await snapshot.ref.getDownloadURL();

    // Save the photo metadata to Firestore
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore.collection('ChildhoodPhotos').add({
      'photoUrl': photoUrl,
      'photoType': photoType,
      'userId': userId,
      'photoName':
          path.basename(photoFile.path), // Store the original file name
    });

    print("Photo uploaded successfully. URL: $photoUrl");
  } catch (e) {
    print("An error occurred while uploading photo: $e");
  }
}

Future<void> uploadPhotoListParallel({
  required List<Map<String, dynamic>> photoDataList,
  required String userId,
  required String photoType,
}) async {
  await Future.wait(photoDataList.map((photoData) async {
    final photoFile = File(photoData['photoUrl']); // Use the file's path here

    // Generate a unique file name for the upload (to avoid overwriting files)
    String fileName =
        "${DateTime.now().millisecondsSinceEpoch}_${photoData['photoName']}";

    // Upload the file with a unique name
    await uploadPhoto(
      photoFile: photoFile,
      userId: userId,
      photoType: photoType,
      fileName: fileName, // Pass the unique file name
    );
  }));
}

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

Future<List<Map<String, dynamic>>> getPhotosByCategory({
  required String userId,
  required String category,
}) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  try {
    // Query Firestore to get photos by userId and category
    QuerySnapshot querySnapshot = await firestore
        .collection(
            'ChildhoodPhotos') // Target the 'ChildhoodPhotos' collection
        .where('userId', isEqualTo: userId) // Filter by userId
        .where('photoType',
            isEqualTo:
                category) // Filter by category (favourite or non-favourite)
        .get();

    // Convert query results to a list of maps (each document as a map)
    List<Map<String, dynamic>> photos = querySnapshot.docs.map((doc) {
      return doc.data() as Map<String, dynamic>;
    }).toList();

    print("Fetched ${photos.length} ${category} photos for userId: $userId");

    return photos;
  } catch (e) {
    print("Error fetching photos: $e");
    return [];
  }
}
