import 'package:flutter/material.dart';
import 'package:llm_based_sat_app/theme/app_colours.dart';

/* A widget that represents a slider-based question in an exercise assessment. Allows the user to select a value between 1 and 5 and updates the parent widget with the selected value. */
class ExerciseSliderQuestionWidget extends StatefulWidget {
  final String question;
  final double initialValue;
  final ValueChanged<double> onChanged; // Callback function

  const ExerciseSliderQuestionWidget({
    Key? key,
    required this.question,
    this.initialValue = 3,
    required this.onChanged,
  }) : super(key: key);

  @override
  _ExerciseSliderQuestionWidgetState createState() =>
      _ExerciseSliderQuestionWidgetState();
}

class _ExerciseSliderQuestionWidgetState
    extends State<ExerciseSliderQuestionWidget> {
  late double _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.question,
          style: TextStyle(
            fontSize: 16,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Slider(
                value: _currentValue,
                min: 1,
                max: 5,
                divisions: 4,
                activeColor: AppColours.brandBlueMain,
                inactiveColor: Colors.grey[300],
                label: _currentValue.round().toString(),
                onChanged: (double value) {
                  setState(() {
                    _currentValue = value;
                  });
                  widget.onChanged(value); // Notify parent
                },
              ),
            ),
            Text(
              _currentValue.round().toString(),
              style: TextStyle(
                fontSize: 16,
                color: AppColours.brandBlueMain,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
