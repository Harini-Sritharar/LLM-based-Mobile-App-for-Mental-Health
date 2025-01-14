import 'package:flutter/material.dart';

/* CustomButton is a customizable button widget that allows for either left or right arrow icons to be displayed alongside the button text.

Usage:
CustomButton(
  buttonText: "Click Me", 
  onPress: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(), // Example next page
      ),
    );
  }, 
  rightArrowPresent: true, 
  leftArrowPresent: false
)

Parameters:
- `buttonText`: The text to display on the button.
- `onPress`: The function that is called when the button is pressed.
- `rightArrowPresent`: An optional boolean to display a right arrow (default is false).
- `leftArrowPresent`: An optional boolean to display a left arrow (default is false).
- `backgroundColor`: The background color of the button (optional). Defaults to a specific blue color. */

class CustomButton extends StatelessWidget {
  final String buttonText; // Text to display
  final VoidCallback onPress; // Page to invoke on press
  final bool rightArrowPresent; // Display right arrow if true
  final bool leftArrowPresent; // Display left arrow if true
  final Color backgroundColor; // Background color of the button
  final Color textColor; // Text color of the button text

  const CustomButton(
      {super.key,
      required this.buttonText,
      required this.onPress,
      this.rightArrowPresent = false,
      this.leftArrowPresent = false,
      this.backgroundColor =
          const Color(0xFF1C548C), // Default background color
      this.textColor = Colors.white})
      : assert(!(rightArrowPresent && leftArrowPresent),
            'Only one of rightArrowPresent or leftArrowPresent can be true.');

  @override
  Widget build(BuildContext context) {
    // Increase the vertical padding when neither the left nor the right arrow is true
    EdgeInsetsGeometry padding =
        (rightArrowPresent == false && leftArrowPresent == false)
            ? const EdgeInsets.symmetric(
                vertical: 16, horizontal: 16) // Increased padding
            : const EdgeInsets.symmetric(
                vertical: 6, horizontal: 6); // Default padding

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor, // Use the provided background color
        padding: padding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100), // Rounded Corners
        ),
      ),
      onPressed: onPress,
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.center, // Space between text and icon
        children: [
          if (leftArrowPresent)
            Positioned(
              left: 0,
              child: Container(
                width: 50, // Width of the circular container
                height: 50, // Height of the circular container
                decoration: const BoxDecoration(
                  color: Colors.white, // Background color of the icon container
                  shape: BoxShape.circle, // Circular shape
                ),
                child: const Icon(
                  Icons.chevron_left,
                  color: Color(0xFF1C548C), // Dark blue icon color
                  size: 40,
                ),
              ),
            ),
          Expanded(
            child: Text(
              buttonText,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textColor, // Text color
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
