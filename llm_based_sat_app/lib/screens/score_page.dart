import 'package:flutter/material.dart';
import 'package:llm_based_sat_app/widgets/score_widgets/circular_progress_bar.dart';
import 'package:llm_based_sat_app/widgets/score_widgets/progress_row.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          title: "InvinciMind",
          onItemTapped: onItemTapped,
          selectedIndex: selectedIndex,
          backButton: false,
        ),
        body: Center(
          child: Column(children: [
            CircularProgressBar(
                percentage: 67, title: "Overall", inMiddle: true),
            ProgressRow(progressData: progressDataTop),
            ProgressRow(progressData: progressDataBottom)
          ]),
        ));
  }
}
