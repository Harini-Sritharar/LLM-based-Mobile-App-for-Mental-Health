import 'package:flutter/material.dart';
import 'package:llm_based_sat_app/screens/home_page.dart';
import 'package:llm_based_sat_app/theme/app_colours.dart';
import 'package:llm_based_sat_app/widgets/custom_button.dart';
import 'package:llm_based_sat_app/widgets/exercise_widgets/exercise_reflectionBox.dart';
import 'package:llm_based_sat_app/widgets/exercise_widgets/exercise_appBar.dart';
import 'package:llm_based_sat_app/widgets/exercise_widgets/exercise_description.dart';
import 'package:llm_based_sat_app/widgets/exercise_widgets/exercise_sliderQuestion.dart';
import 'package:llm_based_sat_app/widgets/exercise_widgets/exercise_step_label.dart';
import 'package:llm_based_sat_app/widgets/exercise_widgets/exercise_timer.dart';

class AssessmentPage extends StatefulWidget {
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
        title: 'Exercise A',
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
                    'You successfully completed Exercise A. You can now move on to the next exercise or back to the course page.'),
            SizedBox(height: 20),
            _buildSectionTitle('Session Info'),
            SizedBox(height: 8),
            ExerciseDescription(
                description: 'Sessions: 4 completed out of 14 minimum'),
            SizedBox(height: 8),
            ExerciseDescription(
                description: 'Practice Time: 05 minutes and 23 seconds'),
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
                buttonText: 'Next Exercise',
                onPress: () {
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
                },
                rightArrowPresent: true),
            SizedBox(height: 30),
            CustomButton(
              buttonText: 'Back to Course',
              onPress: () {
                // Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
              },
              backgroundColor: AppColours.brandBlueMinusFour,
              textColor: AppColours.brandBlueMain,
            ),
            SizedBox(height: 30),
            ExerciseTimer()
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