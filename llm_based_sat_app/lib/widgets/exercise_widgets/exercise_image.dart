import 'package:flutter/material.dart';

class ExerciseImage extends StatelessWidget {
  final String imageUrl;

  const ExerciseImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        imageUrl,
        height: 300,
        width: 350,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => const Text(
          "Image not found",
          style: TextStyle(color: Colors.red),
        ),
      ),
    );
  }
}