import 'package:flutter/material.dart';

class ExerciseSliderQuestionWidget extends StatefulWidget {
  final String question;
  final double initialValue;

  const ExerciseSliderQuestionWidget({
    Key? key,
    required this.question,
    this.initialValue = 3, 
  }) : super(key: key);

  @override
  _ExerciseSliderQuestionWidgetState createState() => _ExerciseSliderQuestionWidgetState();
}

class _ExerciseSliderQuestionWidgetState extends State<ExerciseSliderQuestionWidget> {
  double _currentValue = 3;

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
                activeColor: const Color(0xFF1C548C), // Blue slider color
                inactiveColor: Colors.grey[300],
                label: _currentValue.round().toString(),
                onChanged: (double value) {
                  setState(() {
                    _currentValue = value;
                  });
                },
              ),
            ),
            Text(
              _currentValue.round().toString(),
              style: TextStyle(
                fontSize: 16,
                color: const Color(0xFF1C548C), // Blue text color
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
