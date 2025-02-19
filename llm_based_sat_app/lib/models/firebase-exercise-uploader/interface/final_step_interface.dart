class FinalStep {
  final String stepTitle;
  final String description;
  final List<String> assessmentQuestions; // For final steps

  FinalStep({
    required this.stepTitle,
    required this.description,
    required this.assessmentQuestions,
  });

  factory FinalStep.fromFirestore(String id, Map<String, dynamic> data) {
    return FinalStep(
      stepTitle: data['Step_title'],
      description: data['Description'],
      assessmentQuestions: List<String>.from(data['Assessment_questions'] ?? []),
    );
  }
}