import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ScoreGraph extends StatelessWidget {
  final List<List<double>> scores;
  final List<String> months;

  const ScoreGraph({
    super.key,
    required this.scores,
    required this.months,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: 300,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blueAccent),
        borderRadius: BorderRadius.circular(10),
      ),
      child: LineChart(
        LineChartData(
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              axisNameWidget: const RotatedBox(
                quarterTurns: 0,
                child: Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Text(
                    "Percentage (%)",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, _) {
                  return (value % 20 == 0) // Display every 20 units
                      ? Text(
                          value.toInt().toString(),
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        )
                      : const SizedBox.shrink();
                },
              ),
            ),
            rightTitles: AxisTitles(
                sideTitles:
                    SideTitles(showTitles: false)), // Hide right numbers
            topTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false)), // Hide top numbers
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, _) {
                  int index = value.toInt();
                  return (index >= 0 && index < months.length)
                      ? Text(months[index],
                          style: const TextStyle(fontSize: 12))
                      : const SizedBox.shrink();
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: true),
          gridData: FlGridData(
            show: true,
            drawHorizontalLine: true,
            horizontalInterval: 20, // Draw grid lines every 20 units
          ),
          lineBarsData: _buildLineBarsData(),
          minY: 0,
          maxY: 100, // Ensure Y-axis goes up to 100
        ),
      ),
    );
  }

  List<LineChartBarData> _buildLineBarsData() {
    List<Color> colors = [
      Colors.red,
      Colors.black,
      Colors.blue,
      Colors.green,
      Colors.orange
    ];

    return List.generate(scores.length, (lineIndex) {
      return LineChartBarData(
        spots: List.generate(scores[lineIndex].length,
            (i) => FlSpot(i.toDouble(), scores[lineIndex][i])),
        isCurved: true,
        color: colors[lineIndex % colors.length],
        barWidth: 3,
        dotData: FlDotData(show: false),
      );
    });
  }
}
