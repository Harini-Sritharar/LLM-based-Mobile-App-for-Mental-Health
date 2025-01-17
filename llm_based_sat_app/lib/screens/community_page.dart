import 'package:flutter/material.dart';
import 'profile_page.dart';

class CommunityPage extends StatelessWidget {
  final Function(int) onItemTapped; // Required for navigation
  final int selectedIndex;

  const CommunityPage({super.key, required this.onItemTapped, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Community'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Handle notifications
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
                    selectedIndex: selectedIndex, // Pass index
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'Community Page',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
