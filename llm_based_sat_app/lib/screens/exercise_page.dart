import 'package:flutter/material.dart';
import 'package:llm_based_sat_app/widgets/exercise_widgets/exercise_appBar.dart';
import '../widgets/exercise_widgets/exercise_bottom_message.dart';
import '../widgets/custom_button.dart';
import '../widgets/exercise_widgets/exercise_description.dart';
import '../widgets/exercise_widgets/exercise_image.dart';
import '../widgets/exercise_widgets/exercise_step_label.dart';
import '../widgets/exercise_widgets/exercise_timer.dart';

class ExercisePage extends StatelessWidget {
  final String heading;
  final String step;
  final String description;
  final String imageUrl;
  final String buttonText;
  final void Function(BuildContext) onButtonPress;
  final bool rightArrowPresent;
  final String messageText;

  const ExercisePage({
    super.key,
    required this.heading,
    required this.step,
    required this.description,
    required this.imageUrl,
    required this.buttonText,
    required this.onButtonPress,
    required this.rightArrowPresent,
    required this.messageText,
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
                ExerciseImage(imageUrl: imageUrl),
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
                ExerciseBottomMessage(messageText: messageText),
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
              color: Color(0xFF8F959B),
            ),
          ),

          // Timer
          const Positioned(
            bottom: 16.0,
            left: 0,
            right: 0,
            child: Center(
              child: ExerciseTimer(),
            ),
          ),
        ],
      ),
    );
  }
}
