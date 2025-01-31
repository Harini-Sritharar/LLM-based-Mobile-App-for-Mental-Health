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

  factory Step.fromMap(Map<String, dynamic> map) {
    return Step(
      stepTitle: map['Step_title'] ?? '',
      description: map['Description'] ?? '',
      additionalDetails: map['Additional Details'] ?? '',
      footerText: map['Footer_text'] ?? '',
    );
  }
}