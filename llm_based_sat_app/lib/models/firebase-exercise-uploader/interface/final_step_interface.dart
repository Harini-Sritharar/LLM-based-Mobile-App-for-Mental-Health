/// Represents the final step of an exercise, which includes a description, an image,
/// and a set of assessment questions for evaluating learning outcomes.
class FinalStep {
  final String id;
  final String imageUrl;
  final String stepTitle;
  final String description;
  final List<String> assessmentQuestions; // For final steps

  /// Constructor to initialize a `FinalStep` instance.
  FinalStep({
    required this.id,
    required this.imageUrl,
    required this.stepTitle,
    required this.description,
    required this.assessmentQuestions,
  });

  /// Factory method to create a `FinalStep` instance from Firestore data.
  /// - `id`: The Firestore document ID.
  /// - `data`: The Firestore document data as a `Map<String, dynamic>`.
  factory FinalStep.fromFirestore(String id, Map<String, dynamic> data) {
    return FinalStep(
      id: id,
      imageUrl: data['Image_Url'],
      stepTitle: data['Step_title'],
      description: data['Description'],
      assessmentQuestions:
          List<String>.from(data['Assessment_questions'] ?? []),
    );
  }
}
