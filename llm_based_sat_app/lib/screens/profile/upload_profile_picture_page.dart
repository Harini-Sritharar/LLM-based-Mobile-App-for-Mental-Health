import 'dart:io';

import 'package:flutter/material.dart';
import 'package:llm_based_sat_app/firebase/firebase_profile.dart';
import 'package:llm_based_sat_app/theme/app_colours.dart';
import 'package:llm_based_sat_app/widgets/auth_widgets/text_input_field.dart';
import 'package:llm_based_sat_app/widgets/custom_app_bar.dart';
import 'package:llm_based_sat_app/widgets/custom_button.dart';
import 'package:llm_based_sat_app/widgets/profile_widgets/image_picker.dart';

class UploadProfilePicturePage extends StatefulWidget {
  final Function(int) onItemTapped; // Receive function to update navbar index
  final int selectedIndex; // Keep track of selected index
  final VoidCallback onCompletion;

  const UploadProfilePicturePage(
      {Key? key,
      required this.onItemTapped,
      required this.selectedIndex,
      required this.onCompletion})
      : super(key: key);
  @override
  _UploadProfilePicturePageState createState() =>
      _UploadProfilePicturePageState();
}

class _UploadProfilePicturePageState extends State<UploadProfilePicturePage> {
  final TextEditingController _usernameController = TextEditingController();
  File? _selectedImage; // Holds the selected image
  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  void _handleImagePicked(File? image) {
    setState(() {
      _selectedImage = image;
    });
  }

  void _saveProfilePicture() {
    // Save the profile picture
    // Save the username
    // Navigate to the next page
    if (_selectedImage != null && _usernameController.text.isNotEmpty) {
      updateProfilePictureAndUsername(
          _selectedImage!, _usernameController.text);
      widget.onCompletion();
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
              CustomAppBar(
                  title: "Personal Profile",
                  onItemTapped: widget.onItemTapped,
                  selectedIndex: widget.selectedIndex),
              const SizedBox(height: 120),
              const Text(
                "Profile Picture",
                style: TextStyle(
                    fontSize: 28, color: AppColours.secondaryBlueTextColor),
              ),
              const SizedBox(height: 8),
              const Text(
                "Add a picture of yourself",
                style: TextStyle(
                    fontSize: 15, color: AppColours.primaryGreyTextColor),
              ),
              const SizedBox(height: 20),
              Center(
                  child: ImagePickerWidget(onImagePicked: _handleImagePicked)),
              const SizedBox(height: 20),
              TextInputField(
                  label: "Username",
                  icon: Icons.person,
                  isPassword: false,
                  controller: _usernameController),
              const SizedBox(height: 20),
              CustomButton(buttonText: "Save", onPress: _saveProfilePicture)
            ],
          ),
        ),
      ),
    );
  }
}
