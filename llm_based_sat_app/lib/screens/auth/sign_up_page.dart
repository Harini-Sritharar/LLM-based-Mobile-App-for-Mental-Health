import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:llm_based_sat_app/screens/personal_info_page.dart';
import 'package:llm_based_sat_app/screens/personal_profile_page.dart';
import 'package:llm_based_sat_app/theme/app_colours.dart';
import '/firebase_auth_implementation/firebase_auth_services.dart';
import 'sign_in_page.dart';
import '/main.dart';
// Widgets
import '../../widgets/custom_button.dart';
import '../../widgets/auth_widgets/circular_checkbox.dart';
import '../../widgets//auth_widgets/text_input_field.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  // Firebase authentication service to use for authentication
  final FirebaseAuthService _auth = FirebaseAuthService();

  // Form specific fields
  bool _agreeToTerms = false;
  final _formKey = GlobalKey<FormState>();

  // Controllers, used for field validation and can be used to fetch the field value
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Validator used to check if the password and confirm password fields match
  String? _checkPasswordsMatch(String? value) {
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          AppColours.backgroundColor, // Matches the white background
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
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
              TextInputField(
                label: "Email",
                icon: Icons.email,
                isPassword: false,
                controller: _emailController,
              ),
              const SizedBox(height: 20),
              TextInputField(
                label: "Password",
                icon: Icons.lock,
                isPassword: true,
                controller: _passwordController,
              ),
              const SizedBox(height: 20),
              TextInputField(
                label: "Confirm Password",
                icon: Icons.lock,
                isPassword: true,
                controller: _confirmPasswordController,
                validator: _checkPasswordsMatch,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  CircularCheckbox(
                    initialValue: _agreeToTerms,
                    onChanged: (bool value) {
                      setState(() {
                        _agreeToTerms = value;
                      });
                    },
                  ),
                  const SizedBox(
                      width: 10), // Space between the checkbox and text
                  Text(
                    'Agree to Terms & Conditions',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              CustomButton(
                buttonText: "Sign Up",
                onPress: _signUp,
                rightArrowPresent: true,
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already have an Account? '),
                  GestureDetector(
                    onTap: () {
                      // Navigate to sign-in page
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignInPage()));
                    },
                    child: const Text(
                      'SIGN IN',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColours.customBlue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          )),
        ),
      ),
    );
  }

  // This function should be called when the user presses the sign up button
  // It first checks that:
  // - all form fields are valid
  // - the terms have been agreed to before navigating to the main screen
  // It will then update the database by using firebase's sign up with email and
  // password method
  void _signUp() async {
    if (_formKey.currentState!.validate() && _agreeToTerms) {
      // Navigate to the main screen
      String email = _emailController.text;
      String password = _passwordController.text;

      User? currentUser =
          await _auth.signUpWithEmailAndPassword(context, email, password);

      if (currentUser != null) {
        user = currentUser;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PersonalProfilePage()),
        );
      }
    }
  }
}
