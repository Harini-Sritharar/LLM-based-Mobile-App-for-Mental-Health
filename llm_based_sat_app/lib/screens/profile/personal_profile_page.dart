import 'package:flutter/material.dart';
import 'package:llm_based_sat_app/firebase/firebase_profile.dart';
import 'package:llm_based_sat_app/main.dart';
import 'package:llm_based_sat_app/screens/profile/childhood_photos_page.dart';
import 'package:llm_based_sat_app/screens/profile/personal_info_page.dart';
import 'package:llm_based_sat_app/screens/profile/upload_profile_picture_page.dart';

import '../../widgets/auth_widgets/circular_checkbox.dart';
import '../../widgets/custom_button.dart';
import 'contact_details_page.dart';

class PersonalProfilePage extends StatefulWidget {
  @override
  _PersonalProfilePageState createState() => _PersonalProfilePageState();
}

class _PersonalProfilePageState extends State<PersonalProfilePage> {
  bool isVerified = false;
  //User_ user = User_();

  // Completion flags
  bool _isPersonalInfoComplete = false;
  bool _isContactDetailsComplete = false;
  bool _isProfilePictureComplete = false;

  @override
  void initState() {
    super.initState();
    _fetchCompletionStatus();
  }

  Future<void> _fetchCompletionStatus() async {
    bool personalInfoComplete = await isPersonalInfoComplete();
    bool contactDetailsComplete = await isContactDetailsComplete();
    bool profilePictureComplete = await isProfilePictureComplete();

    setState(() {
      _isPersonalInfoComplete = personalInfoComplete;
      _isContactDetailsComplete = contactDetailsComplete;
      _isProfilePictureComplete = profilePictureComplete;
    });
  }

  void _finishProfile() {
    // Navigate to the Main Screen upon finishing profile
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => MainScreen()));
  }

  @override
  build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Personal Profile",
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                  height:
                      80), // Adjust this value to move the content downwards
              const Text(
                "Personal Profile",
                style: TextStyle(
                  color: Color(0xFF123659),
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                "Complete your Personal Profile",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 50),
              ProfileStepItem(
                title: "Personal Info",
                isCompleted: _isPersonalInfoComplete,
                onTap: () {
                  // Navigate to Personal Info Screen
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PersonalInfoPage(
                                onItemTapped: (int) {},
                                selectedIndex: 2,
                              )));
                  _fetchCompletionStatus();
                },
              ),
              const SizedBox(height: 24),
              ProfileStepItem(
                title: "Contact Details",
                isCompleted: _isContactDetailsComplete,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ContactDetailsPage(
                                onItemTapped: (x) {},
                                selectedIndex: 2,
                              )));
                  // Navigate to Contact Details Screen
                  _fetchCompletionStatus();
                },
              ),
              const SizedBox(height: 24),
              ProfileStepItem(
                title: "Profile Picture",
                isCompleted: _isProfilePictureComplete,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UploadProfilePicturePage(
                                onItemTapped: (int) {},
                                selectedIndex: 2,
                              )));

                  // Navigate to Profile Picture Screen
                  _fetchCompletionStatus();
                },
              ),
              const SizedBox(height: 24),
              ProfileStepItem(
                title: "Childhood Photos",
                isCompleted: false,
                onTap: () {
                  // Navigate to Childhood Photos Screen
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChildhoodPhotosPage(
                                onItemTapped: (int) {},
                                selectedIndex: 2,
                              )));
                },
              ),
              const SizedBox(height: 50), // Spacer before the checkbox
              Row(
                children: [
                  CircularCheckbox(
                    initialValue: isVerified,
                    onChanged: (bool value) {
                      setState(() {
                        isVerified = value;
                      });
                    },
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'I verify that my info are correct',
                    style: TextStyle(
                      color: Color(0xFF687078),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Center(
                child: CustomButton(
                  buttonText: "Finish",
                  onPress: _finishProfile,
                  rightArrowPresent: false,
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileStepItem extends StatelessWidget {
  final String title;
  final bool isCompleted;
  final VoidCallback onTap;

  const ProfileStepItem({
    required this.title,
    required this.isCompleted,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF123659),
              fontSize: 18,
              fontWeight: FontWeight.w400,
            ),
          ),
          isCompleted
              ? Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFF125932)),
                    color: Color(0xFFCEF2DE),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Color(0xFF125932),
                    size: 20,
                  ),
                )
              : Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(
                    Icons.arrow_forward_ios,
                    color: Color(0xFF123659),
                    size: 18,
                  ),
                ),
        ],
      ),
    );
  }
}
