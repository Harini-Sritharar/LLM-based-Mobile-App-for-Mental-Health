import '../data/cache_manager.dart';
import '../models/chapter_exercise_step_interface.dart';
import '../models/firebase-exercise-uploader/interface/course_interface.dart';
import '../models/firebase-exercise-uploader/interface/exercise_interface.dart';

String getExerciseLetter(String input) {
  // Use split to find the last letter between underscores
  List<String> parts = input.split('_');

  // Check if the string is valid and has enough parts
  if (parts.length > 2) {
    String secondLast = parts[parts.length - 2];

    // Ensure it's a single letter (in case of invalid input)
    if (RegExp(r'^[A-Za-z]$').hasMatch(secondLast)) {
      return secondLast;
    }
  }
  throw ArgumentError("No valid letter found between underscores.");
}

getSessions(Exercise exercise, Course course) {
    if (CacheManager.getValue(course.id) == null) {
      return 0;
    }

    List<ChapterExerciseStep> courseProgress = CacheManager.getValue(course.id);
    for (final progress in courseProgress) {
      if (progress.exercise.trim() == exercise.id.trim()) {
        return int.parse(progress.session);
      }
    }
    return 0;
  }