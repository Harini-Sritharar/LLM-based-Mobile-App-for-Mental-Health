import 'package:flutter/material.dart';
import 'package:llm_based_sat_app/widgets/custom_app_bar.dart';

import '../theme/app_colours.dart';
import '../widgets/custom_button.dart';

/// A StatefulWidget that allows users to select their preferred language from a predefined list.
/// The selected language is displayed and stored for potential future use.
class LanguagePage extends StatefulWidget {
  final Function(int) onItemTapped; // Callback for bottom navigation bar taps.
  final int selectedIndex; // Current selected index in the navigation bar.

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

  /// Builds the UI for the language selection page.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Custom app bar at the top of the page.
            CustomAppBar(
                title: "Available Language",
                onItemTapped: widget.onItemTapped,
                selectedIndex: widget.selectedIndex),
            const SizedBox(height: 10),
            // Instructional text for the user.
            const Text(
              "Select your preferred language from below. Restart the app to apply changes.",
              style: TextStyle(
                  fontSize: 14, color: AppColours.primaryGreyTextColor),
            ),
            const SizedBox(height: 20),
            // Language options for the user to select.
            _buildLanguageOption("Arabic"),
            _buildLanguageOption("English"),
            _buildLanguageOption("French"),
            _buildLanguageOption("Hindi"),
            _buildLanguageOption("Portuguese"),
            _buildLanguageOption("Spanish"),
            const SizedBox(height: 20),
            // Button to restart the app.
            CustomButton(
              buttonText: "Restart App",
              onPress: () {
                // Placeholder for app restart logic.
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Restart App button pressed")),
                );
              },
              rightArrowPresent: false, // No arrow for this button.
              leftArrowPresent: false,
            ),
          ],
        ),
      ),
    );
  }

  /// Builds an individual language option with a radio button.
  ///
  /// [language]: The name of the language to display as an option.
  Widget _buildLanguageOption(String language) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          // Radio button for selecting the language.
          Radio<String>(
            value: language,
            groupValue: _selectedLanguage,
            onChanged: (value) {
              setState(() {
                _selectedLanguage = value!; // Update selected language.
              });
            },
            activeColor: AppColours
                .secondaryBlueTextColor, // Custom color for active state.
          ),
          // Display the name of the language.
          Text(language,
              style: const TextStyle(
                fontSize: 16,
                color: AppColours.primaryGreyTextColor,
              )),
        ],
      ),
    );
  }
}
