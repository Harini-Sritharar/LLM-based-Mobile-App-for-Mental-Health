class Step {
  final String id;
  final String imageUrl;
  final String stepTitle;
  final String description;
  final String additionalDetails;
  final String footerText;
  final String imageType; // Value is either "Happy" or "Sad"

  Step({
    required this.id,
    required this.imageUrl,
    required this.stepTitle,
    required this.description,
    this.additionalDetails = "",
    this.footerText = "",
    this.imageType = "Happy",
  });

  factory Step.fromFirestore(String id, Map<String, dynamic> data) {
    return Step(
      id: id,
      imageUrl: data['Image_Url'],
      stepTitle: data['Step_title'],
      description: data['Description'],
      additionalDetails: data['Additional Details'],
      footerText: data['Footer_text'],
      imageType: data['Image_Type'],
    );
  }
}
