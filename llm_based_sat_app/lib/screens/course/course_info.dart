import 'package:flutter/material.dart';
import 'package:llm_based_sat_app/data/cache_manager.dart';
import 'package:llm_based_sat_app/models/chapter_exercise_interface.dart';
import 'package:llm_based_sat_app/models/chapter_exercise_step_interface.dart';
import 'package:llm_based_sat_app/models/chapter_interface.dart';
import 'package:llm_based_sat_app/models/firebase-exercise-uploader/interface/chapter_interface.dart';
import 'package:llm_based_sat_app/models/firebase-exercise-uploader/interface/exercise_interface.dart';
import 'package:llm_based_sat_app/screens/course/course_page.dart';
import 'package:llm_based_sat_app/widgets/course_widgets/course_exercise_duration.dart';
import 'package:llm_based_sat_app/widgets/course_widgets/course_type_rating.dart';
import 'package:llm_based_sat_app/widgets/course_widgets/pre_course_list.dart';
import 'package:llm_based_sat_app/widgets/custom_app_bar.dart';
import 'package:llm_based_sat_app/widgets/expandable_text.dart';
import 'package:llm_based_sat_app/screens/course/exercise/exercise_info_page.dart';

import '../../models/firebase-exercise-uploader/interface/course_interface.dart';
import '../../utils/exercise_helper_functions.dart';
import '../../widgets/firebase_video_player.dart';

class CourseInfo extends StatefulWidget {
  final Course course;
  final Function(int) onItemTapped;
  final int selectedIndex;

  const CourseInfo({
    super.key,
    required this.course,
    required this.onItemTapped,
    required this.selectedIndex,
  });

  @override
  _CourseInfoState createState() => _CourseInfoState();
}

class _CourseInfoState extends State<CourseInfo> {

  @override
  Widget build(BuildContext context) {
    Future.microtask(() {
    setState(() {}); // Triggers UI refresh after returning
  });
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
          title: "Courses",
          onItemTapped: widget.onItemTapped,
          selectedIndex: widget.selectedIndex),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CourseTypeRating(
                courseType: widget.course.courseType, rating: widget.course.rating),
            const SizedBox(height: 10),
            Text(
              widget.course.title,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 14),
            CourseExerciseDuration(
                exercises: getNumberOfExercises(), duration: widget.course.duration),
            const SizedBox(height: 20),
            ExpandableText(
                // Course Aim
                text: widget.course.aim),
            const SizedBox(height: 40),
            PreCourseList(
              // TODO
              // prerequisites: course.prerequisites,
              prerequisites: [],
              onUploadChildhoodPhotosPressed: (BuildContext context) {},
              onWatchIntroductoryVideoPressed: (BuildContext context) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FirebaseVideoPlayer(
                            course: widget.course,
                          )),
                );
                setState(() {}); // Refresh after returning;
              },
              onStartCoursePressed: (BuildContext context) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CoursePage(
                      course: widget.course,
                      courseTitle: widget.course.title,
                      chapters: getChapters(),
                      onItemTapped: widget.onItemTapped,
                      selectedIndex: widget.selectedIndex,
                    ),
                  ),
                );
              },
              watchedIntroductoryVideo: getWatchedIntroductoryVideo(),
              childhoodPhotosUploaded: getChildhoodPhotosUploaded(),
              course: widget.course,
            ),
          ],
        ),
      ),
    );
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

  getChapters() {
    List<ChapterInterface> chapterInterfaces = [];
    for (final chapter in widget.course.chapters) {
      List<ChapterExerciseInterface> chapterExerciseInterfaces = [];
      for (final exercise in chapter.exercises) {
        ChapterExerciseInterface chapterExerciseInterface =
            ChapterExerciseInterface(
          letter: exercise.id.substring(exercise.id.length - 1),
          title: exercise.exerciseTitle,
          practised: getSessions(exercise, widget.course),
          totalSessions: exercise.totalSessions,
          onButtonPress: (BuildContext context) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ExerciseInfoPage(
                      course: widget.course,
                      exercise: exercise,
                      chapter: chapter,
                      onItemTapped: widget.onItemTapped,
                      selectedIndex: widget.selectedIndex,
                      exerciseSession: getSessions(exercise, widget.course))),
            );
          },
        );
        chapterExerciseInterfaces.add(chapterExerciseInterface);
      }

      ChapterInterface chapterInterface = ChapterInterface(
          chapterNumber: extractEndingNumber(chapter.id),
          chapterTitle: chapter.chapterTitle,
          exercises: chapterExerciseInterfaces,
          isLocked: isChapterLocked(chapter));

      chapterInterfaces.add(chapterInterface);
    }

    return chapterInterfaces;
  }

  /* Returns the total number of exercises in a course, formatted as a string. */
  getNumberOfExercises() {
    int count = 0;
    for (final chapter in widget.course.chapters) {
      count += chapter.exercises.length;
    }
    if (count > 1) {
      return "$count Exercises";
    } else {
      return "$count Exercise";
    }
  }

  /* Function to return the number of sessions completed for given exercise */
  getSessionsPracticed(Exercise exercise) {
    if (CacheManager.getValue(widget.course.id) == null) {
      return 0;
    }

    List<ChapterExerciseStep> courseProgress = CacheManager.getValue(widget.course.id);
    for (final progress in courseProgress) {
      if (progress.exercise.trim() == exercise.id.trim()) {
        return int.parse(progress.session);
      }
    }
    return 0;
  }

  /* Function to check if the given chapter is locked or not. Returns true if the previous chapter is completed.
  */
  isChapterLocked(Chapter chapter) {
    // Get index of current chapter
    int current_chapter_index = widget.course.chapters.indexOf(chapter);
    if (current_chapter_index == 0) {
      // First chapter is always unlocked
      return false;
    }
    Chapter previous_chapter = widget.course.chapters[current_chapter_index - 1];
    // Check to see if all exercises completed
    for (final exercise in previous_chapter.exercises) {
      print(
          "Exercise: ${exercise.id}   ${getSessionsPracticed(exercise)}/${exercise.totalSessions}");
      if (getSessionsPracticed(exercise) < exercise.totalSessions) {
        // Exercise is not completed
        return true;
      }
    }
    return false;
  }

  /* Function to check if the user has watched the introductory video by referencing the cache */
  getWatchedIntroductoryVideo() {
    // Check cache to see if video watched
    if (CacheManager.getValue("${widget.course.id}_introductory_video") == null) {
      return false;
    }
    
    // Return cache value
    return CacheManager.getValue("${widget.course.id}_introductory_video");
  }
  
  /* Function to check if the user has uploaded their childhood photos by referencing the cache */
  getChildhoodPhotosUploaded() {
    // TODO
    // Delete below line when implementated
    return true;
    // Check cache to see if video watched
    if (CacheManager.getValue("${widget.course.id}_childhood_photos") == null) {
      return false;
    }
    
    // Return cache value
    return CacheManager.getValue("${widget.course.id}_childhood_photos");
  }
}