import 'package:flutter/material.dart';

class QuestionnaireAssessmentsPage extends StatefulWidget {
  @override
  _QuestionnaireAssessmentsPageState createState() =>
      _QuestionnaireAssessmentsPageState();
}

class _QuestionnaireAssessmentsPageState
    extends State<QuestionnaireAssessmentsPage> {
  final List<Map<String, dynamic>> questionnaires = [
    {'name': 'GAD-7', 'description': 'Anxiety'},
    {'name': 'PHQ-9', 'description': 'Depression'},
    {'name': 'PWB', 'description': 'Wellbeing'},
    {'name': 'SOCS-S', 'description': 'Self-Compassion'},
    {'name': 'CPC-12R', 'description': 'Psychological Capital'},
    {'name': 'ERQ_R', 'description': 'Reappraisal'},
    {'name': 'ERQ_S', 'description': 'Suppression'},
  ];

  Set<String> completedQuestionnaires = {};

  void completeQuestionnaire(String name) {
    setState(() {
      completedQuestionnaires.add(name);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Assessments"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
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

class QuestionnairePage extends StatelessWidget {
  final String questionnaireName;
  final Function(String) onComplete;

  QuestionnairePage(
      {required this.questionnaireName, required this.onComplete});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(questionnaireName),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            onComplete(questionnaireName);
            Navigator.pop(context);
          },
          child: Text("Submit Answers"),
        ),
      ),
    );
  }
}
