import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:llm_based_sat_app/firebase/firebase_auth_services.dart';
import 'package:llm_based_sat_app/screens/settings_page.dart';
import 'package:llm_based_sat_app/widgets/custom_button.dart';
import 'package:llm_based_sat_app/widgets/auth_widgets/text_input_field.dart';

/// A page that allows users to reset their settings to default.
/// Requires the user to confirm their password before proceeding.
class ResetSettingsPage extends StatefulWidget {
  @override
  _ResetSettingsPageState createState() => _ResetSettingsPageState();
}

class _ResetSettingsPageState extends State<ResetSettingsPage> {
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuthService _authServices = FirebaseAuthService();
  bool isLoading = false;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  /// Handles the reset settings request.
  /// Requires the user to enter their password for authentication.
  void _resetSettings() async {
    if (_passwordController.text.isEmpty) {
      _showSnackBar("Please enter your password.");
      return;
    }

    setState(() => isLoading = true);

    try {
      bool success =
          await _authServices.resetSettings(context, _passwordController.text);
      if (success) {
        _showSnackBar("Settings have been reset.");
        Navigator.pop(context); // Navigate back to previous page
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        _showSnackBar("Incorrect password. Please try again.");
      } else if (e.code == 'no-user') {
        _showSnackBar("No user signed in.");
      } else {
        _showSnackBar("Please try again");
      }
    } catch (e) {
      _showSnackBar("Error resetting settings.");
    } finally {
      setState(() => isLoading = false);
    }
  }

  /// Displays a snack bar with the given message.
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reset Settings"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Are you sure you want to reset your settings to default?",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            const Text(
              "This action cannot be undone.",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            const Text(
              "Please confirm your password:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextInputField(
              label: "Password",
              icon: Icons.lock,
              isPassword: true,
              controller: _passwordController,
            ),
            const SizedBox(height: 20),
            CustomButton(
              buttonText: isLoading ? "Processing..." : "Reset Settings",
              onPress: _resetSettings,
            ),
          ],
        ),
      ),
    );
  }
}
