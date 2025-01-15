// This component gives a validated text input field with a label and an icon
import 'package:flutter/material.dart';

class TextInputField extends StatelessWidget {
  // Regular Expression Pattern to validate the email
  final String emailPattern =
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';

  final String label; // label to be displayed for the input field
  final IconData icon; // icon to be displayed for the input field
  final bool
      isPassword; // boolean to determine if the input field is a password field
  final TextEditingController
      controller; // controls the input field, we can use this to get the value
  TextInputField(
      {super.key,
      required this.label,
      required this.icon,
      required this.isPassword,
      required this.controller});

  // Validation function
  String? _validateInput(String? value) {
    if (value == null || value.isEmpty) {
      return '$label cannot be empty';
    }

    if (label == 'Email') {
      if (!RegExp(emailPattern).hasMatch(value)) {
        return 'Please enter a valid email';
      }
    }

    if (label == 'Password') {
      if (value.length < 6) {
        return 'Password must be at least 6 characters';
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          filled: true,
          fillColor: Colors.blue[50],
        ),
        obscureText: isPassword, // hiding the input based on the label
        validator: _validateInput);
  }
}
