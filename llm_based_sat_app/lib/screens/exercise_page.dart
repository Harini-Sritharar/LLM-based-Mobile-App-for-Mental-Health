import 'package:flutter/material.dart';
import 'package:llm_based_sat_app/widgets/exercise_widgets/exercise_appBar.dart';
import '../widgets/exercise_widgets/exercise_bottom_message.dart';
import '../widgets/exercise_widgets/exercise_button.dart';
import '../widgets/exercise_widgets/exercise_description.dart';
import '../widgets/exercise_widgets/exercise_image.dart';
import '../widgets/exercise_widgets/exercise_step_label.dart';
import '../widgets/exercise_widgets/exercise_timer.dart';

class ExercisePage extends StatelessWidget {
  final String heading;
  final int stepNumber;
  final String description;
  final String imageUrl;
  final String buttonText;
  final VoidCallback onButtonPress;

  const ExercisePage({
    super.key,
    required this.heading,
    required this.stepNumber,
    required this.description,
    required this.imageUrl,
    required this.buttonText,
    required this.onButtonPress,
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
            ExerciseStepLabel(stepNumber: stepNumber),
            const SizedBox(height: 16),
            ExerciseDescription(description: description),
            const SizedBox(height: 16),
            ExerciseImage(imageUrl: imageUrl),
            const SizedBox(height: 16),
            Center(
              child: ExerciseButton(
                buttonText: buttonText,
                onPress: onButtonPress,
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
