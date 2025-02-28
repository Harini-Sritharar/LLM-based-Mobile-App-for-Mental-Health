import 'package:flutter/material.dart';
import 'package:llm_based_sat_app/firebase/firebase_questionnaire.dart';
import 'package:llm_based_sat_app/firebase/firebase_score.dart';
import 'package:llm_based_sat_app/widgets/assessment_widgets/slider_question.dart';

/// A stateful widget representing an individual questionnaire page.
class QuestionnairePage extends StatefulWidget {
  /// The name of the questionnaire
  final String questionnaireName;

  /// Callback function to mark a questionnaire as completed.
  final Function(String) onComplete;

  QuestionnairePage(
      {required this.questionnaireName, required this.onComplete});

  @override
  _QuestionnairePageState createState() => _QuestionnairePageState();
}

/// State class for handling the questionnaire interactions.
class _QuestionnairePageState extends State<QuestionnairePage> {
  /// Stores user responses to the questionnaire.
  final Map<int, int> responses = {};
  List<String> questions = [];
  String description = "";

  @override
  void initState() {
    super.initState();
    getQuestionnaireData();
  }

  void getQuestionnaireData() async {
    Map<String, dynamic>? questionnaireData =
        await fetchQuestionnaireData(widget.questionnaireName);
    if (questionnaireData != null) {
      if (!mounted) return;
      setState(() {
        responses.clear();
        description = questionnaireData['description'] as String;
        questions = questionnaireData['questions'] as List<String>;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    /// Defines valid response ranges for each questionnaire.
    Map<String, Map<String, int>> questionnaireRanges = {
      'GAD-7': {'min': 0, 'max': 3},
      'PHQ-9': {'min': 0, 'max': 3},
      'PWB': {'min': 1, 'max': 7},
      'SOCS-S': {'min': 1, 'max': 5},
      'CPC-12R': {'min': 1, 'max': 6},
      'ERQ': {'min': 1, 'max': 7},
    };

    int minValue = questionnaireRanges[widget.questionnaireName]?['min'] ?? 1;
    int maxValue = questionnaireRanges[widget.questionnaireName]?['max'] ?? 7;

    return Scaffold(
      appBar: AppBar(title: Text(widget.questionnaireName)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                description,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              ...questions.asMap().entries.map((entry) {
                int index = entry.key;
                String question = entry.value;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: SliderQuestion(
                    title: question,
                    minValue: minValue,
                    maxValue: maxValue,
                    value: responses[index] ?? minValue,
                    onChanged: (newValue) {
                      setState(() {
                        responses[index] = newValue;
                      });
                    },
                  ),
                );
              }).toList(),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  saveQuestionnaireResponse(
                      widget.questionnaireName, responses);
                  widget.onComplete(widget.questionnaireName);
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40.0, vertical: 12.0),
                  child: Text("Submit", style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
