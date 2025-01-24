import 'package:flutter/material.dart';
import 'package:llm_based_sat_app/screens/course/course_info.dart';
import 'package:llm_based_sat_app/widgets/course_widgets/course_card.dart'; // Custom reusable widget for course cards

class Courses extends StatelessWidget {
  final Function(int) onItemTapped;
  final int selectedIndex;

  const Courses({
    Key? key,
    required this.onItemTapped,
    required this.selectedIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Courses',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Handle notification click
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              // Navigate to profile page
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select a course to start.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(children: generateCourseCards()),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: selectedIndex,
        onTap: onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Community',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.score),
            label: 'Score',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Courses',
          ),
        ],
      ),
    );
  }

/* Creates a dynamic `onButtonPress` function that navigates to the `CourseInfo` page with the specified parameters. */
  void Function(BuildContext) createOnButtonPress({
    required String courseTitle,
    required String courseType,
    required double rating,
  }) {
    return (BuildContext context) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CourseInfo(
            onItemTapped: onItemTapped,
            selectedIndex: selectedIndex,
            courseType: courseType,
            rating: rating,
            courseTitle: courseTitle,
          ),
        ),
      );
    };
  }

  /* Generates a list of `CourseCard` widgets dynamically based on course data. */
  List<Widget> generateCourseCards() {
    List<Map<String, dynamic>> courses = [
      {
        'imageUrl': 'assets/images/self_attachment.png',
        'courseType': 'Core',
        'courseTitle': 'Self-attachment',
        'duration': '2 week',
        'rating': 4.2,
        'ratingsCount': 7830,
      },
      {
        'imageUrl': 'assets/images/humour.png',
        'courseType': 'Core',
        'courseTitle': 'Humour',
        'duration': '6 week',
        'rating': 4.9,
        'ratingsCount': 560,
      },
      {
        'imageUrl': 'assets/images/creativity.png',
        'courseType': 'Advanced',
        'courseTitle': 'Creativity',
        'duration': '3 week',
        'rating': 3.9,
        'ratingsCount': 67,
      },
      {
        'imageUrl': 'assets/images/nature.png',
        'courseType': 'Advanced',
        'courseTitle': 'Nature',
        'duration': '1 week',
        'rating': 4.5,
        'ratingsCount': 1496,
      },
    ];

    // Generate a list of CourseCard widgets dynamically
    return courses.map((course) {
      return CourseCard(
        imageUrl: course['imageUrl'],
        courseType: course['courseType'],
        courseTitle: course['courseTitle'],
        duration: course['duration'],
        rating: course['rating'],
        ratingsCount: course['ratingsCount'],
        onButtonPress: createOnButtonPress(
          courseTitle: course['courseTitle'],
          courseType: course['courseType'],
          rating: course['rating'],
        ),
      );
    }).toList();
  }
}
