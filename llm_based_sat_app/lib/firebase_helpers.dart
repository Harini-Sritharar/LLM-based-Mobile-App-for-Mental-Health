import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart' as path;
import 'package:cloud_firestore/cloud_firestore.dart';

Future<String> getName(String uid) async {
  try {
    // Reference to the Firestore collection
    final collection = FirebaseFirestore.instance.collection('ChildhoodPhotos');

    // Get the document for the user with the given UID
    final snapshot = await collection.doc(uid).get();

    // Check if the document exists and return the name
    if (snapshot.exists) {
      final name = snapshot.data()?['name'] as String?;
      if (name != null && name.isNotEmpty) {
        return name;
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
