/// This file defines the `PersonalInfoPage` widget, which allows users to
/// input and update their personal information, including name, surname,
/// date of birth, and gender. The updated information can be saved to the database.

import 'package:flutter/material.dart';
import 'package:llm_based_sat_app/models/user_data_interface.dart';
import 'package:llm_based_sat_app/screens/personal_profile_page.dart';
import 'package:llm_based_sat_app/theme/app_colours.dart';
import 'package:llm_based_sat_app/widgets/custom_app_bar.dart';
import '../widgets/auth_widgets/text_input_field.dart';

/// A stateful widget that represents the Personal Info page.
/// This page allows users to enter and save their personal information.
class PersonalInfoPage extends StatefulWidget {
  // Callback function to handle navigation bar item taps.
  final Function(int) onItemTapped;

  // The currently selected index in the navigation bar.
  final int selectedIndex;

  /// Constructor for `PersonalInfoPage`.
  ///
  /// Requires:
  /// - [onItemTapped]: A function to handle navigation bar item taps.
  /// - [selectedIndex]: The index of the currently selected item in the navigation bar.
  const PersonalInfoPage({
    Key? key,
    required this.onItemTapped,
    required this.selectedIndex,
  }) : super(key: key);

  @override
  _PersonalInfoPageState createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  // Controllers for the text input fields.
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();

  // Selected gender value.
  String? _selectedGender;

  // User data interface instance.
  final User_ user = User_();

  @override
  void dispose() {
    // Dispose of controllers to release resources.
    _nameController.dispose();
    _surnameController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Custom app bar for navigation.
              CustomAppBar(
                title: "Personal Profile",
                onItemTapped: widget.onItemTapped,
                selectedIndex: widget.selectedIndex,
              ),
              const SizedBox(height: 10),
              // Title and description for the page.
              const Text(
                "Personal Info",
                style: TextStyle(
                  fontSize: 22,
                  color: AppColours.secondaryBlueTextColor,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Complete your Personal Information",
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF687078),
                ),
              ),
              const SizedBox(height: 40),
              // Input field for name.
              TextInputField(
                label: "Name",
                icon: Icons.person,
                isPassword: false,
                controller: _nameController,
              ),
              const SizedBox(height: 20),
              // Input field for surname.
              TextInputField(
                label: "Surname",
                icon: Icons.person_outline,
                isPassword: false,
                controller: _surnameController,
              ),
              const SizedBox(height: 20),
              // Date picker field for date of birth.
              _buildDatePickerField(),
              const SizedBox(height: 20),
              // Dropdown menu for selecting gender.
              _buildGenderDropdown(),
              const SizedBox(height: 40),
              // Save button to save the entered personal information.
              _buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds a date picker field for selecting the date of birth.
  ///
  /// Displays a calendar when the calendar icon is pressed.
  Widget _buildDatePickerField() {
    return TextField(
      controller: _dobController,
      readOnly: true,
      decoration: InputDecoration(
        labelText: "Date of Birth",
        filled: true,
        fillColor: AppColours.textFieldBackgroundColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        prefixIcon: IconButton(
          icon: const Icon(Icons.calendar_today),
          onPressed: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
            );
            if (pickedDate != null) {
              setState(() {
                _dobController.text =
                    "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
              });
            }
          },
        ),
      ),
    );
  }

  /// Builds a dropdown menu for selecting gender.
  Widget _buildGenderDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColours.textFieldBackgroundColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: DropdownButtonFormField<String>(
        value: _selectedGender,
        decoration: const InputDecoration(
          border: InputBorder.none,
        ),
        hint: const Text("Gender"),
        items: ["Male", "Female", "Other"]
            .map((gender) => DropdownMenuItem(
                  value: gender,
                  child: Text(gender),
                ))
            .toList(),
        onChanged: (value) {
          setState(() {
            _selectedGender = value;
          });
        },
      ),
    );
  }

  /// Builds the save button for saving the entered personal information.
  ///
  /// The button updates the user model and navigates to the personal profile page.
  Widget _buildSaveButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
          onPressed: () {
            // Update user information in the user model.
            user.updateFirstName(_nameController.text);
            user.updateSurname(_surnameController.text);
            user.updateDob(_dobController.text);
            user.updateGender(_selectedGender!);

            // Navigate back to the personal profile page.
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => PersonalProfilePage(),
              ),
            );
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
}
