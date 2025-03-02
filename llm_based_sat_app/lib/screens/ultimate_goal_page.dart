/// This file defines the `UltimateGoalPage` widget, which provides an interface for
/// users to set their ultimate goal. The page is designed to encourage users to
/// define socially useful goals that foster personal growth and self-development.

import 'package:flutter/material.dart';
import 'package:llm_based_sat_app/firebase/firebase_helpers.dart';
import 'package:llm_based_sat_app/screens/auth/sign_in_page.dart';
import 'package:llm_based_sat_app/theme/app_colours.dart';
import 'package:llm_based_sat_app/utils/user_provider.dart';
import 'package:llm_based_sat_app/widgets/custom_app_bar.dart';
import 'package:llm_based_sat_app/widgets/custom_button.dart';
import 'package:provider/provider.dart';
import '../widgets/main_layout.dart';

/// A stateful widget that represents the Ultimate Goal page.
/// This page allows users to input their ultimate goal with a character limit.
class UltimateGoalPage extends StatefulWidget {
  // Callback function to handle navigation bar item taps.
  final Function(int) onItemTapped;

  // The currently selected index in the navigation bar.
  final int selectedIndex;

  /// Constructor for `UltimateGoalPage`.
  ///
  /// Requires:
  /// - [onItemTapped]: A function to handle navigation bar item taps.
  /// - [selectedIndex]: The index of the currently selected item in the navigation bar.
  const UltimateGoalPage({
    required this.onItemTapped,
    required this.selectedIndex,
    Key? key,
  }) : super(key: key);

  @override
  _UltimateGoalPageState createState() => _UltimateGoalPageState();
}

class _UltimateGoalPageState extends State<UltimateGoalPage> {
  // Maximum number of characters allowed for the input.
  static const int maxCharacters = 250;

  // Text editing controller for the input box.
  final TextEditingController _textController = TextEditingController();

  // Remaining characters counter.
  int _remainingCharacters = maxCharacters;
  bool _isLoading = true;

  late UserProvider userProvider;

  late String uid;

  @override
  void initState() {
    super.initState();
    // Update the remaining character count as the user types.
    _textController.addListener(() {
      setState(() {
        _remainingCharacters = maxCharacters - _textController.text.length;
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userProvider = Provider.of<UserProvider>(context);
    uid = userProvider.getUid();
    _fetchUltimateGoal();
  }

  Future<void> _fetchUltimateGoal() async {
    if (!mounted) return;
    if (user == null) {
      print("No user logged in");
      setState(() => _isLoading = false);
      return;
    }
    String goal = await getUltimateGoal(uid);
    setState(() {
      if (goal.isNotEmpty) {
        _textController.text = goal;
      }
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    // Dispose of the text controller to release resources.
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      selectedIndex: widget.selectedIndex,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Custom app bar for the page.
              CustomAppBar(
                title: "Ultimate Goal",
                onItemTapped: widget.onItemTapped,
                selectedIndex: widget.selectedIndex,
              ),
              const SizedBox(height: 10),
              // Page title and description text.
              const Text(
                "Set Yourself an Ultimate Goal",
                style: TextStyle(
                    fontSize: 22, color: AppColours.neutralGreyMinusOne),
              ),
              const SizedBox(height: 20),
              const Text(
                "Your goal should be a socially useful ideal that guides you towards growth and self-development to empower you in today’s world with our problems.",
                style: TextStyle(
                    fontSize: 15, color: AppColours.neutralGreyMinusOne),
              ),
              const SizedBox(height: 10),
              const Text(
                "It could be achievement in an academic, scientific, literary, philosophical, athletic, spiritual, professional, charitable, or a socially progressive manufacturing/commercial/business field.",
                style: TextStyle(
                    fontSize: 15, color: AppColours.neutralGreyMinusOne),
              ),
              const SizedBox(height: 10),
              const Text(
                "If we do not have a clear goal at the start of the program, you can refine it later.",
                style: TextStyle(
                    fontSize: 15, color: AppColours.neutralGreyMinusOne),
              ),
              const SizedBox(height: 40),
              // Input box for entering the ultimate goal.
              _isLoading
                  ? Center(
                      child:
                          CircularProgressIndicator()) // Show a loading indicator
                  : _buildInputBox(),
              const SizedBox(height: 40),
              // Save button to save the entered goal.
              CustomButton(
                buttonText: "Save",
                onPress: () => saveUltimateGoal(context, _textController),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the input box for entering the ultimate goal.
  ///
  /// Displays a counter showing the remaining character count.
  Widget _buildInputBox() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColours.brandBlueMinusThree, // Light blue background
        borderRadius: BorderRadius.circular(15), // Rounded corners
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label for the input box.
          const Text(
            "My ultimate goal is...",
            style: TextStyle(
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 8),
          // Text input field for the user to enter their goal.
          TextField(
            controller: _textController,
            maxLength: maxCharacters,
            maxLines: 5,
            decoration: const InputDecoration(
              border: InputBorder.none,
              counterText: "", // Hide the default character counter.
            ),
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
          // Display the remaining character count.
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                "*$_remainingCharacters Characters Remaining",
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// The Onpress function for saving the ultimate goal.
void saveUltimateGoal(
    BuildContext context, TextEditingController goalController) async {
  UserProvider userProvider = Provider.of<UserProvider>(context);
  var uid = userProvider.getUid();
  if (user == null) {
    print("No user logged in");
    return;
  }
  if (goalController.text.isNotEmpty) {
    await setUltimateGoal(uid, goalController.text);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Ultimate goal saved successfully!")),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Please enter your ultimate goal.")),
    );
  }
}
