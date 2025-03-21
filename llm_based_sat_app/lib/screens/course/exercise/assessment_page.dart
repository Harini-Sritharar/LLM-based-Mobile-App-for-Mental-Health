import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:llm_based_sat_app/data/cache_manager.dart';
import 'package:llm_based_sat_app/firebase/firebase_courses.dart';
import 'package:llm_based_sat_app/main.dart';
import 'package:llm_based_sat_app/theme/app_colours.dart';
import 'package:llm_based_sat_app/utils/user_provider.dart';
import 'package:llm_based_sat_app/widgets/custom_button.dart';
import 'package:llm_based_sat_app/widgets/exercise_widgets/exercise_appBar.dart';
import 'package:llm_based_sat_app/widgets/exercise_widgets/exercise_description.dart';
import 'package:llm_based_sat_app/widgets/exercise_widgets/exercise_sliderQuestion.dart';
import 'package:llm_based_sat_app/widgets/exercise_widgets/exercise_step_label.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../models/firebase-exercise-uploader/interface/chapter_interface.dart';
import '../../../models/firebase-exercise-uploader/interface/course_interface.dart';
import '../../../models/firebase-exercise-uploader/interface/exercise_interface.dart';
import '../../../utils/exercise_helper_functions.dart';

/* The `AssessmentPage` is a widget that displays the final assessment and reflection section after completing an exercise. It provides information about the session, allows the user to rate the exercise, and offers an option to navigate back to the courses page.

## Parameters:
- `exercise`: An instance of the `Exercise` model, which contains information about the exercise, including the final step details (`exerciseFinalStep`).
- `elapsedTime`: A string representation of the time spent on the exercise eg., "Elapsed Time: 5 minutes 20 seconds").
 
## Notes:
- Ensure that the `Exercise` object passed to the page contains the `exerciseFinalStep` property, as it is used to generate the title and description.
- The `elapsedTime` parameter should be a pre-formatted string that clearly represents the total time spent. */
class AssessmentPage extends StatefulWidget {
  final Course course;
  final Chapter chapter;
  final Exercise exercise;
  final String elapsedTime;

  const AssessmentPage(
      {super.key,
      required this.exercise,
      required this.elapsedTime,
      required this.chapter,
      required this.course});

  @override
  _AssessmentPageState createState() => _AssessmentPageState();
}

class _AssessmentPageState extends State<AssessmentPage> {
  // Slider values
  double feelingBetterValue = 3;
  double helpfulnessValue = 3;
  double ratingValue = 3;
  final TextEditingController _commentController = TextEditingController();
  late UserProvider userProvider;
  late String uid;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Access Provider here
    userProvider = Provider.of<UserProvider>(context);
    uid = userProvider.getUid();
    // Now that uid is available, load the name and connect WebSocket
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ExerciseAppBar(
        title:
            "Exercise ${getExerciseLetter(widget.exercise.exerciseFinalStep!.id)}",
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ExerciseStepLabel(step: 'Congratulations'),
            SizedBox(height: 8),
            ExerciseDescription(
                description:
                    'You successfully completed Exercise ${getExerciseLetter(widget.exercise.exerciseFinalStep!.id)}. You can now move on to the next exercise or back to the course page.'),
            SizedBox(height: 20),
            _buildSectionTitle('Session Info'),
            SizedBox(height: 8),
            ExerciseDescription(
                description:
                    'Sessions: ${getSessions(widget.exercise, widget.course) + 1} completed out of ${widget.chapter.exercises.length}'),
            SizedBox(height: 8),
            ExerciseDescription(description: widget.elapsedTime),
            SizedBox(height: 20),
            _buildSectionTitle('Comments'),
            SizedBox(height: 8),
            _buildCommentBox(),
            SizedBox(height: 20),
            _buildSectionTitle('Assessment'),
            SizedBox(height: 8),
            _buildRatingsSection(),
            SizedBox(height: 30),
            CustomButton(
              buttonText: 'Back to Course',
              onPress: () {
                uploadTimeStampCommentAndRating();
                String exName =
                    "${widget.course.id}_${getExerciseLetter(widget.exercise.exerciseFinalStep!.id)}";
                updateTaskCompletion(exName, true);
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MainScreen(
                              initialIndex: 4,
                            )),
                    (route) => false);
              },
              backgroundColor: AppColours.brandBlueMinusFour,
              textColor: AppColours.brandBlueMain,
            ),
          ],
        ),
      ),
    );
  }

  // Builds a section title widget with bold styling.
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  // Creates a comment box where users can provide optional feedback.
  Widget _buildCommentBox() {
    return AnimatedOpacity(
      opacity: 1.0,
      duration: Duration(milliseconds: 300),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Leave a comment (optional):",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColours.brandBlueMain,
            ),
          ),
          SizedBox(height: 8),
          TextField(
            controller: _commentController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: "Share your experience...",
              fillColor: AppColours.brandBlueMinusFour,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Retrieves the exercise number based on its position in the chapter's exercise list.
  getExerciseNumber() {
    int index = 1;
    for (final exercise in widget.chapter.exercises) {
      if (widget.exercise.id == exercise.id) {
        return index;
      }
      index++;
    }
    return index;
  }

  // Builds the ratings section with three slider questions.
  Widget _buildRatingsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ExerciseSliderQuestionWidget(
          question:
              '(A) Are you feeling better than before practising the exercise?',
          initialValue: feelingBetterValue,
          onChanged: (value) {
            setState(() {
              feelingBetterValue = value;
            });
          },
        ),
        ExerciseSliderQuestionWidget(
          question: '(B) How helpful was this exercise?',
          initialValue: helpfulnessValue,
          onChanged: (value) {
            setState(() {
              helpfulnessValue = value;
            });
          },
        ),
        ExerciseSliderQuestionWidget(
          question: '(C) Rate this exercise.',
          initialValue: ratingValue,
          onChanged: (value) {
            setState(() {
              ratingValue = value;
            });
          },
        ),
      ],
    );
  }

  // Add TimeStamp entry, comment and ratings for given exercise and session
  void uploadTimeStampCommentAndRating() {
    updateTimeStampCommentAndRating(
      uid,
      widget.course.id.trim(),
      widget.exercise.id.trim(),
      (getSessions(widget.exercise, widget.course) + 1).toString(),
      CacheManager.getValue(
          "${widget.exercise.id}/${getSessions(widget.exercise, widget.course) + 1}/TimeStamp"),
      Timestamp.now(),
      _commentController.text,
      feelingBetterValue,
      helpfulnessValue,
      ratingValue,
    );

    // Remove cached TimeStamp for current exercise and session
    CacheManager.removeValue(
        "${widget.exercise.id}/${getSessions(widget.exercise, widget.course) + 1}/TimeStamp");
  }
}

/// Updates the completion status of a task.
Future<void> updateTaskCompletion(String task, bool completed) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? storedTasks = prefs.getString('tasks');
  if (storedTasks != null) {
    List<dynamic> tasksJson = json.decode(storedTasks);
    List<Map<String, dynamic>> tasks =
        tasksJson.map((task) => Map<String, dynamic>.from(task)).toList();
    for (var t in tasks) {
      if (t["task"] == task) {
        t["completed"] = completed;
        break;
      }
    }
    await prefs.setString('tasks', json.encode(tasks));
  }
}
