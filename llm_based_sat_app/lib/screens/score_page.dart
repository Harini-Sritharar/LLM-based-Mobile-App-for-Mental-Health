import 'package:flutter/material.dart';
import 'profile_page.dart';
import '../widgets/custom_app_bar.dart';

class ScorePage extends StatelessWidget {
  final Function(int) onItemTapped;
  final int selectedIndex;

  const ScorePage(
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
          'Score Page',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
