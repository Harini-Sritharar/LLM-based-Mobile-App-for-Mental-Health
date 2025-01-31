class FinalStep {
  final String stepTitle;
  final String description;
  final List<String> assessmentQuestions; // For final steps

  FinalStep({
    required this.stepTitle,
    required this.description,
    required this.assessmentQuestions,
  });

  factory FinalStep.fromMap(Map<String, dynamic> map) {
    return FinalStep(
      stepTitle: map['Step_title'] ?? '',
      description: map['Description'] ?? '',
      assessmentQuestions: (map['Assessment_questions'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );
  }
}