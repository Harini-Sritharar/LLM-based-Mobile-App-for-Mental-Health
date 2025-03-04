import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:llm_based_sat_app/screens/profile/personal_profile_page.dart';
import 'package:llm_based_sat_app/screens/webview_page.dart'; // Import WebViewPage for Terms & Conditions
import 'package:llm_based_sat_app/theme/app_colours.dart';
import '../../firebase/firebase_auth_services.dart';
import 'sign_in_page.dart';
// Widgets
import '../../widgets/custom_button.dart';
import '../../widgets/auth_widgets/circular_checkbox.dart';
import '../../widgets/auth_widgets/text_input_field.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  // Instance of FirebaseAuthService to handle authentication operations.
  final FirebaseAuthService _auth = FirebaseAuthService();

  // Bool to track whether the user agrees to the terms and conditions.
  bool _agreeToTerms = false;

  // Global key for the form to manage validation.
  final _formKey = GlobalKey<FormState>();

  // Controllers to capture user input for email, password, and confirm password.
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  /// Validator function to check if the confirm password matches the original password.
  String? _checkPasswordsMatch(String? value) {
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColours.white, // Background color of the sign-up page
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey, // Form key to handle validation
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                const Text(
                  'Sign up',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  'Getting Started...',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Create an Account to Continue with InvinciApp',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 40),

                // Email input field
                TextInputField(
                  label: "Email",
                  icon: Icons.email,
                  isPassword: false,
                  controller: _emailController,
                ),
                const SizedBox(height: 20),

                // Password input field
                TextInputField(
                  label: "Password",
                  icon: Icons.lock,
                  isPassword: true,
                  controller: _passwordController,
                ),
                const SizedBox(height: 20),

                // Confirm password input field with validator
                TextInputField(
                  label: "Confirm Password",
                  icon: Icons.lock,
                  isPassword: true,
                  controller: _confirmPasswordController,
                  validator: _checkPasswordsMatch,
                ),
                const SizedBox(height: 20),

                // Terms and Conditions acceptance checkbox
                Row(
                  children: [
                    CircularCheckbox(
                      initialValue: _agreeToTerms,
                      onChanged: (bool value) {
                        setState(() {
                          _agreeToTerms = value; // Update the agreement status
                        });
                      },
                    ),
                    const SizedBox(width: 10),
                    Text("I agree to the "),
                    InkWell(
                      child: Text(
                        'Terms & Conditions',
                        style: TextStyle(
                          color: AppColours.brandBlueMain,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onTap: () {
                        // Navigate to the Terms and Conditions page when clicked
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WebViewPage(
                              url:
                                  'https://invincimind.com/terms-and-conditions/',
                              title: 'Terms & Conditions',
                            ),
                          ),
                        );
                      },
                    )
                  ],
                ),
                const SizedBox(height: 20),

                // Sign Up button
                CustomButton(
                  buttonText: "Sign Up",
                  onPress: _signUp, // Calls the sign up method on press
                  rightArrowPresent: true,
                ),
                const SizedBox(height: 40),

                // Sign In navigation text
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an Account? ',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Navigate to the Sign-In page if user already has an account
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignInPage()));
                      },
                      child: const Text(
                        "SIGN IN",
                        style: TextStyle(
                          color: AppColours.brandBlueMain,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Displays an error message as a SnackBar when sign-up fails.
  void _showError(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  /// The function that is called when the user presses the "Sign Up" button.
  /// It checks for form validation, terms agreement, and then attempts
  /// to create a new user in Firebase Authentication.
  void _signUp() async {
    // Validate form fields before proceeding
    if (!_formKey.currentState!.validate()) return;

    // Ensure the user agrees to the terms and conditions
    if (!_agreeToTerms) {
      _showError("You must accept the Terms & Conditions");
      return;
    }

    // Get email and password from the input fields
    String email = _emailController.text;
    String password = _passwordController.text;

    // Attempt to sign up the user with email and password
    User? currentUser =
        await _auth.signUpWithEmailAndPassword(context, email, password);

    // If user creation is successful, navigate to the Personal Profile page
    if (currentUser != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => PersonalProfilePage()),
      );
    }
  }
}
