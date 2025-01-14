import 'package:flutter/material.dart';

class ExerciseDescription extends StatelessWidget {
  final String description;

  const ExerciseDescription({
    super.key,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    List<TextSpan> textSpans = [];
    List<String> words = description.split(' ');
    final List<String> boldWords = ['happy', 'positive', 'unhappy', 'negative']; // List of words to be in bold

    for (var word in words) {
      if (boldWords.contains(word.toLowerCase())) {
        // Add bold word
        textSpans.add(TextSpan(
          text: '$word ',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF293138)),
        ));
      } else {
        // Add regular word
        textSpans.add(TextSpan(
          text: '$word ',
          style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 15, color: Color(0xFF293138)),
        ));
      }
    }

    return RichText(
      text: TextSpan(
        children: textSpans,
      ),
    );
  }
}
