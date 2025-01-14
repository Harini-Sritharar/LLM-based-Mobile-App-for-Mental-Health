import 'package:flutter/material.dart';

class ExerciseImage extends StatelessWidget {
  final String imageUrl;

  const ExerciseImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.network(
        imageUrl,
        height: 200,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => const Text(
          "Image not found",
          style: TextStyle(color: Colors.red),
        ),
      ),
    );
  }
}
