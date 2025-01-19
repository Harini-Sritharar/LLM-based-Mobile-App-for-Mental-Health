import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> uploadPhoto({
  required File photoFile,
  required String userId,
  required String photoType,
}) async {
  try {
    // Generate a unique file name
    String fileName = "${DateTime.now().millisecondsSinceEpoch}_$userId.jpg";

    // Upload the photo to Firebase Storage
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference storageRef = storage.ref().child("firebasephotos/$fileName");
    UploadTask uploadTask = storageRef.putFile(photoFile);

    TaskSnapshot snapshot = await uploadTask;
    String photoUrl = await snapshot.ref.getDownloadURL();

    // Add the photo data to Firestore
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore.collection('YourCollectionName').add({
      'Photo': photoUrl,
      'PhotoType': photoType,
      'userID': userId,
    });

    //print("Photo uploaded and data saved successfully.");
  } catch (e) {
    //print("An error occurred: $e");
  }
}
