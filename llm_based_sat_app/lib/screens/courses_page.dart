import 'package:flutter/material.dart';
import 'profile_page.dart';

class CoursesPage extends StatelessWidget {
  final Function(int) onItemTapped; // Required for bottom navigation
  final int selectedIndex; // Current tab index

  CoursesPage({required this.onItemTapped, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Courses'),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              // Handle notifications
            },
          ),
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage(
                    onItemTapped: onItemTapped,
                    selectedIndex: selectedIndex,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Text(
          'Courses Page',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
