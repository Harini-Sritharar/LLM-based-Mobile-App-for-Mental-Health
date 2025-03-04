/// A class representing a step in a process or workflow.
/// It contains details such as the step's title, description,
/// associated image, and additional information for display.
class Step {
  /// The unique identifier for this step.
  final String id;

  /// The URL of the image associated with this step.
  final String imageUrl;

  /// The title or name of the step.
  final String stepTitle;

  /// A brief description of the step.
  final String description;

  /// Any additional details related to the step. Default is an empty string.
  final String additionalDetails;

  /// Text displayed in the footer related to the step. Default is an empty string.
  final String footerText;

  /// The type of image associated with this step. It can either be "Happy" or "Sad".
  /// This is used to determine the visual representation for the step.
  final String imageType;

  /// Constructs a new [Step] object with the provided parameters.
  ///
  /// [id] - The unique identifier for the step.
  /// [imageUrl] - The URL of the image to display for this step.
  /// [stepTitle] - The title or name of the step.
  /// [description] - A brief description of the step.
  /// [additionalDetails] - Any extra information about the step (optional).
  /// [footerText] - The footer text displayed for the step (optional).
  /// [imageType] - The type of image to display for this step, either "Happy" or "Sad" (optional, default is "Happy").
  Step({
    required this.id,
    required this.imageUrl,
    required this.stepTitle,
    required this.description,
    this.additionalDetails = "",
    this.footerText = "",
    this.imageType = "Happy",
  });

  /// Creates a [Step] instance from Firestore data.
  ///
  /// [id] - The unique identifier for the step (usually the document ID from Firestore).
  /// [data] - A map containing the Firestore document fields and their values.
  ///
  /// Returns a new [Step] object populated with the values from the Firestore data.
  factory Step.fromFirestore(String id, Map<String, dynamic> data) {
    return Step(
      id: id,
      imageUrl: data['Image_Url'], // The URL of the image from Firestore.
      stepTitle: data['Step_title'], // The title of the step from Firestore.
      description: data['Description'], // The description from Firestore.
      additionalDetails:
          data['Additional Details'], // Additional details from Firestore.
      footerText: data['Footer_text'], // Footer text from Firestore.
      imageType:
          data['Image_Type'], // Image type ("Happy" or "Sad") from Firestore.
    );
  }
}
