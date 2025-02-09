/* This class is used to help with better managing the input from user progress 
for a given course. It parses the input string, in the format 
"chapter/exercise/step", into structured data with properties that can 
be accessed using dot notation for easier manipulation and readability. */

class ChapterExerciseStep {
  final String chapter;
  final String exercise;
  final String step;

  // Constructor
  ChapterExerciseStep({
    required this.chapter,
    required this.exercise,
    required this.step,
  });

  // Factory method to parse a string and create an instance
  factory ChapterExerciseStep.fromString(String input) {
    final parts = input.split('/');
    if (parts.length != 3) {
      throw FormatException(
          "Input string must be in the format 'chapter/exercise/step'");
    }

    return ChapterExerciseStep(
      chapter: parts[0],
      exercise: parts[1],
      step: parts[2],
    );
  }
}
