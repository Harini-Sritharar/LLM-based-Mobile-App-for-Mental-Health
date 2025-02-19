import 'package:flutter/material.dart';
import '/theme/app_colours.dart';
/* CircularCheckbox is a widget that displays a circular checkbox that can be toggled on and off.

Usage:
CircularCheckbox(
  initialValue: true,
  onChanged: (value) {
    print('Checkbox value: $value');
  },
)

Parameters:
- `initialValue`: The initial state of the checkbox.
- `onChanged`: A callback function that is called when the checkbox is toggled. */

class CircularCheckbox extends StatefulWidget {
  final bool initialValue; // Initial state of the checkbox
  final ValueChanged<bool>
      onChanged; // Callback function when the checkbox is toggled

  const CircularCheckbox({
    Key? key,
    required this.initialValue,
    required this.onChanged,
  }) : super(key: key);
  @override
  _CircularCheckboxState createState() => _CircularCheckboxState();
}

class _CircularCheckboxState extends State<CircularCheckbox> {
  late bool _isChecked; // State of the checkbox

  @override
  // Initialize the state of the checkbox
  void initState() {
    super.initState();
    _isChecked = widget.initialValue;
  }

  // Toggle the state of the checkbox
  void _toggleCheckbox() {
    setState(() {
      _isChecked = !_isChecked;
    });
    widget.onChanged(_isChecked);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleCheckbox,
      child: Container(
        width: 24.0, // Set the size of the "checkbox"
        height: 24.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle, // Makes the container circular
          color: _isChecked
              ? AppColours.supportingGreenMinusThree
              : AppColours
                  .brandBlueMinusFour, // Background color based on state
          border: Border.all(
            color: AppColours.brandBlueMain, // Border color
            width: 2.0, // Border width
          ),
        ),
        child: _isChecked
            ? Icon(
                Icons.check, // Checkmark icon when selected
                color: AppColours.supportingGreenMinusOne,
                size: 16.0,
              )
            : null, // Empty when unchecked
      ),
    );
  }
}
