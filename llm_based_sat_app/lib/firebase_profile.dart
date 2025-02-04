// TODO: will need to move all the firebase calls to one place perhaps?

import 'dart:ffi';
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
    'gender': gender,
    'completedQuestionnaires': [],
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

/// Saves questionnaire responses to Firestore
Future<void> saveQuestionnaireResponse(
    String name, Map<int, int> answers) async {
  User? user = FirebaseAuth.instance.currentUser;
  FirebaseFirestore db = FirebaseFirestore.instance;

  if (user == null) {
    print("User not logged in");
    return;
  }

  DocumentReference userDoc = db.collection('Profile').doc(user.uid);
  CollectionReference responsesRef = userDoc.collection('responses');

  // Store the questionnaire response
  DocumentReference docRef = responsesRef.doc();
  String docId = docRef.id;
  await docRef.set({
    'name': name,
    'timestamp': FieldValue.serverTimestamp(),
    'answers':
        answers.map((key, value) => MapEntry(key.toString(), value.toString())),
  });

  // Check if all required questionnaires are completed
  DocumentSnapshot userSnapshot = await userDoc.get();
  // Ensure completedQuestionnaires exists
  Map<String, String> completedQuestionnaires = {};
  if (userSnapshot.exists && userSnapshot.data() != null) {
    var data = userSnapshot.data() as Map<String, dynamic>;
    if (data.containsKey('completedQuestionnaires')) {
      completedQuestionnaires =
          Map<String, String>.from(data['completedQuestionnaires']);
    }
  }

  completedQuestionnaires[name] = docId;

  await userDoc.update({'completedQuestionnaires': completedQuestionnaires});

  // Recalculate overall score if all questionnaires are completed
  if (completedQuestionnaires.length == 6) {
    print(" length 6 ");
    await recalculateScores(user.uid);
  }
}

/// Recalculates the overall score and subscale scores
Future<void> recalculateScores(String userId) async {
  Map<String, int> subScores = {
    'GAD-7': 0,
    'PHQ-9': 0,
    'PWB': 0,
    'SOCS-S': 0,
    'CPC-12R': 0,
    'ERQ_R': 0,
    'ERQ_S': 0,
  };
  FirebaseFirestore db = FirebaseFirestore.instance;
  DocumentReference userDoc = db.collection('Profile').doc(userId);

  DocumentSnapshot userSnapshot = await userDoc.get();
  var data = userSnapshot.data() as Map<String, dynamic>;
  Map<String, String> completedQuestionnaires =
      Map<String, String>.from(data['completedQuestionnaires']);

  // Iterate through each completed questionnaire in the map
  completedQuestionnaires.forEach((name, docId) async {
    DocumentSnapshot responseSnapshot =
        await userDoc.collection('responses').doc(docId).get();
    var responseData = responseSnapshot.data() as Map<String, dynamic>;
    Map<String, String> answers =
        Map<String, String>.from(responseData['answers']);

    if (name == 'ERQ') {
      int ERQ_R = 0;
      int ERQ_S = 0;
      answers.forEach((i, score) {
        if ([1, 3, 5, 7, 8, 10].contains(i)) {
          ERQ_R += int.parse(score);
        } else {
          ERQ_S += int.parse(score);
        }
      });
      subScores.update('ERQ_R', (value) => ERQ_R);
      subScores.update('ERQ_S', (value) => ERQ_S);
    } else {
      int tempScore = 0;
      // Iterate through each set of response to add up the score for individual questionnaires
      answers.forEach((_, score) {
        tempScore += int.parse(score);
      });
      subScores.update(name, (value) => tempScore);
    }
  });

  double mentalHealthScore =
      1 - (0.5 * ((subScores['GAD-7']! / 21) + (subScores['PHQ-9']! / 27)));
  double weightedScore = (0.4 * subScores['PWB']! +
      0.25 * subScores['SOCS-S']! +
      0.25 * subScores['CPC-12R']! +
      0.1 * (subScores['ERQ_R']! + (28 - subScores['ERQ_S']!)));

  double overallScore = (mentalHealthScore + weightedScore) / 2;

  // Save the new scores
  await userDoc.update({'overallScore': overallScore, 'calculatedScore': true});

  print("Scores updated successfully!");
}

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
