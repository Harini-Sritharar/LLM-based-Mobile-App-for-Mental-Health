// TODO: will need to move all the firebase calls to one place perhaps?

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

Future<void> updatePersonalInfo(
    String firstname, String surname, String dob, String gender) async {
  User? user = FirebaseAuth.instance.currentUser;
  FirebaseFirestore db = FirebaseFirestore.instance;
  await db.collection('Profile').doc(user!.uid).update({
    'firstname': firstname,
    'surname': surname,
    'dob': dob,
    'gender': gender
  });
}

Future<void> updateContactDetails(
    String country, String zipcode, String phoneNumber) async {
  User? user = FirebaseAuth.instance.currentUser;
  FirebaseFirestore db = FirebaseFirestore.instance;
  await db.collection('Profile').doc(user!.uid).update(
      {'zipcode': zipcode, 'country': country, 'phoneNumber': phoneNumber});
}

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
