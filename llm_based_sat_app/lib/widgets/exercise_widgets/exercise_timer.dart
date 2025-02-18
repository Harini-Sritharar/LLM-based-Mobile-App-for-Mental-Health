import 'package:flutter/material.dart';
import 'package:llm_based_sat_app/theme/app_colours.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

// TODO
// Reset the cached timer when exercise is completed

/* A widget that acts as a stopwatch and caches the elapsed time
so that it can persist across widget rebuilds or app restarts. */
class ExerciseTimer extends StatefulWidget {
  const ExerciseTimer({super.key});

  @override
  _ExerciseTimerState createState() => _ExerciseTimerState();
}

class _ExerciseTimerState extends State<ExerciseTimer> {
  late Stopwatch stopwatch; // The Stopwatch object to track elapsed time
  late Timer timer; // A periodic timer to update the UI

  Color textColor = AppColours.brandBluePlusTwo; // Text color for timer
  Color backgroundColor = AppColours.brandBlueMinusThree; // Background color for timer

  bool isPaused = false; // To track pause/resume state
  int offsetTimeMillis = 0; // Offset time to add to the stopwatch

  @override
  void initState() {
    super.initState();
    stopwatch = Stopwatch(); // Initialize the stopwatch

    // Load the previously cached time and start the stopwatch
    _loadInitialTime().then((_) {
      stopwatch.start();
    });

    // Create a periodic timer to update the UI every 10ms
    timer = Timer.periodic(const Duration(milliseconds: 10), (Timer t) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    // Cancel the timer and stop the stopwatch when the widget is disposed
    _resetCachedTimer();
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
                _buildTimeSection(
                    _formatMinutes(
                        stopwatch.elapsedMilliseconds + offsetTimeMillis),
                    30),
                const SizedBox(width: 10), // Gap between minutes and ":"

                // ":"
                Text(
                  ":",
                  style: TextStyle(fontSize: 25.0, color: textColor),
                ),
                const SizedBox(width: 10), // Gap between ":" and seconds

                // Seconds
                _buildTimeSection(
                    _formatSeconds(
                        stopwatch.elapsedMilliseconds + offsetTimeMillis),
                    30),
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
                      'assets/icons/pause.png',
                      width: 20,
                      height: 20,
                    ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds a time section (minutes or seconds) with the SevenSegment font
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

  // Formats the minutes and saves time elapsed to cache
  String _formatMinutes(int milliseconds) {
    // Saving the current time in cache every second
    _saveElapsedTime(); // Save the current elapsed time to cache

    final minutes = milliseconds ~/ 60000;
    return minutes.toString().padLeft(2, '0');
  }

  // Formats the seconds
  String _formatSeconds(int milliseconds) {
    final seconds = (milliseconds ~/ 1000) % 60;
    return seconds.toString().padLeft(2, '0');
  }

  // Toggles pause and resume
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

  /// Loads the cached elapsed time (if any) from shared preferences
  Future<void> _loadInitialTime() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      offsetTimeMillis = prefs.getInt('exercise_timer_elapsed') ?? 0;
    });
  }

  /// Saves the current elapsed time to shared preferences for persistence
  Future<void> _saveElapsedTime() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('exercise_timer_elapsed',
        stopwatch.elapsedMilliseconds + offsetTimeMillis);
  }

  // Resets the cached timer to 0 and resets the stopwatch
  Future<void> _resetCachedTimer() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('exercise_timer_elapsed', 0); // Reset cache
  }
}
