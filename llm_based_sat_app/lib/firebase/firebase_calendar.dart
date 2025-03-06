import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:llm_based_sat_app/models/calendar/calendar_exercise_entry.dart';

/* Retrieves exercises logged by a user for a specific date.

Parameters:
  - [uid]: The unique user ID.
  - [date]: The date for which exercises need to be fetched.

Returns:
  - A `Future` list of `CalendarExerciseEntry` containing exercise details. */
Future<List<CalendarExerciseEntry>> getExercisesByDate(
    String uid, DateTime date) async {
  try {
    final collection = FirebaseFirestore.instance
        .collection('Profile')
        .doc(uid)
        .collection('course_progress');

    // Get all course progress documents
    final progressSnapshots = await collection.get();

    List<CalendarExerciseEntry> exercises = [];

    for (var courseDoc in progressSnapshots.docs) {
      String courseId = courseDoc.id;
      print("courseId: $courseId");

      final timestampsCollection =
          collection.doc(courseId).collection('TimeStamps');
      final timestampsSnapshot = await timestampsCollection.get();

      for (var timestampDoc in timestampsSnapshot.docs) {
        Map<String, dynamic> data = timestampDoc.data();
        Timestamp endTimestamp = data['endTime'];
        Timestamp startTimestamp = data['startTime'];
        String comment = data['comment'] ?? "";
        DateTime exerciseDate = endTimestamp.toDate();

        if (_isSameDay(exerciseDate, date)) {
          // Extract exercise ID and session number from doc ID
          List<String> parts = timestampDoc.id.split('\\');
          if (parts.length != 2) continue;

          String exerciseId = parts[0];

          exercises.add(CalendarExerciseEntry(
            courseName: courseId,
            exerciseName:
                "Exercise ${exerciseId.substring(exerciseId.length - 1)}",
            duration: formatDuration(startTimestamp, endTimestamp),
            notes: comment,
            date: exerciseDate,
          ));
        }
      }
    }

    return exercises;
  } catch (e) {
    print('Error retrieving exercises: $e');
    return [];
  }
}

// Helper function to compare two dates (ignoring time)
bool _isSameDay(DateTime date1, DateTime date2) {
  return date1.year == date2.year &&
      date1.month == date2.month &&
      date1.day == date2.day;
}

/* Formats the duration between start and end timestamps into a human-readable string.

Parameters:
  - [start]: Start timestamp of the exercise.
  - [end]: End timestamp of the exercise.

Returns:
  - A string representing the duration in hours, minutes, and seconds. */
String formatDuration(Timestamp start, Timestamp end) {
  Duration diff = end.toDate().difference(start.toDate());

  int hours = diff.inHours;
  int minutes = diff.inMinutes % 60;
  int seconds = diff.inSeconds % 60;

  List<String> parts = [];

  if (hours > 0) parts.add("$hours hour${hours > 1 ? 's' : ''}");
  if (minutes > 0) parts.add("$minutes minute${minutes > 1 ? 's' : ''}");
  if (seconds > 0 || parts.isEmpty) {
    parts.add("$seconds second${seconds > 1 ? 's' : ''}");
  }

  return parts.join(" ");
}
