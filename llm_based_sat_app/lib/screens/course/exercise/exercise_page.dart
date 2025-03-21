import 'package:flutter/material.dart';
import 'package:llm_based_sat_app/models/firebase-exercise-uploader/interface/course_interface.dart';
import 'package:llm_based_sat_app/theme/app_colours.dart';
import 'package:llm_based_sat_app/widgets/exercise_widgets/exercise_appBar.dart';
import '../../../models/firebase-exercise-uploader/interface/exercise_interface.dart';
import '../../../widgets/exercise_widgets/exercise_bottom_message.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/exercise_widgets/exercise_description.dart';
import '../../../widgets/exercise_widgets/exercise_image.dart';
import '../../../widgets/exercise_widgets/exercise_step_label.dart';
import '../../../widgets/exercise_widgets/exercise_timer.dart';

/* This file defines the `ExercisePage` widget, a stateless page that displays details about a specific exercise and allows users to interact with it. The pageincludes features such as an exercise description, step label, image, timer, and custom button functionality. 

Parameters:
- `heading` (String): The title of the exercise displayed in the app bar.
- `step` (String): The current step or label for the exercise workflow.
- `description` (String): A detailed description of the exercise.
- `imageType` (String): Type for the exercise image to be displayed on the page. ("Happy" or "Sad")
- `buttonText` (String): Text displayed on the custom action button.
- `onButtonPress` (void Function(BuildContext)): Callback function triggered when the custom button is pressed. It takes the current `BuildContext` as input.
- `rightArrowPresent` (bool): Indicates whether a right arrow should appear on the custom button.
- `messageText` (String): A bottom message text providing additional exercise info.
- `exercise` (Exercise): The `Exercise` model containing exercise-specific details, such as duration, progress, and metadata. */

class ExercisePage extends StatelessWidget {
  final String userUID;
  final Course course;
  final String heading;
  final String step;
  final String description;
  final String imageType;
  final String buttonText;
  final void Function(BuildContext) onButtonPress;
  final bool rightArrowPresent;
  final String messageText;
  final Exercise exercise;

  const ExercisePage({
    super.key,
    required this.userUID,
    required this.course,
    required this.heading,
    required this.step,
    required this.description,
    required this.imageType,
    required this.buttonText,
    required this.onButtonPress,
    required this.rightArrowPresent,
    required this.messageText,
    required this.exercise,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ExerciseAppBar(title: heading),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ExerciseStepLabel(step: step),
                const SizedBox(height: 32),
                ExerciseDescription(description: description),
                const SizedBox(height: 40),
                ExerciseImage(imageType: imageType),
                const SizedBox(height: 40),
                Center(
                  child: CustomButton(
                    buttonText: buttonText,
                    onPress: () {
                      // Wrap the onButtonPress function call with the context
                      onButtonPress(context); // context is provided here
                    },
                    rightArrowPresent: rightArrowPresent,
                  ),
                ),
                const SizedBox(height: 32),
                ExerciseBottomMessage(
                    messageText: messageText,
                    userUID: userUID,
                    exercise: exercise,
                    course: course,
                    step: step)
              ],
            ),
          ),

          // Grey Line
          const Positioned(
            bottom: 85.0,
            left: 0,
            right: 0,
            child: Divider(
              thickness: 0.5,
              color: AppColours.neutralGreyMinusFour,
            ),
          ),

          // Timer
          Positioned(
            bottom: 16.0,
            left: 0,
            right: 0,
            child: Center(
              child: ExerciseTimer(
                exercise: exercise,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
