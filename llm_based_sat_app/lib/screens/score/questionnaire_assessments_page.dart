import 'package:flutter/material.dart';
import 'package:llm_based_sat_app/screens/score/questionnaire_page.dart';
import 'package:llm_based_sat_app/widgets/custom_app_bar.dart';

/// QuestionnaireAssessmentsPage - A UI page for handling mental health questionnaires
///
/// This page consists of a list of six questionnaires for the user to complete.
/// Once the user completes all the questionnaires, an overall score should be
/// calculated and dynamically update the scores on the score page.

class QuestionnaireAssessmentsPage extends StatefulWidget {
  const QuestionnaireAssessmentsPage({super.key});

  @override
  _QuestionnaireAssessmentsPageState createState() =>
      _QuestionnaireAssessmentsPageState();
}

class _QuestionnaireAssessmentsPageState
    extends State<QuestionnaireAssessmentsPage> {
  /// List of questionnaires with names and descriptions.
  final List<Map<String, dynamic>> questionnaires = [
    {'name': 'GAD-7', 'description': 'Anxiety'},
    {'name': 'PHQ-9', 'description': 'Depression'},
    {'name': 'PWB', 'description': 'Wellbeing'},
    {'name': 'SOCS-S', 'description': 'Self-Compassion'},
    {'name': 'CPC-12R', 'description': 'Psychological Capital'},
    {'name': 'ERQ', 'description': 'Reappraisal and Suppression'},
  ];

  /// Tracks completed questionnaires.
  Set<String> completedQuestionnaires = {};

  /// Marks a questionnaire as completed.
  void completeQuestionnaire(String name) {
    setState(() {
      completedQuestionnaires.add(name);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Assessments",
        onItemTapped: (x) {},
        selectedIndex: 0,
        backButton: false,
      ),
      // AppBar(
      //   title: Text("Assessments"),
      //   centerTitle: true,
      //   backgroundColor: Colors.blueAccent,
      // ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Complete all questionnaires to calculate your score",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

            /// Displays progress based on completed questionnaires.
            LinearProgressIndicator(
              value: completedQuestionnaires.length / questionnaires.length,
              backgroundColor: Colors.grey[300],
              color: Colors.blueAccent,
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: questionnaires.length,
                itemBuilder: (context, index) {
                  final questionnaire = questionnaires[index];
                  final isCompleted =
                      completedQuestionnaires.contains(questionnaire['name']);
                  return Card(
                    elevation: 3,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                      leading: Icon(
                        isCompleted ? Icons.check_circle : Icons.assignment,
                        color: isCompleted ? Colors.green : Colors.blueAccent,
                      ),
                      title: Text(
                        questionnaire['name'],
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(questionnaire['description']),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        // Navigate to the questionnaire page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QuestionnairePage(
                              questionnaireName: questionnaire['name'],
                              onComplete: completeQuestionnaire,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
