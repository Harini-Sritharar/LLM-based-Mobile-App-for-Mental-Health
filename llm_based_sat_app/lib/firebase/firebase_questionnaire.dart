import 'package:cloud_firestore/cloud_firestore.dart';

/// Fetches questionnaire data from Firestore based on the given `questionnaireId`.
Future<Map<String,dynamic>?> fetchQuestionnaireData(String questionnaireId) async {
  DocumentSnapshot doc = await FirebaseFirestore.instance.collection('Questionnaires').doc(questionnaireId).get();
  if (doc.exists){
    return doc.data() as Map<String,dynamic>;
  } else {
    return null;
  }
}