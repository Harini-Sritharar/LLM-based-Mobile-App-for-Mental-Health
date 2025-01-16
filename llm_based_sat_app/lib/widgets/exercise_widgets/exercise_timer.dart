import 'package:flutter/material.dart';
import 'dart:async';

// TODO
// Have it so that it accepts the time to continue from so that continous pages have timers continuing from prev page 

class ExerciseTimer extends StatefulWidget {
  const ExerciseTimer({super.key});

  @override
  _ExerciseTimerState createState() => _ExerciseTimerState();
}

class _ExerciseTimerState extends State<ExerciseTimer> {
  late Stopwatch stopwatch;
  late Timer timer;

  Color textColor = const Color(0xFF123659); // Text color for timer
  Color backgroundColor = const Color(0xFFCEDFF2); // Background color for timer

  @override
  void initState() {
    super.initState();
    stopwatch = Stopwatch()..start();

    timer = Timer.periodic(const Duration(milliseconds: 10), (Timer t) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    timer.cancel();
    stopwatch.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: backgroundColor, // Light blue background
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min, // Makes the row fit the text width
          children: [
            // Minutes
            _buildTimeSection(_formatMinutes(stopwatch.elapsed), 30),
            const SizedBox(width: 10), // Gap between minutes and ":"

            // ":"
            Text(
              ":",
              style: TextStyle(fontSize: 25.0, color: textColor),
            ),
            const SizedBox(width: 10), // Gap between ":" and seconds

            // Seconds
            _buildTimeSection(_formatSeconds(stopwatch.elapsed), 30),
            const SizedBox(width: 8), // Gap between seconds and milliseconds

            // Milliseconds
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: _buildTimeSection(
                    _formatMilliseconds(stopwatch.elapsed), 25),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build each time section
  Widget _buildTimeSection(String text, double fontSize) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontFamily: 'SevenSegment',
        color: textColor,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  // Formats the minutes
  String _formatMinutes(Duration duration) {
    final minutes = duration.inMinutes;
    return minutes.toString().padLeft(2, '0');
  }

  // Formats the seconds
  String _formatSeconds(Duration duration) {
    final seconds = duration.inSeconds % 60;
    return seconds.toString().padLeft(2, '0');
  }

  // Formats the milliseconds
  String _formatMilliseconds(Duration duration) {
    final hundredths = (duration.inMilliseconds % 1000) ~/ 10;
    return hundredths.toString().padLeft(2, '0');
  }
}
