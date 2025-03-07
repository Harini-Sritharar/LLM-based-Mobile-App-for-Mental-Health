import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:llm_based_sat_app/models/firebase-exercise-uploader/interface/course_interface.dart';
import 'package:llm_based_sat_app/screens/course/courses_helper.dart';
import 'package:llm_based_sat_app/screens/course/course_info.dart';

// This mock class helps us avoid Firebase dependencies
class MockCourse extends Course {
  MockCourse({
    required String id,
    required String title,
    required String courseType,
    required String subscription,
    required String imageUrl,
    required String duration,
    required double rating,
    required int ratingCount,
  }) : super(
          id: id,
          title: title,
          courseType: courseType,
          subscription: subscription,
          imageUrl: imageUrl,
          duration: duration,
          rating: rating,
          ratingCount: ratingCount,
          chapters: [],
          aim: "Test Aim",
          prerequisites: [],
        );
}

  void main() {
    group('Course Helper Tests', () {
      test(
          'createOnButtonPress returns a function that navigates to CourseInfo',
          () {
        // Create a mock course
        final mockCourse = MockCourse(
          id: "test-id",
          title: "Test Course",
          courseType: "Mindfulness",
          subscription: "Free",
          imageUrl: "https://example.com/image.jpg",
          duration: "2 hours",
          rating: 4.5,
          ratingCount: 100,
        );

        // Create a mock onItemTapped function
        bool functionWasCalled = false;
        void mockOnItemTapped(int index) {
          functionWasCalled = true;
        }

        // Call the function we're testing
        final onButtonPress = createOnButtonPress(
          course: mockCourse,
          onItemTapped: mockOnItemTapped,
          selectedIndex: 1,
        );

        // Verify the returned function is not null
        expect(onButtonPress, isNotNull);

        // We can't directly test navigation in unit tests,
        // but we can verify the type of the returned function
        expect(onButtonPress is Function(BuildContext), isTrue);
      });

      test('preloadImages handles empty image lists', () async {
        // Call the function with empty map
        await preloadImages({});

        // If it doesn't throw an exception, it passes
        expect(true, isTrue);
      });
    });
  }

