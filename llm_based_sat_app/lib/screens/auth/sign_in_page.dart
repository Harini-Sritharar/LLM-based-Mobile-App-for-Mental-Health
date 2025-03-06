import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:llm_based_sat_app/firebase_messaging_service.dart';
import 'package:llm_based_sat_app/screens/auth/forgot_password_page.dart';
import '../../firebase/firebase_auth_services.dart';
import '/main.dart';
import '/screens/auth/sign_up_page.dart';
import '/theme/app_colours.dart';
import '/widgets/auth_widgets/text_input_field.dart';
import '/widgets/custom_button.dart';

// Global variable to store the current authenticated user.
User? user;

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  // Instance of FirebaseAuthService to handle authentication.
  final FirebaseAuthService _auth = FirebaseAuthService();

  // Form key to manage the form validation.
  final _formKey = GlobalKey<FormState>();

  // Text controllers to get email and password inputs.
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  /// Handles user sign-in by validating the form and using the provided email and password
  /// to authenticate the user. If successful, navigates to the main screen.
  void _signIn() async {
    // Validates the form inputs before proceeding.
    if (_formKey.currentState!.validate()) {
      // Retrieves email and password entered by the user.
      String email = _emailController.text;
      String password = _passwordController.text;

      // Calls the sign-in method from the authentication service.
      user = await _auth.signInWithEmailandPassword(context, email, password);

      // If the user is successfully authenticated, navigate to the main screen.
      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainScreen()),
        );
      }

      // Get the Firebase messaging token for the device.
      String? token = await FirebaseMessaging.instance.getToken();

      // If a token is retrieved, save it to the Firebase database.
      if (token != null) {
        await FirebaseMessagingService().saveTokenToDatabase(token);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColours.white, // Sets the background color to white
      body: Center(
        child: Form(
            key: _formKey, // Attach the form key for validation
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Title Text
                    Center(
                      child: Text(
                        "Sign in",
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 60),
                    const Text(
                      "Let’s sign you in!",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Email input field
                    TextInputField(
                        label: "Email",
                        icon: Icons.email,
                        isPassword: false,
                        controller: _emailController),
                    const SizedBox(height: 20),

                    // Password input field
                    TextInputField(
                        label: "Password",
                        icon: Icons.lock,
                        isPassword: true,
                        controller: _passwordController),
                    const SizedBox(height: 40),

                    // Sign In Button
                    Center(
                        child: CustomButton(
                            buttonText: "Sign In",
                            onPress:
                                _signIn, // Calls _signIn method when pressed
                            rightArrowPresent: true)),

                    const SizedBox(height: 20),

                    // Sign Up and Forgot Password Links
                    Center(
                        child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Don't have an Account?",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // Navigate to the Sign-Up page
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignUpPage()));
                          },
                          child: const Text(
                            "SIGN UP",
                            style: TextStyle(
                              color: AppColours.brandBlueMain,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    )),

                    // Forgot Password Link
                    Center(
                        child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Forgot your password?",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // Navigate to the Forgot Password page
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ForgotPasswordPage()));
                          },
                          child: const Text(
                            "Reset password?",
                            style: TextStyle(
                              color: AppColours.brandBlueMain,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ))
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
