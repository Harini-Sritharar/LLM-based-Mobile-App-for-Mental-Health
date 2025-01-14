import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String buttonText; // Text to display
  final VoidCallback onPress; // Page to invoke on press
  final bool rightArrowPresent; // Display right arrow if true

  const CustomButton(
      {super.key,
      required this.buttonText,
      required this.onPress,
      required this.rightArrowPresent});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1C548C), // Button background color
        padding: const EdgeInsets.symmetric(
            vertical: 6, horizontal: 6), // Button padding
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100), // Rounded Corners
        ),
      ),
      onPressed: onPress,
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.center, // Space between text and icon
        children: [
          Expanded(
            child: Text(
              buttonText,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white, // Text color
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          if (rightArrowPresent)
            Positioned(
              right: 0,
              child: Container(
                width: 50, // Width of the circular container
                height: 50, // Height of the circular container
                decoration: const BoxDecoration(
                  color: Colors.white, // Background color of the icon container
                  shape: BoxShape.circle, // Circular shape
                ),
                child: const Icon(
                  Icons.chevron_right,
                  color: Color(0xFF1C548C), // Dark blue icon color
                  size: 40,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
