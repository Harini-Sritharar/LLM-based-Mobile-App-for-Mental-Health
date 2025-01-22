import 'package:llm_based_sat_app/models/chapter_exercise_interface.dart';

class ChapterInterface {
  final int chapterNumber;
  final String chapterTitle;
  final List<ChapterExerciseInterface> exercises;
  final bool isLocked;
  

  ChapterInterface({
    required this.chapterNumber,
    required this.chapterTitle,
    required this.exercises,
    required this.isLocked,
  });
}
