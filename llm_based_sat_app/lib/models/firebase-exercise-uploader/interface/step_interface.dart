class Step {
  final String stepTitle;
  final String description;
  final String additionalDetails;
  final String footerText;

  Step({
    required this.stepTitle,
    required this.description,
    this.additionalDetails = "",
    this.footerText = "",
  });

  factory Step.fromFirestore(String id, Map<String, dynamic> data) {
    return Step(
      stepTitle: data['Step_title'],
      description: data['Description'],
      additionalDetails: data['Additional Details'],
      footerText: data['Footer_text'],
    );
  }
}