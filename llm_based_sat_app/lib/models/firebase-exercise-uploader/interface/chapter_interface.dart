import 'package:llm_based_sat_app/models/firebase-exercise-uploader/interface/exercise_interface.dart';

class Chapter {
  final String id;
  final String chapterTitle;
  final String aim;
  final List<Exercise> exercises;

  Chapter({
    required this.id,
    required this.chapterTitle,
    required this.aim,
    this.exercises = const [],
  });

  // Factory method to create a Chapter from Firestore data
  factory Chapter.fromFirestore(String id, Map<String, dynamic> data) {
    return Chapter(
        id: id,
        chapterTitle: data['Chapter_title'] ?? '',
        aim: data['Aim'] ?? '');
  }

  // Method to attach chapters to a course
  Chapter withExercises(List<Exercise> exercises) {
    return Chapter(
        id: id, chapterTitle: chapterTitle, aim: aim, exercises: exercises);
  }
}
