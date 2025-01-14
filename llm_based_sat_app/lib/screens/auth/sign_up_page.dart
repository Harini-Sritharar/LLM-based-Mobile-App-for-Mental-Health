import 'package:flutter/material.dart';
import '/main.dart';
import '../../widgets/auth_widgets/circular_checkbox.dart';
import '../../widgets//auth_widgets/text_input_field.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _isTermsChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
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
            ),
            const SizedBox(height: 20),
            TextInputField(
              label: "Password",
              icon: Icons.lock,
              isPassword: true,
            ),
            const SizedBox(height: 20),
            TextInputField(
              label: "Confirm Password",
              icon: Icons.lock,
              isPassword: true,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                CircularCheckbox(
                  initialValue: _isTermsChecked,
                  onChanged: (bool value) {
                    setState(() {
                      _isTermsChecked = value;
                    });
                  },
                ),
                const SizedBox(
                    width: 10), // Space between the checkbox and text
                const Text(
                  'Agree to Terms & Conditions',
                  style: TextStyle(
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  backgroundColor: Colors.blue[800],
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MainScreen()));
                  // Sign up logic
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Sign Up',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(width: 10),
                    Icon(Icons.arrow_forward),
                  ],
                ),
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                // Navigate to sign-in page
              },
              child: const Text(
                'Already have an Account? SIGN IN',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
