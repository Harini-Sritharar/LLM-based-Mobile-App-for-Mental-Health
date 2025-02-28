import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:llm_based_sat_app/firebase/firebase_auth_services.dart';
import 'package:llm_based_sat_app/screens/auth/sign_in_page.dart';
import 'package:llm_based_sat_app/widgets/auth_widgets/text_input_field.dart';
import 'package:llm_based_sat_app/widgets/custom_button.dart';

/// A page that allows users to permanently delete their account.
/// The user must provide their password and a reason for deletion.
class DeleteAccountPage extends StatefulWidget {
  @override
  _DeleteAccountPageState createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends State<DeleteAccountPage> {
  final FirebaseAuthService _authServices = FirebaseAuthService();
  final TextEditingController _otherReasonController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? selectedReason;
  bool isLoading = false;

  /// List of predefined reasons for account deletion.
  final List<String> reasons = [
    "Technical issues",
    "Don’t see the value",
    "Confusing interface",
    "Expensive",
    "Lots of notifications",
    "I am feeling fine now",
  ];

  @override
  void dispose() {
    _otherReasonController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Handles account deletion after verifying password and reason selection.
  void _submitDeletion() async {
    if (_passwordController.text.isEmpty) {
      _showSnackBar("Please enter your password.");
      return;
    }
    if (selectedReason == null && _otherReasonController.text.isEmpty) {
      _showSnackBar("Please select a reason or enter one.");
      return;
    }

    setState(() => isLoading = true);

    try {
      bool success = await _authServices.deleteAccount(
        context,
        _passwordController.text,
        selectedReason ?? _otherReasonController.text,
      );

      if (success) {
        _showSnackBar("Account successfully deleted.");
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => SignInPage()));
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        _showSnackBar("Incorrect password. Please try again.");
      } else if (e.code == 'requires-recent-login') {
        _showSnackBar("Please log in again before deleting your account.");
      } else if (e.code == 'no-user') {
        _showSnackBar("No user signed in.");
      } else {
        _showSnackBar("Please try again");
      }
    } catch (e) {
      _showSnackBar("An error occurred while deleting the account.");
    } finally {
      setState(() => isLoading = false);
    }
  }

  /// Displays a Snackbar with a given message.
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Delete Account")),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Are you sure you want to permanently delete your account?",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                  "Deleting your account will erase your progress, data, and saved settings."),
              SizedBox(height: 20),

              /// Radio buttons for selecting a reason
              Text("Tell us the reason:",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              ...reasons.map((reason) {
                return RadioListTile<String>(
                  title: Text(reason),
                  value: reason,
                  groupValue: selectedReason,
                  onChanged: (value) => setState(() => selectedReason = value),
                );
              }).toList(),

              // Input field for custom reason
              TextInputField(
                label: "Other reason...",
                icon: Icons.comment,
                isPassword: false,
                controller: _otherReasonController,
              ),

              SizedBox(height: 20),

              /// Password confirmation input
              Text("Please confirm your password:",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              TextInputField(
                label: "Password",
                icon: Icons.lock,
                isPassword: true,
                controller: _passwordController,
              ),

              SizedBox(height: 20),

              /// Submit button to process account deletion
              CustomButton(
                buttonText: isLoading ? "Processing..." : "Submit Request",
                onPress: _submitDeletion,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
