import 'package:flutter/material.dart';
import 'profile_page.dart';

class ScorePage extends StatelessWidget {
  final Function(int) onItemTapped;
  final int selectedIndex;

  const ScorePage(
      {super.key, required this.onItemTapped, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Score'),
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
                    onItemTapped: onItemTapped,
                    selectedIndex: selectedIndex,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'Score Page',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
