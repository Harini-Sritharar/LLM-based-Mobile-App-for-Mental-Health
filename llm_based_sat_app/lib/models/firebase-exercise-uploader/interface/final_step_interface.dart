class FinalStep {
  final String id;
  final String imageUrl;
  final String stepTitle;
  final String description;
  final List<String> assessmentQuestions; // For final steps

  FinalStep({
    required this.id,
    required this.imageUrl,
    required this.stepTitle,
    required this.description,
    required this.assessmentQuestions,
  });

  factory FinalStep.fromFirestore(String id, Map<String, dynamic> data) {
    return FinalStep(
      id: id,
      imageUrl: data['Image_Url'],
      stepTitle: data['Step_title'],
      description: data['Description'],
      assessmentQuestions: List<String>.from(data['Assessment_questions'] ?? []),
    );
  }
}