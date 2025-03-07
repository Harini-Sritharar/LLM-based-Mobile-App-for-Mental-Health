import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/* Manages the state of an exercise timer using a singleton pattern.

This class provides functionality to start, pause, resume, and stop a timer for tracking exercise durations. The elapsed time persists across sessions using SharedPreferences, allowing users to resume from where they left.

## Usage:
ExerciseTimerManager timerManager = ExerciseTimerManager();
This ensures a consistent state across multiple widgets.

## Parameters:
- `_stopwatch`: Tracks elapsed time.
- `_timer`: Periodic timer that updates UI listeners.
- `_offsetTimeMillis`: Stores the cached elapsed time from previous sessions.
- `_isPaused`: Indicates whether the timer is currently paused.
- `_exerciseId`: The unique ID of the exercise being tracked. */
class ExerciseTimerManager extends ChangeNotifier {
  static final ExerciseTimerManager _instance =
      ExerciseTimerManager._internal();
  factory ExerciseTimerManager() => _instance;

  ExerciseTimerManager._internal();

  final Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;
  int _offsetTimeMillis = 0;
  bool _isPaused = false;
  String? _exerciseId; // Track the current exercise ID

  /// Get elapsed time in milliseconds (including offset)
  int get elapsedTimeMillis =>
      _stopwatch.elapsedMilliseconds + _offsetTimeMillis;

  /// Check if the timer is running
  bool get isRunning => _stopwatch.isRunning;

  /// Check if the timer is paused
  bool get isPaused => _isPaused;

  /// Start or resume the timer
  Future<void> startTimer(String exerciseId) async {
    _exerciseId = exerciseId;
    await _loadInitialTime();

    final prefs = await SharedPreferences.getInstance();
    _isPaused = prefs.getBool('exercise_timer_paused_$_exerciseId') ?? false;

    if (!_isPaused) {
      _stopwatch.start();
    }

    _timer ??= Timer.periodic(const Duration(milliseconds: 10), (timer) {
      notifyListeners();
    });

    notifyListeners();
  }

  /// Pause the timer
  void pauseTimer() async {
    _stopwatch.stop();
    _isPaused = true;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('exercise_timer_paused_$_exerciseId', true);

    notifyListeners();
  }

  /// Resume the timer
  void resumeTimer() async {
    _stopwatch.start();
    _isPaused = false;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('exercise_timer_paused_$_exerciseId', false);

    notifyListeners();
  }

  /// Stop the timer and reset it
  Future<void> stopTimer() async {
    _stopwatch.stop();
    _timer?.cancel();
    _timer = null;
    _isPaused = false;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('exercise_timer_paused_$_exerciseId', false);
    await _resetCachedTimer();

    notifyListeners();
  }

  /// Reset timer and clear stored time
  Future<void> resetTimer() async {
    _stopwatch.reset();
    _offsetTimeMillis = 0;
    await _resetCachedTimer();
    notifyListeners();
  }

  /// Load cached elapsed time
  Future<void> _loadInitialTime() async {
    if (_exerciseId == null) return;

    final prefs = await SharedPreferences.getInstance();
    _offsetTimeMillis =
        prefs.getInt('exercise_timer_elapsed_$_exerciseId') ?? 0;
    notifyListeners();
  }

  /// Save elapsed time to shared preferences
  Future<void> saveElapsedTime() async {
    if (_exerciseId == null) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
        'exercise_timer_elapsed_$_exerciseId', elapsedTimeMillis);
  }

  /// Reset cached time when exercise is completed
  Future<void> _resetCachedTimer() async {
    if (_exerciseId == null) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('exercise_timer_elapsed_$_exerciseId', 0);
  }

  /// Get elapsed time in given format (e.g., "Elapsed Time: 30 seconds" or "Elapsed Time: 2 minutes 30 seconds")
  String getElapsedTimeFormatted() {
    int totalSeconds = elapsedTimeMillis ~/ 1000;
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;

    if (minutes == 0) {
      return "Elapsed Time: $seconds seconds";
    }
    return "Elapsed Time: $minutes minutes $seconds seconds";
  }
}
