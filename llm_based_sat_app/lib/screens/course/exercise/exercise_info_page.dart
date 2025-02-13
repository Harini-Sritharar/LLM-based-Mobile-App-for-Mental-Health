import 'package:flutter/material.dart';
import 'package:llm_based_sat_app/models/chapter_exercise_step_interface.dart';
import 'package:llm_based_sat_app/models/firebase-exercise-uploader/interface/chapter_interface.dart';
import 'package:llm_based_sat_app/screens/course/exercise/assessment_page.dart';
import 'package:llm_based_sat_app/screens/auth/sign_in_page.dart';
import 'package:llm_based_sat_app/screens/course/exercise/exercise_page.dart';
import 'package:llm_based_sat_app/theme/app_colours.dart';
import 'package:llm_based_sat_app/utils/exercise_timer_manager.dart';
import 'package:llm_based_sat_app/widgets/custom_app_bar.dart';
import 'package:llm_based_sat_app/widgets/custom_button.dart';
import 'package:llm_based_sat_app/widgets/exercise_widgets/exercise_timer.dart';
import 'package:llm_based_sat_app/widgets/exercise_widgets/learning_tile.dart';
import 'package:llm_based_sat_app/widgets/exercise_widgets/checkbox_tile.dart';
import '../../../data/cache_manager.dart';
import '../../../firebase/firebase_helpers.dart';
import '../../../models/firebase-exercise-uploader/interface/course_interface.dart';
import '../../../models/firebase-exercise-uploader/interface/exercise_interface.dart';
import '../../../utils/exercise_helper_functions.dart';

class ExerciseInfoPage extends StatefulWidget {
  final Course course;
  final Exercise exercise;
  final Chapter chapter;
  final Function(int) onItemTapped; // Function to update navbar index
  final int selectedIndex; // Current selected index
  final int exerciseSession;

  const ExerciseInfoPage({
    Key? key,
    required this.course,
    required this.exercise,
    required this.chapter,
    required this.onItemTapped,
    required this.selectedIndex,
    required this.exerciseSession,
  }) : super(key: key);

  @override
  _ExerciseInfoPageState createState() => _ExerciseInfoPageState();
}

