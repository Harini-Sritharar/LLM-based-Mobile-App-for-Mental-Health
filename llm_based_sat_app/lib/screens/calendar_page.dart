import 'package:flutter/material.dart';
import 'profile_page.dart';

class CalendarPage extends StatelessWidget {
  final Function(int) onItemTapped; // Pass navigation function
  final int selectedIndex; // Pass selected index

  const CalendarPage({super.key, required this.onItemTapped, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage(
                    onItemTapped: onItemTapped, // Pass function
                    selectedIndex: selectedIndex, // Pass current index
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'Calendar Page',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
