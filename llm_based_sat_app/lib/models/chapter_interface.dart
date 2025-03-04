import 'package:llm_based_sat_app/models/chapter_exercise_interface.dart';

/// A class representing a chapter in a learning module.
/// It contains the chapter's number, title, a list of associated exercises,
/// and a flag indicating whether the chapter is locked or accessible.
class ChapterInterface {
  /// The number of the chapter (e.g., 1, 2, 3, etc.).
  final int chapterNumber;

  /// The title or name of the chapter.
  final String chapterTitle;

  /// A list of [ChapterExerciseInterface] objects that represent the exercises
  /// associated with this chapter.
  final List<ChapterExerciseInterface> exercises;

  /// A boolean flag indicating whether the chapter is locked (i.e., not yet accessible)
  /// or unlocked (i.e., available for the user to access and complete).
  final bool isLocked;

  /// Constructor to initialize the [ChapterInterface] with the provided parameters.
  ///
  /// [chapterNumber] - The number of the chapter (e.g., 1, 2, 3).
  /// [chapterTitle] - The title of the chapter (e.g., "Introduction to Algebra").
  /// [exercises] - A list of [ChapterExerciseInterface] objects that represent the exercises
  ///               for this chapter.
  /// [isLocked] - A flag indicating whether the chapter is locked or unlocked.
  ChapterInterface({
    required this.chapterNumber,
    required this.chapterTitle,
    required this.exercises,
    required this.isLocked,
  });
}
