// TODO: will need to move all the firebase calls to one place perhaps?
// TODO
// For each user have a progress collection in database which defines which all courses/ exercises/steps they have gone till and the timer data as well.
// TODO
// Upload childhood photos already exists so perform a check to see if user has any photos uploaded for Pre-course-task.
// Watch Introductory video - figure a way to show video to user ... maybe through youtube API? and track if user has seen it to display tick mark
// Worry about cache after all tasks are done to ensure only 1 call is made to firebase.

import 'dart:ffi';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

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
  if (docSnapshot.exists) {
    // Preserve existing tier if user exists
    tier = (docSnapshot.data() as Map<String, dynamic>)['tier'] ?? "free";
    favouritePhotos =
        (docSnapshot.data() as Map<String, dynamic>)['favouritePhotos'] ?? [];
    nonfavouritePhotos =
        (docSnapshot.data() as Map<String, dynamic>)['nonfavouritePhotos'] ??
            [];
  }

  await userDoc.set(
      {
        'firstname': firstname,
        'surname': surname,
        'dob': dob,
        'gender': gender,
        'tier': tier,
        'favouritePhotos': favouritePhotos,
        'nonfavouritePhotos': nonfavouritePhotos
      },
      SetOptions(
          merge: true)); // Merging ensures we don’t overwrite other fields
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

  // Always recalculate sub scores when a questionnaire is completed
  await recalculateSubScores(user.uid);

  // Recalculate overall score if all questionnaires are completed
  if (completedQuestionnaires.length == 6) {
    await recalculateScores(user.uid);
  }
}

Future<void> recalculateSubScores(String userId) async {
  Map<String, double> calculatedSubScores = {
    'Resilience': 0,
    'Self-efficacy': 0,
    'Personal growth': 0,
    'Self-Acceptance': 0,
    'Acting to alleviate suffering': 0,
  };

  FirebaseFirestore db = FirebaseFirestore.instance;
  DocumentReference userDoc = db.collection('Profile').doc(userId);

  DocumentSnapshot userSnapshot = await userDoc.get();
  var data = userSnapshot.data() as Map<String, dynamic>;
  Map<String, String> completedQuestionnaires =
      Map<String, String>.from(data['completedQuestionnaires']);

  // Iterate through each completed questionnaire in the map
  for (var entry in completedQuestionnaires.entries) {
    String name = entry.key;
    String docId = entry.value;

    DocumentSnapshot responseSnapshot =
        await userDoc.collection('responses').doc(docId).get();
    var responseData = responseSnapshot.data() as Map<String, dynamic>;
    // Get the answers
    Map<String, String> answers =
        Map<String, String>.from(responseData['answers']);

    if (name == 'CPC-12R') {
      // answers map key starts at index 0
      calculatedSubScores['Resilience'] = 100 *
          (int.parse(answers['9'] ?? '0') +
              int.parse(answers['10'] ?? '0') +
              int.parse(answers['11'] ?? '0')) /
          18;

      calculatedSubScores['Self-efficacy'] = 100 *
          (int.parse(answers['6'] ?? '0') +
              int.parse(answers['7'] ?? '0') +
              int.parse(answers['8'] ?? '0')) /
          18;
    }

    if (name == 'PWB') {
      calculatedSubScores['Personal growth'] = 100 *
          (int.parse(answers['10'] ?? '0') +
              int.parse(answers['11'] ?? '0') +
              int.parse(answers['13'] ?? '0')) /
          21;

      calculatedSubScores['Self-Acceptance'] = 100 *
          (int.parse(answers['0'] ?? '0') +
              int.parse(answers['1'] ?? '0') +
              int.parse(answers['4'] ?? '0')) /
          21;
    }

    if (name == 'SOCS-S') {
      calculatedSubScores['Acting to alleviate suffering'] = 100 *
          (int.parse(answers['4'] ?? '0') +
              int.parse(answers['9'] ?? '0') +
              int.parse(answers['14'] ?? '0') +
              int.parse(answers['19'] ?? '0')) /
          20;
    }
  }

  // Save the new sub scores to Firestore
  await userDoc.update({
    'subScores': calculatedSubScores,
  });

  print("Sub scores updated successfully!");
}

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
  for (var entry in completedQuestionnaires.entries) {
    String name = entry.key;
    String docId = entry.value;

    DocumentSnapshot responseSnapshot =
        await userDoc.collection('responses').doc(docId).get();
    var responseData = responseSnapshot.data() as Map<String, dynamic>;
    Map<String, String> answers =
        Map<String, String>.from(responseData['answers']);

    if (name == 'ERQ') {
      int ERQ_R = 0;
      int ERQ_S = 0;
      for (var i in answers.keys) {
        int score = int.parse(answers[i]!);
        if ([1, 3, 5, 7, 8, 10].contains(int.parse(i))) {
          ERQ_R += score;
        } else {
          ERQ_S += score;
        }
      }
      subScores['ERQ_R'] = ERQ_R;
      subScores['ERQ_S'] = ERQ_S;
    } else {
      int tempScore = 0;
      for (var score in answers.values) {
        tempScore += int.parse(score);
      }
      subScores[name] = tempScore;
    }
  }

  double mentalHealthScore =
      1 - (0.5 * ((subScores['GAD-7']! / 21) + (subScores['PHQ-9']! / 27)));
  double weightedScore = (0.4 * subScores['PWB']! +
      0.25 * subScores['SOCS-S']! +
      0.25 * subScores['CPC-12R']! +
      0.1 * (subScores['ERQ_R']! + (28 - subScores['ERQ_S']!)));

  double overallScore = ((mentalHealthScore + weightedScore) / 2);
  // Save the new scores
  await userDoc.update({'overallScore': overallScore, 'calculatedScore': true});

  print("Scores updated successfully!");
}

Future<double> getOverallScore() async {
  User? user = FirebaseAuth.instance.currentUser;
  FirebaseFirestore db = FirebaseFirestore.instance;

  try {
    DocumentSnapshot userSnapshot =
        await db.collection('Profile').doc(user!.uid).get();
    var data = userSnapshot.data() as Map<String, dynamic>;
    return data['overallScore'];
  } catch (e) {
    return 0.0;
  }
}

Future<Map<String, double>> getSubScores() async {
  User? user = FirebaseAuth.instance.currentUser;
  FirebaseFirestore db = FirebaseFirestore.instance;

  try {
    DocumentSnapshot userSnapshot =
        await db.collection('Profile').doc(user!.uid).get();
    var data = userSnapshot.data() as Map<String, dynamic>;

    return {
      "Resilience": (data['subScores']?['Resilience'] ?? 0.0).toDouble(),
      "Self-efficacy": (data['subScores']?['Self-efficacy'] ?? 0.0).toDouble(),
      "Personal growth":
          (data['subScores']?['Personal growth'] ?? 0.0).toDouble(),
      "Self-Acceptance":
          (data['subScores']?['Self-Acceptance'] ?? 0.0).toDouble(),
      "Alleviating suffering":
          (data['subScores']?['Alleviating suffering'] ?? 0.0).toDouble(),
    };
  } catch (e) {
    return {
      "Resilience": 0.0,
      "Self-efficacy": 0.0,
      "Personal growth": 0.0,
      "Self-Acceptance": 0.0,
      "Alleviating suffering": 0.0,
    };
  }
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
