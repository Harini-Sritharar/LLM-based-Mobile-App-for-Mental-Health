import 'package:flutter/material.dart';

class TextInputField extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isPassword;

  const TextInputField(
      {super.key,
      required this.label,
      required this.icon,
      required this.isPassword});

  @override
  Widget build(BuildContext context) {
    return TextField(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          filled: true,
          fillColor: Colors.blue[50],
        ),
        obscureText: isPassword);
  }
}
