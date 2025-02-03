import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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

  @override
  Widget build(BuildContext context) {
    List<String> questions;

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

    if (widget.questionnaireName == 'GAD-7') {
      questions = [
        "Feeling nervous, anxious, or on edge.",
        "Not being able to stop or control worrying.",
        "Worrying too much about different things.",
        "Trouble relaxing.",
        "Being so restless that it is hard to sit still.",
        "Becoming easily annoyed or irritable.",
        "Feeling afraid as if something awful might happen."
      ];
    } else if (widget.questionnaireName == 'PHQ-9') {
      questions = [
        "Little interest or pleasure in doing things.",
        "Feeling down, depressed, or hopeless.",
        "Trouble falling or staying asleep, or sleeping too much.",
        "Feeling tired or having little energy.",
        "Poor appetite or overeating.",
        "Feeling bad about yourself—or that you are a failure or have let yourself or your family down.",
        "Trouble concentrating on things, such as reading the newspaper or watching television.",
        "Moving or speaking so slowly that other people could have noticed. Or the opposite—being so fidgety or restless that you have been moving around a lot more than usual.",
        "Thoughts that you would be better off dead, or thoughts of hurting yourself in some way."
      ];
    } else if (widget.questionnaireName == 'PWB') {
      questions = [
        "I like most parts of my personality.",
        "When I look at the story of my life, I am pleased with it.",
        "Some people wander aimlessly through life, but I am not one of them.",
        "The demands of everyday life often get me down.",
        "In many ways, I feel disappointed about my achievements in life.",
        "Maintaining close relationships has been difficult and frustrating for me.",
        "I live life one day at a time and don't really think about the future.",
        "In general, I feel I am in charge of the situation in which I live.",
        "I am good at managing the responsibilities of daily life.",
        "I sometimes feel as if I've done all there is to do in life.",
        "For me, life has been a continuous process of learning, changing, and growth.",
        "I think it is important to have new experiences that challenge how I think about myself and the world.",
        "People would describe me as a giving person, willing to share my time with others.",
        "I gave up trying to make big improvements or changes in my life a long time ago.",
        "I tend to be influenced by people with strong opinions.",
        "I have not experienced many warm and trusting relationships with others.",
        "I have confidence in my own opinions, even if they are different from the way most other people think.",
        "I judge myself by what I think is important, not by the values of what others think is important."
      ];
    } else if (widget.questionnaireName == 'SOCS-S') {
      questions = [
        "I'm good at recognising when I'm feeling distressed.",
        "I understand that everyone experiences suffering at some point in their lives.",
        "When I'm going through a difficult time, I feel kindly towards myself.",
        "When I'm upset, I try to stay open to my feelings rather than avoid them.",
        "I try to make myself feel better when I'm distressed, even if I can't do anything about the cause.",
        "I notice when I'm feeling distressed.",
        "I understand that feeling upset at times is part of human nature.",
        "When bad things happen to me, I feel caring towards myself.",
        "I connect with my own distress without letting it overwhelm me.",
        "When I'm going through a difficult time, I try to look after myself.",
        "I'm quick to notice early signs of distress in myself.",
        "Like me, I know that other people also experience struggles in life.",
        "When I'm upset, I try to tune in to how I'm feeling.",
        "I connect with my own suffering without judging myself.",
        "When I'm upset, I try to do what's best for myself.",
        "I recognise signs of suffering in myself.",
        "I know that we can all feel distressed when things don't go well in our lives.",
        "Even when I'm disappointed with myself, I can feel warmly towards myself when I'm in distress.",
        "When I'm upset, I can let the emotions be there without feeling overwhelmed.",
        "When I’m upset, I do my best to take care of myself."
      ];
    } else if (widget.questionnaireName == 'CPC-12R') {
      questions = [
        "I am looking forward to the life ahead of me.",
        "Overall, I expect more good things to happen to me than bad.",
        "The future holds a lot of good in store for me.",
        "If I should find myself in a jam, I could think of many ways to get out of it.",
        "I can think of many ways to reach my current goals.",
        "Right now, I see myself as being pretty successful.",
        "I am confident that I could deal efficiently with unexpected events.",
        "I can solve most problems if I invest the necessary effort.",
        "I can remain calm when facing difficulties because I can rely on my coping abilities.",
        "I consider myself a person who can withstand a lot.",
        "Failure does not discourage me.",
        "I tend to bounce back quickly after serious life difficulties."
      ];
    } else if (widget.questionnaireName == 'ERQ') {
      questions = [
        "When I want to feel more positive emotion (such as joy or amusement), I change what I'm thinking about.",
        "I keep my emotions to myself.",
        "When I want to feel less negative emotion (such as sadness or anger), I change what I'm thinking about.",
        "When I am feeling positive emotions, I am careful not to express them.",
        "When I'm faced with a stressful situation, I make myself think about it in a way that helps me stay calm.",
        "I control my emotions by not expressing them.",
        "When I want to feel more positive emotion, I change the way I'm thinking about the situation.",
        "I control my emotions by changing the way I think about the situation I'm in.",
        "When I am feeling negative emotions, I make sure not to express them.",
        "When I want to feel less negative emotion, I change the way I'm thinking about the situation."
      ];
    } else {
      questions = [
        "Question 1",
        "Question 2",
        "Question 3",
      ];
    }
    return Scaffold(
      appBar: AppBar(title: Text(widget.questionnaireName)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
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
