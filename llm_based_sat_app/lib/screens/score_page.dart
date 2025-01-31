import 'package:flutter/material.dart';
import 'package:llm_based_sat_app/widgets/score_widgets/circular_progress_bar.dart';
import 'package:llm_based_sat_app/widgets/score_widgets/progress_row.dart';
import 'package:llm_based_sat_app/widgets/score_widgets/score_graph.dart';
import '../widgets/custom_app_bar.dart';

class ScorePage extends StatelessWidget {
  final Function(int) onItemTapped;
  final int selectedIndex;

  const ScorePage(
      {super.key, required this.onItemTapped, required this.selectedIndex});

  static const progressDataTop = [
    {"percentage": 67.0, "title": "Positive Emotions"},
    {"percentage": 67.0, "title": "Engagement"},
    {"percentage": 67.0, "title": "Relationships"},
  ];

  static const progressDataBottom = [
    {"percentage": 67.0, "title": "Meaning"},
    {"percentage": 67.0, "title": "Accomplishment"},
  ];

  // Example dynamic data
  static const List<List<double>> scores = [
    [10, 30, 50, 70, 85, 90, 95], // Line 1 (e.g., Engagement)
    [10, 25, 45, 65, 80, 85, 90], // Line 2 (e.g., Positive Emotions)
    [5, 20, 40, 55, 60, 75, 80], // Line 3 (e.g., Meaning)
    [8, 18, 30, 40, 50, 60, 65], // Line 4 (e.g., Accomplishment)
  ];

  static const List<String> months = [
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sept"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          title: "InvinciMind",
          onItemTapped: onItemTapped,
          selectedIndex: selectedIndex,
          backButton: false,
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            CircularProgressBar(
                percentage: 67, title: "Overall", inMiddle: true),
            ProgressRow(progressData: progressDataTop),
            ProgressRow(progressData: progressDataBottom),
            ScoreGraph(scores: scores, months: months),
          ]),
        ));
  }
}
