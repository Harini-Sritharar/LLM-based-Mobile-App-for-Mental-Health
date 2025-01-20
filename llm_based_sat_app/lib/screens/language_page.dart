import 'package:flutter/material.dart';
import 'package:llm_based_sat_app/theme/app_colours.dart';
import 'package:llm_based_sat_app/widgets/custom_app_bar.dart';

import '../widgets/custom_button.dart'; // Ensure the correct path to the CustomButton widget

class LanguagePage extends StatefulWidget {
  static const Color primaryTextColor = AppColours.neutralGreyMinusOne;
  static const Color secondaryTextColor = AppColours.brandBluePlusTwo;

  final Function(int) onItemTapped;
  final int selectedIndex;

  const LanguagePage({
    super.key,
    required this.onItemTapped,
    required this.selectedIndex,
  });

  @override
  _LanguagePageState createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  String _selectedLanguage = "English"; // Default selected language

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomAppBar(
                title: "Available Language",
                onItemTapped: widget.onItemTapped,
                selectedIndex: widget.selectedIndex),
            const SizedBox(height: 10),
            const Text(
              "Select your preferred language from below. Restart the app to apply changes.",
              style:
                  TextStyle(fontSize: 14, color: LanguagePage.primaryTextColor),
            ),
            const SizedBox(height: 20),
            _buildLanguageOption("Arabic"),
            _buildLanguageOption("English"),
            _buildLanguageOption("French"),
            _buildLanguageOption("Hindi"),
            _buildLanguageOption("Portuguese"),
            _buildLanguageOption("Spanish"),
            const SizedBox(height: 20),
            CustomButton(
              buttonText: "Restart App",
              onPress: () {
                // Logic for restarting the app can be added here
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Restart App button pressed")),
                );
              },
              rightArrowPresent: false, // No arrow for this button
              leftArrowPresent: false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(String language) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Radio<String>(
            value: language,
            groupValue: _selectedLanguage,
            onChanged: (value) {
              setState(() {
                _selectedLanguage = value!; // Update selected language
              });
            },
            activeColor: LanguagePage.secondaryTextColor,
          ),
          Text(language,
              style: const TextStyle(
                fontSize: 16,
                color: LanguagePage.primaryTextColor,
              )),
        ],
      ),
    );
  }
}
