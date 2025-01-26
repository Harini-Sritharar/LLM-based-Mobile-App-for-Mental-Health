/// This file defines the `TermsAndConditionsPage` widget, which provides an interface
/// for displaying the application's terms and conditions to the user. It includes a
/// scrollable list of sections and integrates with the bottom navigation bar.

import 'package:flutter/material.dart';
import 'package:llm_based_sat_app/theme/app_colours.dart';

import '../widgets/custom_app_bar.dart';

/// A stateless widget that represents the Terms and Conditions page.
/// This page displays information about the terms and conditions of the application.
class TermsAndConditionsPage extends StatelessWidget {
  // Color constants used throughout the page.
  static const Color primaryTextColor = Color(0xFF687078);
  static const Color headerTextColor = Color(0xFF123659);
  static const Color arrowColor = Color(0xFF1C548C);

  // Callback function to handle navigation bar item taps.
  final Function(int) onItemTapped;

  // The currently selected index in the navigation bar.
  final int selectedIndex;

  /// Constructor for `TermsAndConditionsPage`.
  ///
  /// Requires:
  /// - [onItemTapped]: A function to handle navigation bar item taps.
  /// - [selectedIndex]: The index of the currently selected item in the navigation bar.
  TermsAndConditionsPage({
    required this.onItemTapped,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar with a back button, title, and notification icon.

      // Main body containing the terms and conditions content.
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: ListView(
          children: [
            CustomAppBar(
              title: "Terms & Conditions",
              onItemTapped: onItemTapped,
              selectedIndex: selectedIndex,
            ),
            // Example sections of terms and conditions.
            _buildSection(
              "Section 1.1",
              "Ut proverbia non nulla veriora sint quam vestra dogmata. Tamen aberramus a proposito, et, ne longius, prorsus, inquam, Piso, si ista mala sunt, placet. Omnes enim iucundum motum, quo sensus hilaretur. Cum id fugiunt, re eadem defendunt, quae Peripatetici, verba.",
            ),
            _buildSection(
              "Section 1.2",
              "Dicam, inquam, et quidem discendi causa magis, quam quo te aut Epicurum reprehensum velim. Dolor ergo, id est summum malum, metuetur semper, etiamsi non aderit.",
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a section of the terms and conditions with a title and content.
  ///
  /// [title]: The title of the section.
  /// [content]: The content of the section.
  Widget _buildSection(String title, String content) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title of the section.
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColours.termsAndCondionsHeaderColor,
            ),
          ),
          SizedBox(height: 5),
          // Content of the section.
          Text(
            content,
            style: TextStyle(
              fontSize: 17,
              color: AppColours.termsAndConditionsContentColor,
              height: 1.5, // Line height for better readability.
            ),
          ),
        ],
      ),
    );
  }
}
