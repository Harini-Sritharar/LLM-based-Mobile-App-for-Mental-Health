import 'package:flutter/material.dart';
import 'package:llm_based_sat_app/theme/app_colours.dart';
import 'package:llm_based_sat_app/utils/exercise_page_caller.dart';
import 'package:llm_based_sat_app/widgets/custom_app_bar.dart';
import 'package:llm_based_sat_app/widgets/custom_button.dart';
import 'package:llm_based_sat_app/widgets/exercise_widgets/learning_tile.dart';
import 'package:llm_based_sat_app/widgets/exercise_widgets/checkbox_tile.dart';

import '../../../models/firebase-exercise-uploader/interface/exercise_interface.dart';

class ExerciseInfoPage extends StatelessWidget {
  final Exercise exercise;
  final Function(int) onItemTapped; // Function to update navbar index
  final int selectedIndex; // Current selected index

  const ExerciseInfoPage(
      {Key? key,
      required this.exercise,
      required this.onItemTapped,
      required this.selectedIndex});

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
          title: 'Self-attachment',
          onItemTapped: onItemTapped,
          selectedIndex: selectedIndex),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Exercise ${exercise.id.substring(exercise.id.length - 1)}",
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
                  content: exercise.objective,
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
                        exercise.minimumPracticeTime,
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
                      child: const Text(
                        // TODO
                        // What value to put here
                        '3',
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
                      builder: (context) => const ExercisePageCaller(id: "A_2"),
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
  getSteps() {
    String steps = "";
    int count = 1;
    for (final step in exercise.exerciseSteps) {
      steps = "$steps ($count) ${step.stepTitle}\n\n";
      count++;
    }
    return steps;
  }
}
