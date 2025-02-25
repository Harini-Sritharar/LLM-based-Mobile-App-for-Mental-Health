import 'package:flutter/material.dart';
import 'package:llm_based_sat_app/widgets/custom_app_bar.dart';

class ExerciseEvaluationPage extends StatelessWidget {
  const ExerciseEvaluationPage({super.key});

  // mutliple choice questions
  static const mcq = [
    {
      "On a scale of 1 to 5, how much did you enjoy this exercise",
      [
        {"1": "Did Not Enjoy at All (I disliked the exercise.)"},
        {"2": "Slightly Enjoyable (It was okay but not engaging.)"},
        {"3": "Neutral (I neither liked nor disliked it.)"},
        {"4": "Enjoyable (I liked the exercise and found it engaging.)"},
        {
          "5":
              "Enjoyed a Lot (I thoroughly enjoyed the exercise and would do it again.)"
        }
      ]
    },
    {
      "On a scale of 1 to 5, how much did this exercise improve your emotional state?",
      [
        {"1": "Felt Worse (The exercise negatively affected my mood.)"},
        {
          "2":
              "Slight Improvement (I felt slightly better after completing the exercise.)"
        },
        {"3": "No Change (I did not feel any different.)"},
        {"4": "Moderate Improvement (I felt noticeably better.)"},
        {"5": "Felt Much Better (The exercise significantly improved my mood.)"}
      ]
    }
  ];

  static const openEnded = [
    {
      "Did you face any issues while completing this exercise? (e.g., technical difficulties, unclear instructions, etc.) ",
      []
    },
    {
      "Would you like to share any personal thoughts or comments about this exercise? (e.g., how it made you feel, suggestions, or other reflections)",
      []
    }
  ];

  static Map<String, String> selectedAnswers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
            title: "Exercise Evaluation",
            onItemTapped: (x) => {},
            selectedIndex: 0),
        body: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            ...mcq.map((questionSet) {
              // Extract question and answers
              String question =
                  questionSet.firstWhere((e) => e is String) as String;
              List<Map<String, String>> answers = questionSet
                  .firstWhere((e) => e is List) as List<Map<String, String>>;

              return Card(
                margin: EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //     RadioListTile<String>(
                      //     title: Text('$key: $value'),
                      //     value: key,
                      //     groupValue: selectedAnswers[question], // Bind selection
                      //     onChanged: (selectedValue) {
                      //       setState(() {
                      //         selectedAnswers[question] = selectedValue!;
                      //       });
                      //     },
                      //   );
                      // }).toList(),
                      Text(question,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      ...answers.map((answerMap) {
                        String key = answerMap.keys.first;
                        String value = answerMap[key]!;
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 4),
                          child: Text('$key: $value'),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              );
            }).toList(),

            // Open-ended questions
            ...openEnded.map((questionSet) {
              String question =
                  questionSet.firstWhere((e) => e is String) as String;

              return Card(
                margin: EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(question,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      TextField(
                        maxLines: 5,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Type your response here...',
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
            Center(
                child: ElevatedButton(
              onPressed: () {
                // widget.onComplete(widget.questionnaireName);
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 40.0, vertical: 12.0),
                child: Text("Submit", style: TextStyle(fontSize: 16)),
              ),
            )),
          ]),
        ));
  }
}