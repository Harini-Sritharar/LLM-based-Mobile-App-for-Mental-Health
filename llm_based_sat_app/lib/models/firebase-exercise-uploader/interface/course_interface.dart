import 'chapter_interface.dart';

class Course {
  final String id;
  final String title;
  final double rating;
  final String duration;
  final int ratingCount;
  final String imageUrl;
  final String aim;
  final String subscription;
  final String courseType;
  final List<String> prerequisites;
  final List<Chapter> chapters;

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

  // Factory method to create a Course from Firestore data
  factory Course.fromFirestore(String id, Map<String, dynamic> data) {
    return Course(
      id: id,
      title: data['Course_title'] ?? '',
      rating: (data['Rating'] ?? 0.0).toDouble(),
      duration: data['Duration'] ?? '',
      ratingCount: (data['Rating_Count'] ?? 0),
      imageUrl: data['Image_URL'] ?? '',
      aim: data['Aim'] ?? '',
      subscription: data['Subscription'] ?? '',
      courseType: data['Course_type'] ?? '',
      prerequisites: List<String>.from(data['Prerequisites'] ?? []),
    );
  }

  // Method to attach chapters to a course
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
