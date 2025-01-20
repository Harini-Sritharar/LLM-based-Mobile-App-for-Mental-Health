import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> uploadPhoto({
  required File photoFile,
  required String userId,
  required String photoType,
}) async {
  try {
    // Generate a unique file name for the photo
    String fileName = "${DateTime.now().millisecondsSinceEpoch}_$userId.jpg";
    print("Generated file name: $fileName");

    // Get a reference to Firebase Storage
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference storageRef = storage.ref().child("firebasephotos/$fileName");

    // Upload the photo to Firebase Storage
    UploadTask uploadTask = storageRef.putFile(photoFile);
    TaskSnapshot snapshot = await uploadTask;

    // Get the photo's download URL
    String photoUrl = await snapshot.ref.getDownloadURL();
    print("Photo uploaded successfully. URL: $photoUrl");

    // Save the photo metadata to Firestore
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore.collection('ChildhoodPhotos').add({
      'photoUrl': photoUrl,
      'photoType': photoType,
      'userId': userId,
    });

    print("Photo metadata saved to Firestore successfully.");
  } catch (e) {
    print("An error occurred: $e");
  }
}


Future<void> uploadPhotoListParallel({
  required List<File> photoFiles,
  required String userId,
  required String photoType,
}) async {
  await Future.wait(photoFiles.map((photoFile) {
    return uploadPhoto(
      photoFile: photoFile,
      userId: userId,
      photoType: photoType,
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

    print("All documents for userId: $userId in collection: $collectionName have been removed.");
  } catch (e) {
    print("Error removing documents for userId: $userId. Details: $e");
  }
}


