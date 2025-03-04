import 'package:flutter/material.dart';
import 'package:llm_based_sat_app/theme/app_colours.dart';
import '../../models/firebase-exercise-uploader/interface/exercise_interface.dart';
import '../../utils/exercise_timer_manager.dart';

/* A stopwatch-style timer widget for tracking exercise duration.

This widget displays a live-updating timer, allowing users to pause and resume the timer as needed. It persists across widget rebuilds and leverages a singleton class, "ExerciseTimerManager", to manage state efficiently across different files.

## Parameters:
- `exercise`: The exercise instance associated with the timer. The exercise ID is used to cache and persist elapsed time. */
class ExerciseTimer extends StatefulWidget {
  final Exercise exercise;
  const ExerciseTimer({super.key, required this.exercise});

  @override
  _ExerciseTimerState createState() => _ExerciseTimerState();
}

class _ExerciseTimerState extends State<ExerciseTimer> {
  final ExerciseTimerManager timerManager = ExerciseTimerManager();

  @override
  void initState() {
    super.initState();
    timerManager.startTimer(widget.exercise.id);
  }

  @override
  void dispose() {
    timerManager.stopTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColours.brandBlueMinusThree,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Stack(
        children: [
          // Timer display
          Align(
            alignment: Alignment.centerLeft,
            child: ListenableBuilder(
              listenable: timerManager,
              builder: (context, _) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildTimeSection(
                        _formatMinutes(timerManager.elapsedTimeMillis), 30),
                    const SizedBox(width: 10),
                    Text(":",
                        style: TextStyle(
                            fontSize: 25.0,
                            color: AppColours.brandBluePlusTwo)),
                    const SizedBox(width: 10),
                    _buildTimeSection(
                        _formatSeconds(timerManager.elapsedTimeMillis), 30),
                  ],
                );
              },
            ),
          ),

          // Pause/Resume button
          Positioned(
            left: 90,
            top: -2,
            child: ElevatedButton(
              onPressed: () {
                if (timerManager.isPaused) {
                  timerManager.resumeTimer();
                } else {
                  timerManager.pauseTimer();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColours.brandBlueMinusThree,
                shape: const CircleBorder(),
                elevation: 0,
                padding: EdgeInsets.zero,
              ),
              child: timerManager.isPaused
                  ? Icon(Icons.play_arrow,
                      size: 20, color: AppColours.brandBluePlusTwo)
                  : Image.asset('assets/icons/pause.png',
                      width: 20, height: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSection(String text, double fontSize) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontFamily: 'SevenSegment',
        color: AppColours.brandBluePlusTwo,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  String _formatMinutes(int milliseconds) {
    return (milliseconds ~/ 60000).toString().padLeft(2, '0');
  }

  String _formatSeconds(int milliseconds) {
    return ((milliseconds ~/ 1000) % 60).toString().padLeft(2, '0');
  }
}
