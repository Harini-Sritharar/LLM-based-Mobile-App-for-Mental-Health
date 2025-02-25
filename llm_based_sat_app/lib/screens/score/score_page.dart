import 'package:flutter/material.dart';
import 'package:llm_based_sat_app/firebase/firebase_score.dart';
import 'package:llm_based_sat_app/widgets/score_widgets/circular_progress_bar.dart';
import 'package:llm_based_sat_app/widgets/score_widgets/progress_row.dart';
import 'package:llm_based_sat_app/widgets/score_widgets/score_graph.dart';
import '../../widgets/custom_app_bar.dart';

class ScorePage extends StatefulWidget {
  final Function(int) onItemTapped;
  final int selectedIndex;

  ScorePage(
      {super.key, required this.onItemTapped, required this.selectedIndex});

  @override
  _ScorePageState createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {
  List<List<double>> scores = [];
  List<String> months = [];

  double overallScore = 0.0;
  Map<String, double> subScores = {
    "Resilience": 0.0,
    "Self-efficacy": 0.0,
    "Personal growth": 0.0,
    "Self-Acceptance": 0.0,
    "Alleviating suffering": 0.0,
  };

  @override
  void initState() {
    super.initState();
    _loadScores();
  }

  void _onTabSelected(int index) {
    widget.onItemTapped(index);
    if (index == widget.selectedIndex) {
      _loadScores();
    }
  }

  Future<void> _loadScores() async {
    overallScore = await getOverallScore();
    subScores = await getSubScores();
    Map<String, dynamic> res = await getAverageSubScores();
    List<dynamic> x = res["averages"];
    List<dynamic> y = res["months"];
    if (x.isNotEmpty) {
      scores = res["averages"];
    }
    if (y.isNotEmpty) {
      months = res["months"];
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _loadScores();
    // Split subScores into top 3 and bottom 2
    List<Map<String, dynamic>> progressDataTop = [
      {"percentage": subScores["Resilience"]!, "title": "Resilience"},
      {"percentage": subScores["Self-efficacy"]!, "title": "Self-efficacy"},
      {"percentage": subScores["Personal growth"]!, "title": "Personal growth"},
    ];

    List<Map<String, dynamic>> progressDataBottom = [
      {"percentage": subScores["Self-Acceptance"]!, "title": "Self-Acceptance"},
      {
        "percentage": subScores["Alleviating suffering"]!,
        "title": "Alleviating suffering"
      },
    ];
    return Scaffold(
        appBar: CustomAppBar(
          title: "InvinciMind",
          onItemTapped: _onTabSelected,
          selectedIndex: widget.selectedIndex,
          backButton: false,
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            CircularProgressBar(
                percentage: overallScore, title: "Overall", inMiddle: true),
            ProgressRow(progressData: progressDataTop),
            ProgressRow(progressData: progressDataBottom),
            if (months.length >= 3)
              ScoreGraph(scores: scores, months: months)
            else
              Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                Icon(
                  Icons.info_outline,
                  color: Colors.grey,
                  size: 40,
                ),
                SizedBox(height: 8),
                Text(
                  "Continue using the app for 3 months to view your score graph",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                ],
              ),
              ),
          ]),
        ));
  }
}
