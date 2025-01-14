import 'package:flutter/material.dart';

class CircularCheckbox extends StatefulWidget {
  final bool initialValue;
  final ValueChanged<bool> onChanged;

  const CircularCheckbox({
    Key? key,
    required this.initialValue,
    required this.onChanged,
  }) : super(key: key);
  @override
  _CircularCheckboxState createState() => _CircularCheckboxState();
}

class _CircularCheckboxState extends State<CircularCheckbox> {
  late bool _isChecked;

  @override
  void initState() {
    super.initState();
    _isChecked = widget.initialValue;
  }

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
              ? Colors.blue
              : Colors.grey[300], // Background color based on state
          border: Border.all(
            color: Colors.black54, // Border color
            width: 2.0, // Border width
          ),
        ),
        child: _isChecked
            ? Icon(
                Icons.check, // Checkmark icon when selected
                color: Colors.white,
                size: 16.0,
              )
            : null, // Empty when unchecked
      ),
    );
  }
}
