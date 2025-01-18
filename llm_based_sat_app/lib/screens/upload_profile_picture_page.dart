import 'package:flutter/material.dart';
import 'package:llm_based_sat_app/screens/childhood_photos_page.dart';
import 'package:llm_based_sat_app/widgets/auth_widgets/text_input_field.dart';
import 'package:llm_based_sat_app/widgets/custom_button.dart';

class UploadProfilePicturePage extends StatefulWidget {
  @override
  _UploadProfilePicturePageState createState() =>
      _UploadProfilePicturePageState();
}

class _UploadProfilePicturePageState extends State<UploadProfilePicturePage> {
  final TextEditingController _usernameController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
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
              const SizedBox(height: 10),
              const Text(
                "Profile Picture",
                style: TextStyle(fontSize: 22, color: Color(0xFF687078)),
              ),
              const SizedBox(height: 8),
              const Text(
                "Add a picture of yourself",
                style: TextStyle(fontSize: 16, color: Color(0xFF687078)),
              ),
              const SizedBox(height: 20),
              // TO DO : add the image picker (image_picker 1.1.2 ???)
              TextInputField(
                  label: "Username",
                  icon: Icons.person,
                  isPassword: false,
                  controller: _usernameController),
              CustomButton(
                  buttonText: "Save",
                  onPress: () => {
                        // TODO : Implement the save function
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => ChildhoodPhotosPage())
                        // Link to upload_profile_page
                      })
            ],
          ),
        ),
      ),
    );
  }
}
