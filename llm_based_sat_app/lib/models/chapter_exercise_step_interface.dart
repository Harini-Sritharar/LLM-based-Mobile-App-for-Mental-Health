/* This class is used to help with better managing the input from user progress 
for a given course. It parses the input string, in the format 
"chapter/exercise/step/session", into structured data with properties that can 
be accessed using dot notation for easier manipulation and readability. */

class ChapterExerciseStep {
  final String chapter;
  final String exercise;
  final String step;
  final String session;
  final bool completed; // To track if exercise was completed in the past

  // Constructor
  ChapterExerciseStep({
    required this.chapter,
    required this.exercise,
    required this.step,
    required this.session,
    required this.completed,
  });

  // Factory method to parse a string and create an instance
  factory ChapterExerciseStep.fromString(String input) {
    final parts = input.split('/');
    if (parts.length == 4) {
      return ChapterExerciseStep(
        chapter: parts[0],
        exercise: parts[1],
        // If step ends with "Final" then rewrite to "1" so that exercises can be completed multiple times
        step: parts[2].endsWith("Final")
            ? parts[2].replaceFirst(RegExp(r'Final$'), '1')
            : parts[2],
        session: parts[3],
        completed: parts[2].endsWith("Final") ? true : false,
      );
    }
    // If data is entered in incorrect format
    throw FormatException(
        "Input string must be in the format 'chapter/exercise/step/session'");
  }
}