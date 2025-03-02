import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

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
  Map<String, Map<String, List<double>>> subscoreHistory = {};
  String currentMonth = DateFormat.MMMM().format(DateTime.now());
  List<String> subscoreNames = [
    "Resilience",
    'Self-efficacy',
    'Personal growth',
    'Self-Acceptance',
    'Acting to alleviate suffering'
  ];

  if (data['subScoresHistory'] != null &&
      data['subScoresHistory'] is Map<String, dynamic>) {
    subscoreHistory = (data['subScoresHistory'] as Map<String, dynamic>)
        .map<String, Map<String, List<double>>>(
      (key, value) => MapEntry(
        key,
        (value as Map<String, dynamic>).map<String, List<double>>(
          (month, scores) => MapEntry(
            month,
            scores is List<dynamic>
                ? scores
                    .map((e) => (e as num).toDouble())
                    .toList() // Convert list elements to double
                : [], // Default empty list if the value isn't a list
          ),
        ),
      ),
    );
  }

// Iterate through each of the subscores and update the history
  for (String subscore in subscoreNames) {
    // Fetching or creating the inner history map
    Map<String, List<double>> history =
        subscoreHistory.putIfAbsent(subscore, () => <String, List<double>>{});

    // Appending the new score to the correct month
    history
        .putIfAbsent(currentMonth, () => [])
        .add(calculatedSubScores[subscore]!);

    // Updating the outer map with the modified inner map
    subscoreHistory[subscore] = history;
  }

// Save to Firestore
  await userDoc.update({
    'subScores': calculatedSubScores,
    'subScoresHistory': subscoreHistory,
  });
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

  Map<String, List<double>> scoresMap = {};
  String currentMonth = DateFormat.MMMM().format(DateTime.now());

  if (data['scores'] != null && data['scores'] is Map<String, dynamic>) {
    scoresMap =
        (data['scores'] as Map<String, dynamic>).map<String, List<double>>(
      (key, value) => MapEntry(
        key,
        value is List<dynamic> // Ensure it's a list before conversion
            ? value.map((e) => (e as num).toDouble()).toList()
            : [], // Default to an empty list if value is invalid
      ),
    );
  }

// Ensure we add the score to the correct month
  scoresMap.putIfAbsent(currentMonth, () => []).add(overallScore);

  // check if the scores already exists
  // Save the new scores
  await userDoc.update({
    'overallScore': overallScore,
    'calculatedScore': true,
    'scores': scoresMap
  });

  print("Scores updated successfully!");
}

Future<double> getOverallScore() async {
  User? user = FirebaseAuth.instance.currentUser;
  FirebaseFirestore db = FirebaseFirestore.instance;

  try {
    DocumentSnapshot userSnapshot =
        await db.collection('Profile').doc(user!.uid).get();
    var data = userSnapshot.data() as Map<String, dynamic>;
    return (data['overallScore'] as double?) ?? 0.0;
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

Future<Map<String, dynamic>> getAverageSubScores() async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    return {"months": [], "averages": []};
  }

  FirebaseFirestore db = FirebaseFirestore.instance;
  DocumentReference userDoc = db.collection('Profile').doc(user.uid);

  DocumentSnapshot userSnapshot = await userDoc.get();
  var data = userSnapshot.data() as Map<String, dynamic>;

  if (data['subScoresHistory'] == null) {
    return {"months": [], "averages": []};
  }

  // Convert Firestore data to a proper map
  Map<String, Map<String, List<double>>> subScoresHistory =
      (data['subScoresHistory'] as Map<String, dynamic>).map(
    (subscore, monthsMap) => MapEntry(
      subscore,
      (monthsMap as Map<String, dynamic>).map(
        (month, scoresList) => MapEntry(
          month,
          (scoresList as List<dynamic>)
              .map((e) => (e as num).toDouble())
              .toList(),
        ),
      ),
    ),
  );

  // Define the chronological order of months
  List<String> monthOrder = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];

  // Get all unique months in chronological order
  Set<String> allMonths = {};
  for (var subscoreMap in subScoresHistory.values) {
    allMonths.addAll(subscoreMap.keys);
  }
  List<String> sortedMonths = allMonths.toList()
    ..sort((a, b) => monthOrder.indexOf(a).compareTo(monthOrder.indexOf(b)));

  // Initialize subscore averages per month
  List<List<double>> averages = List.generate(
    subScoresHistory.keys.length, // One list per subscore
    (_) => List.filled(
        sortedMonths.length, 0.0), // Placeholder for monthly averages
  );

  // Compute averages
  int subscoreIndex = 0;
  for (String subscore in subScoresHistory.keys) {
    Map<String, List<double>> monthToScores = subScoresHistory[subscore]!;

    for (int i = 0; i < sortedMonths.length; i++) {
      String month = sortedMonths[i];

      if (monthToScores.containsKey(month)) {
        List<double> scores = monthToScores[month]!;
        averages[subscoreIndex][i] =
            scores.reduce((a, b) => a + b) / scores.length; // Compute average
      }
    }
    subscoreIndex++;
  }

  // Return both months and averages
  return {"months": sortedMonths, "averages": averages};
}
