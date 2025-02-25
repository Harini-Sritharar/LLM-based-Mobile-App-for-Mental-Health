import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:llm_based_sat_app/data/cache_manager.dart';
import 'package:llm_based_sat_app/firebase/firebase_courses.dart';
import 'package:llm_based_sat_app/models/chapter_exercise_step_interface.dart';
import 'package:llm_based_sat_app/models/firebase-exercise-uploader/interface/chapter_interface.dart';
import 'package:llm_based_sat_app/models/firebase-exercise-uploader/interface/course_interface.dart';
import 'package:llm_based_sat_app/models/firebase-exercise-uploader/interface/exercise_interface.dart';
import 'package:llm_based_sat_app/screens/auth/sign_in_page.dart';
import 'package:llm_based_sat_app/screens/course/exercise/assessment_page.dart';
import 'package:llm_based_sat_app/screens/course/exercise/exercise_page.dart';
import 'package:llm_based_sat_app/utils/exercise_helper_functions.dart';
import 'package:llm_based_sat_app/utils/exercise_timer_manager.dart';
import 'package:llm_based_sat_app/utils/user_provider.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

/* Function to combine required and optional learning into one String */
getLearning(Exercise exercise) {
  String learning = "";
  String currentLetter = 'a';
  for (final pointer in exercise.requiredLearning) {
    learning = "$learning ($currentLetter) $pointer\n\n";
    currentLetter = incrementLetter(currentLetter);
  }
  for (final pointer in exercise.optionalLearning) {
    learning = "$learning ($currentLetter) $pointer\n\n";
    currentLetter = incrementLetter(currentLetter);
  }

  return learning;
}

/* Function to increment given letter by 1 */
String incrementLetter(String letter) {
  // Ensure the letter is a single character
  if (letter.length == 1) {
    // Get the Unicode code of the letter
    int code = letter.codeUnitAt(0);

    // Check if it's a lowercase letter between 'a' and 'z'
    if (code >= 97 && code <= 122) {
      // Increment the code to the next letter
      code++;

      // Convert back to a character and return
      return String.fromCharCode(code);
    }
    // If it's not a valid lowercase letter
    return letter;
  }
  return ''; // Return empty if input is invalid
}

/* Function to combine all exercise steps into one String */
getSteps(Exercise exercise) {
  String steps = "";
  int count = 1;
  for (final step in exercise.exerciseSteps) {
    steps = "$steps ($count) ${step.stepTitle}\n\n";
    count++;
  }
  return steps;
}

/* Extracts the last number from a string in the format "Attachment_1_A_212".
  If the string ends with a non-numeric value (e.g., "Attachment_1_A_Final"),
  it returns -1. */
int extractLastNumber(String input) {
  // Match the last part of the string after the last underscore
  final match = RegExp(r'(\d+)$').firstMatch(input);

  // If a match is found, return the number; otherwise, return -1
  if (match != null) {
    return int.parse(match.group(0)!);
  } else {
    return -1; // Return -1 if no number is found
  }
}

Widget getExerciseStep(
    Exercise exercise, Course course, Chapter chapter, BuildContext context) {
  int currentStep = 1;
  if (CacheManager.getValue(exercise.id) == null &&
      CacheManager.getValue(course.id) != null) {
    for (ChapterExerciseStep value in CacheManager.getValue(course.id)) {
      if (value.exercise.trim() == exercise.id.trim()) {
        currentStep = extractLastNumber(value.step);
        if (currentStep == -1) {
          currentStep =
              exercise.exerciseSteps.length + 1; // Point to final step
        }
      }
    }
  } else if (CacheManager.getValue(exercise.id) != null) {
    currentStep = CacheManager.getValue(exercise.id);
  }
  CacheManager.setValue(exercise.id, currentStep + 1);

  if (currentStep == 1) {
    CacheManager.setValue(
        "${exercise.id}/${getSessions(exercise, course) + 1}/TimeStamp",
        Timestamp.now());
  }

  if (currentStep <= exercise.exerciseSteps.length) {
    final currentExerciseStep = exercise
        .exerciseSteps[currentStep - 1]; // currentStep - 1 since 0 indexed
    final header = "Exercise ${getExerciseLetter(currentExerciseStep.id)}";

    return ExercisePage(
      heading: header,
      step: currentExerciseStep.stepTitle,
      description: currentExerciseStep.description,
      imageUrl: currentExerciseStep.imageUrl,
      buttonText: "Next Step",
      onButtonPress: (BuildContext context) async {
        if (currentStep <= exercise.exerciseSteps.length) {
          // Save the next step in cache
          // await _saveCurrentStep(currentStep + 1);
          // Navigate to the next step
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => getExerciseStep(exercise, course, chapter, context),
            ),
          );
        } else {
          // Reset the cache when exercise is completed
          CacheManager.removeValue(exercise.id);
          Navigator.pop(context); // Exit the exercise
        }
      },
      rightArrowPresent: true,
      messageText: currentExerciseStep.footerText,
      exercise: exercise,
    );
  } else {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    String uid = userProvider.getUid();
    // Final Step - Show Assessment Page
    CacheManager.removeValue(exercise.id); // Reset cache
    String completedExercise =
        "${chapter.id}/${exercise.id}/${exercise.exerciseFinalStep!.id}/${getSessions(exercise, course) + 1}";
    String previousSession =
        "${chapter.id}/${exercise.id}/${exercise.exerciseFinalStep!.id}/${getSessions(exercise, course)}";

    // Update firebase to indicate current exercise completed
    updateUserCourseProgress(
        uid, course.id.trim(), completedExercise, previousSession);

    // Add TimeStamp entry for given exercise and session
    updateTimeStamp(
        uid,
        course.id.trim(),
        exercise.id.trim(),
        (getSessions(exercise, course) + 1).toString(),
        CacheManager.getValue(
            "${exercise.id}/${getSessions(exercise, course) + 1}/TimeStamp"),
        Timestamp.now());

    // Remove cached TimeStamp for current exercise and session
    CacheManager.removeValue(
        "${exercise.id}/${getSessions(exercise, course) + 1}/TimeStamp");

    return FutureBuilder<String>(
      future: getElapsedTime(), // Fetch elapsed time
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else {
          final elapsedTime = snapshot.data ?? "Elapsed time unavailable";
          return AssessmentPage(
            chapter: chapter,
            exercise: exercise,
            elapsedTime: elapsedTime,
            course: course,
          );
        }
      },
    );
  }
}

// Returns elapsed time for given exercise then calls function to delete cached time.
Future<String> getElapsedTime() async {
  String elapsedTime = ExerciseTimerManager().getElapsedTimeFormatted();

  // Reset the timer
  ExerciseTimerManager().stopTimer();
  ExerciseTimerManager().resetTimer();

  return elapsedTime;
}

void showDialogBox(BuildContext context, String title, String content) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF062240),
          ),
        ),
        content: Text(
          content,
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xFF293138),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              'Close',
              style: TextStyle(color: Color(0xFF123659)),
            ),
          ),
        ],
      );
    },
  );
}
