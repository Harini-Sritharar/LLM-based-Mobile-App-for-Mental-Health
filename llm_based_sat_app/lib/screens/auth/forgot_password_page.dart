import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:llm_based_sat_app/firebase/firebase_auth_services.dart';
import 'package:llm_based_sat_app/screens/auth/sign_in_page.dart';
import 'package:llm_based_sat_app/widgets/auth_widgets/text_input_field.dart';
import 'package:llm_based_sat_app/widgets/custom_button.dart';

/* This file defines the Forgot Password Screen, which displays a field for the user to enter their email to send a reset password link to. */

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final FirebaseAuthService _auth = FirebaseAuthService();
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _resetPassword() async {
    // checks to see if the email is valid
    if (_formKey.currentState!.validate()) {
      // Check if a user exists for this email
      // List<String> signInMethods =
      //     await _firebaseAuth.fetchSignInMethodsForEmail(_emailController.text);

      // if (signInMethods.isEmpty) {
      //   if (!mounted) return;
      //   // No user exists for this email
      //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //     content: Text("No user found for that email."),
      //     duration: const Duration(seconds: 3),
      //   ));
      //   return; // Stop execution
      // }
      try {
        await _auth.resetPassword(_emailController.text);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Check your email for a password reset link!"),
          duration: const Duration(seconds: 3),
        ));
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return SignInPage();
        }));
      } on FirebaseAuthException catch (e) {
        String errorMessage;

        switch (e.code) {
          case "user-not-found":
            errorMessage = "No user found for that email.";
            break;
          default:
            errorMessage = "An error occurred. Please contact the developer";
        }

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(errorMessage),
          duration: const Duration(seconds: 3),
        ));
        // Handle any errors
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Error occurred"),
          duration: const Duration(seconds: 3),
        ));
      }
      // Reset password
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                    child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(children: [
                          Center(
                            child: Text(
                              "Forgot Password?",
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(height: 60),
                          const Text(
                            "Enter your email for a password reset link!",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 40),
                          TextInputField(
                              label: "Email",
                              icon: Icons.email,
                              isPassword: false,
                              controller: _emailController),
                          const SizedBox(height: 40),
                          Center(
                              child: CustomButton(
                                  buttonText: "Send Link",
                                  onPress: _resetPassword,
                                  rightArrowPresent: true)),
                        ]))))));
  }
}
// We can change what the reset email shows us
