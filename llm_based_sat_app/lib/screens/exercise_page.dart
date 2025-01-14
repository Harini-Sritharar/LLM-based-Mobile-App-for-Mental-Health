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
  final VoidCallback onButtonPress;
  final bool rightArrowPresent;

  const ExercisePage({
    super.key,
    required this.heading,
    required this.step,
    required this.description,
    required this.imageUrl,
    required this.buttonText,
    required this.onButtonPress, 
    required this.rightArrowPresent,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ExerciseAppBar(title: heading),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ExerciseStepLabel(step: step),
            const SizedBox(height: 16),
            ExerciseDescription(description: description),
            const SizedBox(height: 16),
            ExerciseImage(imageUrl: imageUrl),
            const SizedBox(height: 16),
            Center(
              child: CustomButton(
                buttonText: buttonText,
                onPress: onButtonPress, 
                rightArrowPresent: rightArrowPresent,
              ),
            ),
            const SizedBox(height: 16),
            const ExerciseBottomMessage(),
            const Spacer(),
            const Center(
              child: ExerciseTimer(),
            ),
          ],
        ),
      ),
    );
  }
}
