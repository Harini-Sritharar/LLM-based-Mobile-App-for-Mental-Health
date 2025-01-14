import 'package:flutter/material.dart';

class ExerciseTimer extends StatefulWidget {
  const ExerciseTimer();

  @override
  _ExerciseTimerState createState() => _ExerciseTimerState();
}

class _ExerciseTimerState extends State<ExerciseTimer> {
  late Duration timerDuration;
  late Stopwatch stopwatch;

  @override
  void initState() {
    super.initState();
    timerDuration = const Duration(seconds: 0);
    stopwatch = Stopwatch()..start();

    // Update timer every second
    Future.doWhile(() async {
      if (!stopwatch.isRunning) return false;
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        setState(() {
          timerDuration = stopwatch.elapsed;
        });
      }
      return true;
    });
  }

  @override
  void dispose() {
    stopwatch.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      padding: const EdgeInsets.all(12),
      child: Center(
        child: Text(
          _formatDuration(timerDuration),
          style: const TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }

  // Helper function to format timer
  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
