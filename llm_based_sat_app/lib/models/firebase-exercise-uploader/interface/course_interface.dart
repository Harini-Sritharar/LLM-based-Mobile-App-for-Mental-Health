import 'chapter_interface.dart';

/// Represents a course that consists of multiple chapters, metadata, and prerequisites.
class Course {
  final String id; // Unique identifier for the course.
  final String title; // Title of the course.
  final double rating; // Average rating of the course.
  final String duration; // Estimated duration to complete the course.
  final int ratingCount; // Total number of ratings received.
  final String imageUrl; // URL for the course's thumbnail image.
  final String aim; // The learning objective or aim of the course.
  final String subscription; // Subscription type required to access the course.
  final String
      courseType; // Type/category of the course (e.g., "Beginner", "Advanced").
  final List<String>
      prerequisites; // List of prerequisites required for the course.
  final List<Chapter> chapters; // List of chapters contained in the course.

  /// Constructor to initialize a `Course` instance.
  /// Defaults `chapters` to an empty list if not provided.
  Course({
    required this.id,
    required this.title,
    required this.rating,
    required this.duration,
    required this.ratingCount,
    required this.imageUrl,
    required this.aim,
    required this.subscription,
    required this.courseType,
    required this.prerequisites,
    this.chapters = const [],
  });

  /// Factory method to create a `Course` instance from Firestore data.
  /// - `id`: The Firestore document ID.
  /// - `data`: The Firestore document data as a `Map<String, dynamic>`.
  factory Course.fromFirestore(String id, Map<String, dynamic> data) {
    return Course(
      id: id,
      title:
          data['Course_title'] ?? '', // Defaults to an empty string if missing.
      rating:
          (data['Rating'] ?? 0.0).toDouble(), // Ensures a valid double value.
      duration:
          data['Duration'] ?? '', // Defaults to an empty string if missing.
      ratingCount: (data['Rating_Count'] ?? 0), // Defaults to 0 if missing.
      imageUrl:
          data['Image_URL'] ?? '', // Defaults to an empty string if missing.
      aim: data['Aim'] ?? '', // Defaults to an empty string if missing.
      subscription:
          data['Subscription'] ?? '', // Defaults to an empty string if missing.
      courseType:
          data['Course_type'] ?? '', // Defaults to an empty string if missing.
      prerequisites: List<String>.from(
          data['Prerequisites'] ?? []), // Converts Firestore list.
    );
  }

  /// Returns a new `Course` instance with chapters attached.
  /// Used to populate a course with its corresponding chapters after fetching them separately.
  Course withChapters(List<Chapter> chapters) {
    return Course(
      id: id,
      title: title,
      rating: rating,
      duration: duration,
      ratingCount: ratingCount,
      imageUrl: imageUrl,
      aim: aim,
      subscription: subscription,
      courseType: courseType,
      prerequisites: prerequisites,
      chapters: chapters,
    );
  }
}