class _ExerciseInfoPageState extends State<ExerciseInfoPage> {
  @override
  void dispose() {
    // Removes current step from cache so user must reset exercise
    CacheManager.removeValue(widget.exercise.id);
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
          title: widget.course.title,
          onItemTapped: widget.onItemTapped,
          selectedIndex: widget.selectedIndex),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Exercise ${widget.exercise.id.substring(widget.exercise.id.length - 1)}",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: AppColours.brandBluePlusThree),
            ),
            const SizedBox(height: 10),
            const Text(
              'Complete the preparation and learn more about the exercise before you can start practising.',
              style: TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 16),
            const Text(
              'Preparation',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF293138)),
            ),
            const SizedBox(height: 8),
            Column(
              children: const [
                CheckboxTile(
                  title:
                      'Go to a quiet place. If not possible, wear headphones.',
                  icon: Icons.headphones,
                ),
                CheckboxTile(
                  title:
                      'Set your childhood photo as the background on your phone.',
                  icon: Icons.photo,
                ),
                CheckboxTile(
                  title:
                      'Plan a visit to a natural area (park, river, mountain, sea..).',
                  icon: Icons.calendar_today,
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Learning',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF293138)),
            ),
            const SizedBox(height: 8),
            Column(
              children: [
                LearningTile(
                  title: 'Aim',
                  icon: Icons.lightbulb,
                  subject: 'Aim',
                  content: widget.exercise.objective,
                ),
                LearningTile(
                  title: 'Theory',
                  icon: Icons.article,
                  subject: 'Theory',
                  content: getLearning(),
                ),
                // TODO
                // Check if we can remove this LearningTile since can't find step headings anywhere
                LearningTile(
                  title: 'Steps',
                  icon: Icons.list,
                  subject: 'Steps',
                  content: getSteps(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Minimum practice time:',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF293138)),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Color(0xFFCEDFF2),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Color(0xFF123659)),
                      ),
                      child: Text(
                        widget.exercise.minimumPracticeTime,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF062240)),
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Exercise session:',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF293138)),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                          color: Color(0xFFCEDFF2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Color(0xFF123659))),
                      child: Text(
                        // TODO
                        // What value to put here
                        (widget.exerciseSession + 1).toString(),
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF062240)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: CustomButton(
                buttonText: 'Start Exercise',
                onPress: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => getExerciseStep(),
                    ),
                  );
                },
                rightArrowPresent: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /* Function to combine required and optional learning into one String */
  getLearning() {
    String learning = "";
    String currentLetter = 'a';
    for (final pointer in widget.exercise.requiredLearning) {
      learning = "$learning ($currentLetter) $pointer\n\n";
      currentLetter = incrementLetter(currentLetter);
    }
    for (final pointer in widget.exercise.optionalLearning) {
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
  getSteps() {
    String steps = "";
    int count = 1;
    for (final step in widget.exercise.exerciseSteps) {
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

  Widget getExerciseStep() {
    int currentStep = 1;
    if (CacheManager.getValue(widget.exercise.id) == null &&
        CacheManager.getValue(widget.course.id) != null) {
      for (ChapterExerciseStep value
          in CacheManager.getValue(widget.course.id)) {
        if (value.exercise.trim() == widget.exercise.id.trim()) {
          currentStep = extractLastNumber(value.step);
          if (currentStep == -1) {
            currentStep =
                widget.exercise.exerciseSteps.length + 1; // Point to final step
          }
        }
      }
    } else if (CacheManager.getValue(widget.exercise.id) != null) {
      currentStep = CacheManager.getValue(widget.exercise.id);
    }
    CacheManager.setValue(widget.exercise.id, currentStep + 1);

    if (currentStep <= widget.exercise.exerciseSteps.length) {
      final currentExerciseStep = widget.exercise
          .exerciseSteps[currentStep - 1]; // currentStep - 1 since 0 indexed
      final header = "Exercise ${getExerciseLetter(currentExerciseStep.id)}";

      return ExercisePage(
        heading: header,
        step: currentExerciseStep.stepTitle,
        description: currentExerciseStep.description,
        imageUrl: currentExerciseStep.imageUrl,
        buttonText: "Next Step",
        onButtonPress: (BuildContext context) async {
          if (currentStep <= widget.exercise.exerciseSteps.length) {
            // Save the next step in cache
            // await _saveCurrentStep(currentStep + 1);
            // Navigate to the next step
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => getExerciseStep(),
              ),
            );
          } else {
            // Reset the cache when exercise is completed
            CacheManager.removeValue(widget.exercise.id);
            Navigator.pop(context); // Exit the exercise
          }
        },
        rightArrowPresent: true,
        messageText: currentExerciseStep.footerText,
        exercise: widget.exercise,
      );
    } else {
      // Final Step - Show Assessment Page
      CacheManager.removeValue(widget.exercise.id); // Reset cache
      String completedExercise =
          "${widget.chapter.id}/${widget.exercise.id}/${widget.exercise.exerciseFinalStep!.id}/${getSessions(widget.exercise, widget.course) + 1}";
      String previousSession =
          "${widget.chapter.id}/${widget.exercise.id}/${widget.exercise.exerciseFinalStep!.id}/${getSessions(widget.exercise, widget.course)}";
      updateUserCourseProgress(
          user!.uid,
          widget.course.id.trim(),
          completedExercise,
          previousSession); // Update firebase to indicate current exercise completed
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
              chapter: widget.chapter,
              exercise: widget.exercise,
              elapsedTime: elapsedTime,
              course: widget.course,
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
}
