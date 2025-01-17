import 'package:flutter/material.dart';

class ExerciseImage extends StatelessWidget {
  final String imageUrl;

  const ExerciseImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.0),
      ),
      child: Center(
        child: Image.asset(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => const Text(
            "Image not found",
            style: TextStyle(color: Colors.red),
          ),
        ),
      ),
    );
  }
}
