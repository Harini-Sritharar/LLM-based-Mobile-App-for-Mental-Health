import 'package:flutter/material.dart';
import 'package:llm_based_sat_app/widgets/custom_app_bar.dart';
import '../widgets/main_layout.dart'; // Import MainLayout

class UltimateGoalPage extends StatefulWidget {
  final Function(int) onItemTapped; // Function to update navbar index
  final int selectedIndex; // Keep track of selected index

  const UltimateGoalPage(
      {required this.onItemTapped, required this.selectedIndex, Key? key})
      : super(key: key);

  @override
  _UltimateGoalPageState createState() => _UltimateGoalPageState();
}

class _UltimateGoalPageState extends State<UltimateGoalPage> {
  static const int maxCharacters = 250;
  final TextEditingController _textController = TextEditingController();
  int _remainingCharacters = maxCharacters;

  @override
  void initState() {
    super.initState();
    _textController.addListener(() {
      setState(() {
        _remainingCharacters = maxCharacters - _textController.text.length;
      });
    });
  }

  @override
  void dispose() {
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
          // Wrap with SingleChildScrollView
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomAppBar(title: "Ultimate Goal"),
              const SizedBox(height: 10),
              const Text(
                "Set Yourself an Ultimate Goal",
                style: TextStyle(fontSize: 22, color: Color(0xFF687078)),
              ),
              const SizedBox(height: 20),
              const Text(
                "Your goal should be a socially useful ideal that guides you towards growth and self-development to empower you in today’s world with our problems.",
                style: TextStyle(fontSize: 16, color: Color(0xFF687078)),
              ),
              const SizedBox(height: 10),
              const Text(
                "It could be achievement in an academic, scientific, literary, philosophical, athletic, spiritual, professional, charitable, or a socially progressive manufacturing/commercial/business field.",
                style: TextStyle(fontSize: 16, color: Color(0xFF687078)),
              ),
              const SizedBox(height: 10),
              const Text(
                "If we do not have a clear goal at the start of the program, you can refine it later.",
                style: TextStyle(fontSize: 16, color: Color(0xFF687078)),
              ),
              const SizedBox(height: 40),
              _buildInputBox(),
              const SizedBox(height: 40),
              _buildSaveButton()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
          onPressed: () {
            // Save button functionality (to be implemented)
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1C548C),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          child: const Text(
            "Save",
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildInputBox() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFD0E0F0), // Light blue background
        borderRadius: BorderRadius.circular(15), // Rounded corners
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "My ultimate goal is...",
            style: TextStyle(
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _textController,
            maxLength: maxCharacters,
            maxLines: 5,
            decoration: const InputDecoration(
              border: InputBorder.none,
              counterText: "", // Hide default counter
            ),
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
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
