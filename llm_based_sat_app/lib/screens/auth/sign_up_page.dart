import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:llm_based_sat_app/screens/profile/personal_profile_page.dart';
import 'package:llm_based_sat_app/screens/webview_page.dart'; // Import WebViewPage
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
  final FirebaseAuthService _auth = FirebaseAuthService();
  bool _agreeToTerms = false;
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _checkPasswordsMatch(String? value) {
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColours.white,
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WebViewPage(
                            url: 'https://invincimind.com/terms-and-conditions/',
                            title: 'Terms & Conditions',
                          ),
                        ),
                      );
                    },
                  )
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
          )),
        ),
      ),
    );
  }

  // Show Snackbar for errors
  void _showError(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  // This function should be called when the user presses the sign up button
  // It first checks that:
  // - all form fields are valid
  // - the terms have been agreed to before navigating to the main screen
  // It will then update the database by using firebase's sign up with email and
  // password method
  void _signUp() async {
    if (!_formKey.currentState!.validate()) return; // Validate form fields

    if (!_agreeToTerms) {
      _showError("You must accept the Terms & Conditions");
      return;
    }

    String email = _emailController.text;
    String password = _passwordController.text;

    User? currentUser =
        await _auth.signUpWithEmailAndPassword(context, email, password);

    if (currentUser != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => PersonalProfilePage()),
      );
    }
  }
}
