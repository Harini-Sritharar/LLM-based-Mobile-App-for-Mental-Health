import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';

class CalendarPage extends StatelessWidget {
  final Function(int) onItemTapped; // Pass navigation function
  final int selectedIndex; // Pass selected index

  const CalendarPage(
      {super.key, required this.onItemTapped, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "InvinciMind",
        onItemTapped: onItemTapped,
        selectedIndex: selectedIndex,
        backButton: false,
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
