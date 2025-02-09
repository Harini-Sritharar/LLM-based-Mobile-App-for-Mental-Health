import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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