/// This file defines the `PersonalInfoPage` widget, which allows users to
/// input and update their personal information, including name, surname,
/// date of birth, and gender. The updated information can be saved to the database.

import 'package:flutter/material.dart';
import 'package:llm_based_sat_app/theme/app_colours.dart';
import 'package:llm_based_sat_app/firebase_profile.dart';
import 'package:llm_based_sat_app/widgets/auth_widgets/text_input_field.dart';
import 'package:llm_based_sat_app/theme/app_colours.dart';
import 'package:llm_based_sat_app/widgets/custom_app_bar.dart';
import 'package:llm_based_sat_app/widgets/custom_button.dart';
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
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();

  // Selected gender value.
  String? _selectedGender;

  // @override
  // void dispose() {
  //   _nameController.dispose();
  //   _surnameController.dispose();
  //   _dobController.dispose();
  //   super.dispose();
  // }

  String? _validateNotEmpty(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName cannot be empty';
    }
    return null;
  }

  void _savePersonalInfo() {
    if (_formKey.currentState!.validate()) {
      // Save data to the database
      updatePersonalInfo(
        _nameController.text,
        _surnameController.text,
        _dobController.text,
        _selectedGender!,
      );

      // Navigate back
      Navigator.pop(context);
    }
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
              const SizedBox(height: 120),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Personal Info",
                      style: TextStyle(fontSize: 22, color: AppColours.neutralGreyMinusOne),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Complete your Personal Information",
                      style: TextStyle(fontSize: 16, color: AppColours.neutralGreyMinusOne),
                    ),
                    const SizedBox(height: 20),
                    TextInputField(
                      label: "Name",
                      icon: Icons.person,
                      isPassword: false,
                      controller: _nameController,
                      validator: (value) => _validateNotEmpty(value, "Name"),
                    ),
                    const SizedBox(height: 10),
                    TextInputField(
                      label: "Surname",
                      icon: Icons.person,
                      isPassword: false,
                      controller: _surnameController,
                      validator: (value) => _validateNotEmpty(value, "Surname"),
                    ),
                    const SizedBox(height: 10),
                    // Date of Birth
                    GestureDetector(
                      onTap: () async {
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
                      child: AbsorbPointer(
                        child: TextInputField(
                          label: "Date of Birth",
                          icon: Icons.calendar_today,
                          isPassword: false,
                          controller: _dobController,
                          validator: (value) =>
                              _validateNotEmpty(value, "Date of Birth"),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: _selectedGender,
                      decoration: InputDecoration(
                        labelText: "Gender",
                        filled: true,
                        fillColor: const Color(0xFFD0E0F0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      hint: const Text("Select Gender"),
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
                      validator: (value) {
                        if (value == null) {
                          return "Gender cannot be empty";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 40),
                    CustomButton(
                      buttonText: "Save",
                      onPress: _savePersonalInfo,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
