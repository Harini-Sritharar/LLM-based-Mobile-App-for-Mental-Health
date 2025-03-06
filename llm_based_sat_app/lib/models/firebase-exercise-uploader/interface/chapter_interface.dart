import 'package:llm_based_sat_app/models/firebase-exercise-uploader/interface/exercise_interface.dart';

/// Represents a chapter within a course, containing exercises and relevant details.
class Chapter {
  final String id; // Unique identifier for the chapter.
  final String chapterTitle; // Title of the chapter.
  final String aim; // The learning objective or aim of the chapter.
  final List<Exercise> exercises; // List of exercises within the chapter.

  /// Constructor to initialize a Chapter instance.
  /// By default, the exercises list is empty if not provided.
  Chapter({
    required this.id,
    required this.chapterTitle,
    required this.aim,
    this.exercises = const [],
  });

  /// Factory method to create a `Chapter` instance from Firestore data.
  /// - `id`: The Firestore document ID.
  /// - `data`: The Firestore document data as a Map.
  factory Chapter.fromFirestore(String id, Map<String, dynamic> data) {
    return Chapter(
      id: id,
      chapterTitle:
          data['Chapter_title'] ?? '', // Defaults to empty string if missing.
      aim: data['Aim'] ?? '', // Defaults to empty string if missing.
    );
  }

  /// Returns a new `Chapter` instance with exercises attached.
  /// Used to populate a chapter with its corresponding exercises after fetching them separately.
  Chapter withExercises(List<Exercise> exercises) {
    return Chapter(
      id: id,
      chapterTitle: chapterTitle,
      aim: aim,
      exercises: exercises,
    );
  }
}
