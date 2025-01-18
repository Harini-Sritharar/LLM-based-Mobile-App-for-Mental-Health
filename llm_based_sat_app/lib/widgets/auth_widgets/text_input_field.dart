// This component gives a validated text input field with a label and an icon
import 'package:flutter/material.dart';
import '/theme/app_colours.dart';
/* TextInputField is a widget that displays a validated text input field with a label and an icon.

Usage:
TextInputField(
  label: 'Email',
  icon: Icons.email,
  isPassword: false,
  controller: _emailController,
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Email cannot be empty';
    }
    if (!RegExp(emailPattern).hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  },
)

Parameters:
- `label`: The label to be displayed for the input field.
- `icon`: The icon to be displayed for the input field.
- `isPassword`: A boolean to determine if the input field is a password field.
- `controller`: Controls the input field, used to get the value.
- `validator`: An optional validator function that provides custom validation; if not 
               provided, the default validator defined in the widget will be used instead. */

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
  final String? Function(String?)? validator; // Optional validator
  const TextInputField(
      {super.key,
      required this.label,
      required this.icon,
      required this.isPassword,
      required this.controller,
      this.validator});

  // Default validation function that provides default validation for email and password fields
  // Will be used if the validator is not provided
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
        style: TextStyle(color: AppColours.primaryGreyTextColor),
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: AppColours.textFieldBackgroundColor,
        ),
        obscureText: isPassword, // hiding the input based on the label
        validator: validator ?? _validateInput);
  }
}
