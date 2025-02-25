import 'package:flutter/material.dart';
import 'package:llm_based_sat_app/theme/app_colours.dart';

/* CustomButton is a customizable button widget that allows for either left or right arrow icons to be displayed alongside the button text.

Parameters:
- `buttonText`: The text to display on the button.
- `onPress`: The function that is called when the button is pressed.
- `rightArrowPresent`: An optional boolean to display a right arrow (default is false).
- `leftArrowPresent`: An optional boolean to display a left arrow (default is false).
- `backgroundColor`: The background color of the button (optional). Defaults to a specific blue color. */

class CustomButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPress;
  final bool rightArrowPresent;
  final bool leftArrowPresent;
  final Color backgroundColor;
  final Color textColor;

  const CustomButton({
    super.key,
    required this.buttonText,
    required this.onPress,
    this.rightArrowPresent = false,
    this.leftArrowPresent = false,
    this.backgroundColor = AppColours.brandBlueMain,
    this.textColor = Colors.white,
  }) : assert(!(rightArrowPresent && leftArrowPresent),
            'Only one of rightArrowPresent or leftArrowPresent can be true.');

  @override
  Widget build(BuildContext context) {
    EdgeInsetsGeometry padding =
        (rightArrowPresent == false && leftArrowPresent == false)
            ? const EdgeInsets.symmetric(vertical: 16, horizontal: 16)
            : const EdgeInsets.symmetric(vertical: 6, horizontal: 6);

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        padding: padding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
      ),
      onPressed: onPress,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (leftArrowPresent)
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.chevron_left,
                color: AppColours.brandBlueMain,
                size: 24,
              ),
            ),
          Spacer(),
          Text(
            buttonText,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Spacer(),
          if (rightArrowPresent)
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.chevron_right,
                color: AppColours.brandBlueMain,
                size: 24,
              ),
            ),
        ],
      ),
    );
  }
}
