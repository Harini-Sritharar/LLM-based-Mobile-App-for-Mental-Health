import 'package:flutter/material.dart';
import 'package:llm_based_sat_app/main.dart';
import 'package:llm_based_sat_app/theme/app_colours.dart';
import 'package:llm_based_sat_app/widgets/custom_button.dart';
import 'package:llm_based_sat_app/widgets/exercise_widgets/exercise_reflectionBox.dart';
import 'package:llm_based_sat_app/widgets/exercise_widgets/exercise_appBar.dart';
import 'package:llm_based_sat_app/widgets/exercise_widgets/exercise_description.dart';
import 'package:llm_based_sat_app/widgets/exercise_widgets/exercise_sliderQuestion.dart';
import 'package:llm_based_sat_app/widgets/exercise_widgets/exercise_step_label.dart';
import '../models/firebase-exercise-uploader/interface/exercise_interface.dart';
import '../utils/exercise_helper_functions.dart';

/* The `AssessmentPage` is a widget that displays the final assessment and reflection section after completing an exercise. It provides information about the session, allows the user to rate the exercise, and offers an option to navigate back to the courses page.

## Parameters:
- `exercise`: An instance of the `Exercise` model, which contains information about the exercise, including the final step details (`exerciseFinalStep`).
- `elapsedTime`: A string representation of the time spent on the exercise eg., "Elapsed Time: 5 minutes 20 seconds").
 
## Notes:
- Ensure that the `Exercise` object passed to the page contains the `exerciseFinalStep` property, as it is used to generate the title and description.
- The `elapsedTime` parameter should be a pre-formatted string that clearly represents the total time spent. */
class AssessmentPage extends StatefulWidget {
  final Exercise exercise;
  final String elapsedTime;

  const AssessmentPage(
      {super.key, required this.exercise, required this.elapsedTime});

  @override
  _AssessmentPageState createState() => _AssessmentPageState();
}

class _AssessmentPageState extends State<AssessmentPage> {
  // Slider values
  double feelingBetterValue = 3;
  double helpfulnessValue = 3;
  double ratingValue = 3;

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
                // TODO
                // What does sessions mean here
                description: 'Sessions: 4 completed out of 14 minimum'),
            SizedBox(height: 8),
            ExerciseDescription(description: widget.elapsedTime),
            SizedBox(height: 20),
            _buildSectionTitle('Comments'),
            SizedBox(height: 8),
            ExerciseReflectionBox(
              '',
              hintText: 'Reflect on your experience...',
            ),
            SizedBox(height: 20),
            _buildSectionTitle('Assessment'),
            SizedBox(height: 8),
            ExerciseSliderQuestionWidget(
                question:
                    '(A) Are you feeling better than before practising the exercise?'),
            ExerciseSliderQuestionWidget(
                question: '(B) How helpful was this exercise?'),
            ExerciseSliderQuestionWidget(question: '(C) Rate this exercise.'),
            SizedBox(height: 30),
            CustomButton(
              buttonText: 'Back to Course',
              onPress: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MainScreen(
                              initialIndex: 4,
                            )));
              },
              backgroundColor: AppColours.brandBlueMinusFour,
              textColor: AppColours.brandBlueMain,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildSliderQuestion(
    BuildContext context,
    String question,
    double currentValue,
    ValueChanged<double> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question,
          style: TextStyle(fontSize: 16),
        ),
        Slider(
          value: currentValue,
          min: 1,
          max: 5,
          divisions: 4,
          label: currentValue.round().toString(),
          onChanged: onChanged,
        ),
        SizedBox(height: 8),
      ],
    );
  }
}
