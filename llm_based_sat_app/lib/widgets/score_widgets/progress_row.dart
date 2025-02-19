import 'package:flutter/material.dart';
import 'package:llm_based_sat_app/widgets/score_widgets/circular_progress_bar.dart';

class ProgressRow extends StatelessWidget {
  final List<Map<String, dynamic>> progressData;

  const ProgressRow({super.key, required this.progressData});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: progressData
              .map((data) => Flexible(
                    child: CircularProgressBar(
                      percentage: data["percentage"],
                      title: data["title"],
                      inMiddle: false,
                    ),
                  ))
              .toList(),
        );
      },
    );
  }
}
