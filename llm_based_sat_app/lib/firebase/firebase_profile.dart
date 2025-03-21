// TODO: will need to move all the firebase calls to one place perhaps?
// TODO
// For each user have a progress collection in database which defines which all courses/ exercises/steps they have gone till and the timer data as well.
// TODO
// Upload childhood photos already exists so perform a check to see if user has any photos uploaded for Pre-course-task.
// Watch Introductory video - figure a way to show video to user ... maybe through youtube API? and track if user has seen it to display tick mark
// Worry about cache after all tasks are done to ensure only 1 call is made to firebase.

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

// Future<void> updatePersonalInfo(
//     String firstname, String surname, String dob, String gender) async {
//   User? user = FirebaseAuth.instance.currentUser;
//   FirebaseFirestore db = FirebaseFirestore.instance;

//   if (user == null) return;

//   DocumentReference userDoc = db.collection('Profile').doc(user.uid);
//   DocumentSnapshot docSnapshot = await userDoc.get();

//   String tier = "free"; // Default tier
//   List<String> favouritePhotos = [];
//   List<String> nonfavouritePhotos = [];
//   if (docSnapshot.exists) {
//     // Preserve existing tier if user exists
//     tier = (docSnapshot.data() as Map<String, dynamic>)['tier'] ?? "free";
//     favouritePhotos = List<String>.from(data['favouritePhotos'] ?? []);
//     nonfavouritePhotos =
//         (docSnapshot.data() as Map<String, dynamic>)['nonfavouritePhotos'] ??
//             [];
//   }

//   await userDoc.set(
//       {
//         'firstname': firstname,
//         'surname': surname,
//         'dob': dob,
//         'gender': gender,
//         'tier': tier,
//         'favouritePhotos': favouritePhotos,
//         'nonfavouritePhotos': nonfavouritePhotos
//       },
//       SetOptions(
//           merge: true)); // Merging ensures we don’t overwrite other fields
// }

/// Updates the user's personal information in Firestore
Future<void> updatePersonalInfo(
    String firstname, String surname, String dob, String gender) async {
  User? user = FirebaseAuth.instance.currentUser;
  FirebaseFirestore db = FirebaseFirestore.instance;

  if (user == null) return;

  DocumentReference userDoc = db.collection('Profile').doc(user.uid);
  DocumentSnapshot docSnapshot = await userDoc.get();

  String tier = "free"; // Default tier
  List<String> favouritePhotos = [];
  List<String> nonfavouritePhotos = [];
  String ultimateGoal = "";

  if (docSnapshot.exists) {
    Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;

    tier = data['tier'] ?? "free";

    // Fixing the List<dynamic> to List<String> conversion issue
    favouritePhotos = List<String>.from(data['favouritePhotos'] ?? []);
    nonfavouritePhotos = List<String>.from(data['nonfavouritePhotos'] ?? []);
    ultimateGoal = data['ultimateGoal'] ?? "";
  }

  await userDoc.set(
    {
      'firstname': firstname,
      'surname': surname,
      'dob': dob,
      'gender': gender,
      'tier': tier,
      'favouritePhotos': favouritePhotos,
      'nonfavouritePhotos': nonfavouritePhotos,
      'ultimateGoal': ultimateGoal
    },
    SetOptions(merge: true), // Merging ensures we don’t overwrite other fields
  );
}

/// Updates the user's contact details in Firestore
Future<void> updateContactDetails(
    String country, String zipcode, String phoneNumber) async {
  User? user = FirebaseAuth.instance.currentUser;
  FirebaseFirestore db = FirebaseFirestore.instance;
  await db.collection('Profile').doc(user!.uid).update(
      {'zipcode': zipcode, 'country': country, 'phoneNumber': phoneNumber});
}

/// Uploads a new profile picture to Firebase Storage and updates the Firestore profile document
Future<void> updateProfilePictureAndUsername(
    File image, String username) async {
  User? user = FirebaseAuth.instance.currentUser;
  // Uploading profile picture to Firebase Storage
  FirebaseStorage storage = FirebaseStorage.instance;
  Reference storageRef =
      storage.ref().child('firebasephotos/profile_pic_${user!.uid}');

  UploadTask uploadTask = storageRef.putFile(image);
  TaskSnapshot snapshot = await uploadTask;

  String downloadUrl = await snapshot.ref.getDownloadURL();
  // updating the profile document with the url of the profile picture stored in Firebase Storage
  FirebaseFirestore db = FirebaseFirestore.instance;
  await db.collection('Profile').doc(user.uid).update({
    'username': username,
    'profilePictureUrl': downloadUrl,
  });
}

/// Checks if the user's personal information is complete
Future<bool> isPersonalInfoComplete() async {
  User? user = FirebaseAuth.instance.currentUser;
  FirebaseFirestore db = FirebaseFirestore.instance;

  try {
    DocumentSnapshot profile =
        await db.collection('Profile').doc(user!.uid).get();

    if (profile.exists) {
      return profile['firstname'] != null &&
          profile['firstname'].toString().isNotEmpty &&
          profile['surname'] != null &&
          profile['surname'].toString().isNotEmpty &&
          profile['dob'] != null &&
          profile['dob'].toString().isNotEmpty &&
          profile['gender'] != null &&
          profile['gender'].toString().isNotEmpty;
    }
    return false;
  } catch (e) {
    print("Error checking personal info: $e");
    return false;
  }
}

/// Checks if the user's contact details are complete
Future<bool> isContactDetailsComplete() async {
  User? user = FirebaseAuth.instance.currentUser;
  FirebaseFirestore db = FirebaseFirestore.instance;

  try {
    DocumentSnapshot profile =
        await db.collection('Profile').doc(user!.uid).get();

    if (profile.exists) {
      return profile['country'] != null &&
          profile['country'].toString().isNotEmpty &&
          profile['zipcode'] != null &&
          profile['zipcode'].toString().isNotEmpty &&
          profile['phoneNumber'] != null &&
          profile['phoneNumber'].toString().isNotEmpty;
    }
    return false;
  } catch (e) {
    print("Error checking contact details: $e");
    return false;
  }
}

/// Checks if the user's profile picture is uploaded and complete
Future<bool> isProfilePictureComplete() async {
  User? user = FirebaseAuth.instance.currentUser;
  FirebaseFirestore db = FirebaseFirestore.instance;

  try {
    DocumentSnapshot profile =
        await db.collection('Profile').doc(user!.uid).get();

    if (profile.exists) {
      return profile['profilePictureUrl'] != null &&
          profile['profilePictureUrl'].toString().isNotEmpty;
    }
    return false;
  } catch (e) {
    print("Error checking profile picture: $e");
    return false;
  }
}
