import 'package:flutter/material.dart';
import 'package:llm_based_sat_app/widgets/custom_app_bar.dart';
import 'profile_page.dart';

class HomePage extends StatelessWidget {
  final Function(int) onItemTapped;
  final int selectedIndex;

  const HomePage({
    Key? key,
    required this.onItemTapped,
    required this.selectedIndex,
  }) : super(key: key);

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
          'Home Page',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
