import 'package:flutter/material.dart';
import '../../data/cache_manager.dart';
import '../../models/chapter_exercise_interface.dart';
import '../../models/chapter_exercise_step_interface.dart';
import '../../models/chapter_interface.dart';
import '../../models/firebase-exercise-uploader/interface/chapter_interface.dart';
import '../../models/firebase-exercise-uploader/interface/course_interface.dart';
import '../../models/firebase-exercise-uploader/interface/exercise_interface.dart';
import '../../utils/exercise_helper_functions.dart';
import 'exercise/exercise_info_page.dart';

/* This function generates a list of ChapterInterface objects, each representing a course chapter. It maps each chapter and its associated exercises into structured objects for display. For each exercise within a chapter, it creates a ChapterExerciseInterface object, which includes exercise details and a button to navigate to the ExerciseInfoPage. The function ensures that chapters are properly numbered, titled, and locked status is assigned. */
getChapters(Course course, Function(int) onItemTapped, int selectedIndex) {
  List<ChapterInterface> chapterInterfaces = [];
  for (final chapter in course.chapters) {
    List<ChapterExerciseInterface> chapterExerciseInterfaces = [];
    for (final exercise in chapter.exercises) {
      ChapterExerciseInterface chapterExerciseInterface =
          ChapterExerciseInterface(
        letter: exercise.id.substring(exercise.id.length - 1),
        title: exercise.exerciseTitle,
        practised: getSessions(exercise, course),
        totalSessions: exercise.totalSessions,
        onButtonPress: (BuildContext context) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ExerciseInfoPage(
                    course: course,
                    exercise: exercise,
                    chapter: chapter,
                    onItemTapped: onItemTapped,
                    selectedIndex: selectedIndex,
                    exerciseSession: getSessions(exercise, course))),
          );
        },
      );
      chapterExerciseInterfaces.add(chapterExerciseInterface);
    }

    ChapterInterface chapterInterface = ChapterInterface(
        chapterNumber: extractEndingNumber(chapter.id),
        chapterTitle: chapter.chapterTitle,
        exercises: chapterExerciseInterfaces,
        isLocked: isChapterLocked(chapter, course));

    chapterInterfaces.add(chapterInterface);
  }

  return chapterInterfaces;
}

/* Function to check if the given chapter is locked or not. Returns true if the previous chapter is completed.
  */
isChapterLocked(Chapter chapter, Course course) {
  // Get index of current chapter
  int currentChapterIndex = course.chapters.indexOf(chapter);
  if (currentChapterIndex == 0) {
    // First chapter is always unlocked
    return false;
  }
  Chapter previousChapter = course.chapters[currentChapterIndex - 1];
  // Check to see if all exercises completed
  for (final exercise in previousChapter.exercises) {
    if (getSessionsPracticed(exercise, course) < exercise.totalSessions) {
      // Exercise is not completed
      return true;
    }
  }
  return false;
}

/* Function to return the number of sessions completed for given exercise */
getSessionsPracticed(Exercise exercise, Course course) {
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

/* This function takes a string and uses a regular expression to find the first number in the string and returns it as an integer */
int extractEndingNumber(String input) {
  RegExp regExp = RegExp(r'\d+');
  Match? match = regExp.firstMatch(input);

  if (match != null) {
    // Convert the matched substring to an integer
    return int.parse(match.group(0)!);
  } else {
    return 0; // Default value
  }
}

/* Function to check if the user has watched the introductory video by referencing the cache */
getWatchedIntroductoryVideo(Course course) {
  // Check cache to see if video watched
  if (CacheManager.getValue("${course.id}_introductory_video") == null) {
    return false;
  }

  // Return cache value
  return CacheManager.getValue("${course.id}_introductory_video");
}

/* Function to check if the user has uploaded their childhood photos by referencing the cache */
getChildhoodPhotosUploaded(Course course) {
  // Check cache to see if video watched
  if (CacheManager.getValue("childhood_photos") == null) {
    return false;
  }

  // Return cache value
  return CacheManager.getValue("childhood_photos");
}

/* Returns the total number of exercises in a course, formatted as a string. */
getNumberOfExercises(Course course) {
  int count = 0;
  for (final chapter in course.chapters) {
    count += chapter.exercises.length;
  }
  if (count > 1) {
    return "$count Exercises";
  } else {
    return "$count Exercise";
  }
}
