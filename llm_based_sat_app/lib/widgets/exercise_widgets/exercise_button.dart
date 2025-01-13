import 'package:flutter/material.dart';

class ExerciseButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPress;

  const ExerciseButton({required this.buttonText, required this.onPress});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPress,
      child: Text(buttonText),
    );
  }
}
