import 'package:flutter/material.dart';
import 'package:llm_based_sat_app/widgets/course_widgets/course_card.dart'; // Custom reusable widget for course cards

class CoursesPage extends StatelessWidget {
  final Function(int) onItemTapped;
  final int selectedIndex;

  const CoursesPage({
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
              child: ListView(
                children: [
                  CourseCard(
                    imageUrl: 'assets/images/self_attachment.png',
                    courseType: 'Core',
                    courseTitle: 'Self-attachment',
                    duration: '2 week',
                    rating: 4.2,
                    ratingsCount: 7830,
                  ),
                  CourseCard(
                    imageUrl: 'assets/images/humour.png',
                    courseType: 'Core',
                    courseTitle: 'Humour',
                    duration: '6 week',
                    rating: 4.9,
                    ratingsCount: 560,
                  ),
                  CourseCard(
                    imageUrl: 'assets/images/creativity.png',
                    courseType: 'Advanced',
                    courseTitle: 'Creativity',
                    duration: '3 week',
                    rating: 3.9,
                    ratingsCount: 67,
                  ),
                  CourseCard(
                    imageUrl: 'assets/images/nature.png',
                    courseType: 'Advanced',
                    courseTitle: 'Nature',
                    duration: '1 week',
                    rating: 4.5,
                    ratingsCount: 1496,
                  ),
                ],
              ),
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
}
