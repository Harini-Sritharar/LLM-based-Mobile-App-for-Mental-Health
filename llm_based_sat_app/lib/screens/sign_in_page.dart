import 'package:flutter/material.dart';
import 'package:llm_based_sat_app/main.dart';
import 'package:llm_based_sat_app/screens/auth/sign_up_page.dart';
import 'package:llm_based_sat_app/widgets/auth_widgets/text_input_field.dart';
import 'package:llm_based_sat_app/widgets/custom_button.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Matches the white background
      body: Center(
        child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                    // TextField(
                    //   decoration: InputDecoration(
                    //     hintText: "Email",
                    //     hintStyle: TextStyle(color: Colors.grey[500]),
                    //     prefixIcon: Icon(Icons.email, color: Colors.grey[500]),
                    //     filled: true,
                    //     fillColor: Colors.blue[50], // Matches light blue background
                    //     border: OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(12),
                    //       borderSide: BorderSide.none,
                    //     ),
                    //   ),
                    // ),
                    TextInputField(
                        label: "Email",
                        icon: Icons.email,
                        isPassword: false,
                        controller: _emailController),
                    const SizedBox(height: 20),
                    // TextField(
                    //   obscureText: true,
                    //   decoration: InputDecoration(
                    //     hintText: "Password",
                    //     hintStyle: TextStyle(color: Colors.grey[500]),
                    //     prefixIcon: Icon(Icons.lock, color: Colors.grey[500]),
                    //     filled: true,
                    //     fillColor: Colors.blue[50], // Matches light blue background
                    //     border: OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(12),
                    //       borderSide: BorderSide.none,
                    //     ),
                    //   ),
                    // ),
                    TextInputField(
                        label: "Password",
                        icon: Icons.lock,
                        isPassword: true,
                        controller: _passwordController),

                    const SizedBox(height: 40),
                    Center(
                        child: CustomButton(
                            buttonText: "Sign In",
                            onPress: () {
                              // The sign in logic goes here
                              // For now we just navigate to the main screen
                              if (_formKey.currentState!.validate()) {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MainScreen()));
                              }
                            },
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
                              color: Colors.blue,
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
