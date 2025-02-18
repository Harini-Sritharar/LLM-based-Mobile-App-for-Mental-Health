import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../firebase/firebase_auth_services.dart';
import '/main.dart';
import '/screens/auth/sign_up_page.dart';
import '/theme/app_colours.dart';
import '/widgets/auth_widgets/text_input_field.dart';
import '/widgets/custom_button.dart';

User? user;

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final FirebaseAuthService _auth = FirebaseAuthService();

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _signIn() async {
    if (_formKey.currentState!.validate()) {
      // Navigate to the main screen
      String email = _emailController.text;
      String password = _passwordController.text;

      user = await _auth.signInWithEmailandPassword(context, email, password);

      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColours.white, // Matches the white background
      body: Center(
        child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
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
                    TextInputField(
                        label: "Email",
                        icon: Icons.email,
                        isPassword: false,
                        controller: _emailController),
                    const SizedBox(height: 20),
                    TextInputField(
                        label: "Password",
                        icon: Icons.lock,
                        isPassword: true,
                        controller: _passwordController),
                    const SizedBox(height: 40),
                    Center(
                        child: CustomButton(
                            buttonText: "Sign In",
                            onPress: _signIn,
                            rightArrowPresent: true)),
                    const SizedBox(height: 20),
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
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
