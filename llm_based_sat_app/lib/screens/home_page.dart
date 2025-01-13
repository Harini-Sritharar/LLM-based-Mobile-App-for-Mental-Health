import 'package:flutter/material.dart';
import 'profile_page.dart';

class HomePage extends StatelessWidget {
  final Function(int) onItemTapped;
  final int selectedIndex;

  HomePage({required this.onItemTapped, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
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
          'Home Page',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
