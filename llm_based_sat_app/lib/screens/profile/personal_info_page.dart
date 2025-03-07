/// This file defines the `PersonalInfoPage` widget, which allows users to
/// input and update their personal information, including name, surname,
/// date of birth, and gender. The updated information can be saved to the database.

import 'package:flutter/material.dart';
import 'package:llm_based_sat_app/theme/app_colours.dart';
import 'package:llm_based_sat_app/firebase/firebase_profile.dart';
import 'package:llm_based_sat_app/widgets/auth_widgets/text_input_field.dart';
import 'package:llm_based_sat_app/widgets/custom_app_bar.dart';
import 'package:llm_based_sat_app/widgets/custom_button.dart';
import 'package:provider/provider.dart';
import '../../utils/profile_notifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PersonalInfoPage extends StatefulWidget {
  final Function(int) onItemTapped;
  final int selectedIndex;
  final VoidCallback onCompletion;
  // Optional test parameters
  @visibleForTesting
  final FirebaseAuth? authOverride;
  @visibleForTesting
  final FirebaseFirestore? firestoreOverride;
  @visibleForTesting
  final updatePersonalInfoOverride;

  const PersonalInfoPage({
    Key? key,
    required this.onItemTapped,
    required this.selectedIndex,
    required this.onCompletion,
    this.authOverride,
    this.firestoreOverride,
    this.updatePersonalInfoOverride,
  }) : super(key: key);

  @override
  _PersonalInfoPageState createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  // Use the injected instances or fall back to real ones
  FirebaseAuth get _auth => widget.authOverride ?? FirebaseAuth.instance;
  FirebaseFirestore get _firestore =>
      widget.firestoreOverride ?? FirebaseFirestore.instance;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot doc =
          await _firestore.collection('Profile').doc(user.uid).get();
      if (!mounted) return;

      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        setState(() {
          _nameController.text = data['firstname'] ?? '';
          _surnameController.text = data['surname'] ?? '';
          _dobController.text = data['dob'] ?? '';
          _genderController.text = data['gender'] ?? '';
        });
      }
    }
  }

  String? _validateNotEmpty(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName cannot be empty';
    }
    return null;
  }

  void _savePersonalInfo() {
    if (widget.updatePersonalInfoOverride != null) {
      widget.updatePersonalInfoOverride!(
          _nameController.text.trim(),
          _surnameController.text.trim(),
          _dobController.text.trim(),
          _genderController.text.trim());
      return;
    }
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill in all fields before saving."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    updatePersonalInfo(
      _nameController.text.trim(),
      _surnameController.text.trim(),
      _dobController.text.trim(),
      _genderController.text.trim(),
    );

    Provider.of<ProfileNotifier>(context, listen: false).notifyProfileUpdated();
    widget.onCompletion();
    Navigator.pop(context);
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
                      style: TextStyle(
                          fontSize: 28, color: AppColours.neutralGreyMinusOne),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Complete your Personal Information",
                      style: TextStyle(
                          fontSize: 15, color: AppColours.neutralGreyMinusOne),
                    ),
                    const SizedBox(height: 40),
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
                    TextInputField(
                      label: "Gender",
                      icon: Icons.person_outline,
                      isPassword: false,
                      controller: _genderController,
                      validator: (value) => _validateNotEmpty(value, "Gender"),
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
