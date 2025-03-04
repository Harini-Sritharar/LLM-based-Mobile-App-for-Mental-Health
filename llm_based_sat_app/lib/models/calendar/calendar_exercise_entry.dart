/// Represents an exercise entry in the calendar, storing details about the exercise.
class CalendarExerciseEntry {
  final String exerciseName; // The name of the exercise.
  final String courseName; // The associated course name.
  final String duration; // Duration of the exercise (e.g., "30 mins").
  final String notes; // Additional notes related to the exercise.
  final DateTime date; // The date when the exercise was performed.

  /// Constructor to initialize all required parameters for an exercise entry.
  CalendarExerciseEntry({
    required this.exerciseName,
    required this.courseName,
    required this.duration,
    required this.notes,
    required this.date,
  });
}
