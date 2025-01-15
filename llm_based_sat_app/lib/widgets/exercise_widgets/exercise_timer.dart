import 'package:flutter/material.dart';
import 'dart:async';

// TODO
// Have it so that it accepts the time to continue from so that continous pages have timers continuing from prev page
// Potentially store the global time state somewhere

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

  bool isPaused = false; // To track pause/resume state

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
      child: Stack(
        children: [
          // Timer display
          Align(
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisSize: MainAxisSize.min,
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
              ],
            ),
          ),

          // Pause/Resume button
          Positioned(
            left: 90, // Sticking to right of parent widget
            top: -2,
            child: ElevatedButton(
              onPressed: _togglePauseResume,
              style: ElevatedButton.styleFrom(
                backgroundColor: backgroundColor,
                shape: const CircleBorder(),
                elevation: 0, // Remove shadow
                padding: EdgeInsets.zero, // No padding
              ),
              child: isPaused
                  ? Icon(
                      Icons.play_arrow,
                      size: 20,
                      color: textColor,
                    )
                  : Image.asset(
                      'assets/icons/pause.png', // Replace with your image path
                      width: 20,
                      height: 20,
                    ),
            ),
          ),
        ],
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

  // Toggles pause and resume functionality
  void _togglePauseResume() {
    setState(() {
      if (isPaused) {
        stopwatch.start();
      } else {
        stopwatch.stop();
      }
      isPaused = !isPaused;
    });
  }
}
