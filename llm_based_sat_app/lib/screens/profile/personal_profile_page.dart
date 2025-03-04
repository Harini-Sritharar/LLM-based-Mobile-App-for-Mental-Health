import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:llm_based_sat_app/firebase/firebase_profile.dart';
import 'package:llm_based_sat_app/main.dart';
import 'package:llm_based_sat_app/screens/profile/childhood_photos_page.dart';
import 'package:llm_based_sat_app/screens/profile/contact_details_page.dart';
import 'package:llm_based_sat_app/screens/profile/personal_info_page.dart';
import 'package:llm_based_sat_app/screens/profile/upload_profile_picture_page.dart';

import '../../widgets/auth_widgets/circular_checkbox.dart';
import '../../widgets/custom_button.dart';

class PersonalProfilePage extends StatefulWidget {
  @override
  _PersonalProfilePageState createState() => _PersonalProfilePageState();
}

class _PersonalProfilePageState extends State<PersonalProfilePage> {
  bool isVerified = false;

  // Completion flags
  bool _isPersonalInfoComplete = false;
  bool _isContactDetailsComplete = false;
  bool _isProfilePictureComplete = false;
  bool _isChildhoodPhotosComplete = false;

  void _markAsComplete(String section) {
    setState(() {
      if (section == "Personal Info") _isPersonalInfoComplete = true;
      if (section == "Contact Details") _isContactDetailsComplete = true;
      if (section == "Profile Picture") _isProfilePictureComplete = true;
      if (section == "Childhood Photos") _isChildhoodPhotosComplete = true;
    });
  }

  Future<void> _finishProfile() async {
    if (!_isPersonalInfoComplete || !_isContactDetailsComplete) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              "Please complete Personal Info and Contact Details before finishing."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (!isVerified) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please verify that your information is correct."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
    );
    
    try {
      // Ensure Firebase Auth is ready
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception("User not authenticated");
      }
      
      String uid = currentUser.uid;
      print("Current user UID: $uid");
      
      // Mark profile as completed in Firestore
      await FirebaseFirestore.instance
          .collection('Profile')
          .doc(uid)
          .set({
            'profileCompleted': true,
            'lastUpdated': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
      
      // Force token refresh to ensure data is consistent
      await currentUser.getIdToken(true);
      
      // Longer delay for Firestore operations to complete and propagate
      await Future.delayed(const Duration(milliseconds: 1500));
      
      // Remove loading indicator
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
      
      // Navigate to Main Screen
      Navigator.pushAndRemoveUntil(
        context, 
        MaterialPageRoute(builder: (context) => MainScreen()),
        (route) => false
      );
    } catch (e) {
      // Remove loading indicator
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error completing profile: ${e.toString()}"),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 5),
        ),
      );
      print("Error in _finishProfile: $e");
    }
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
                                onCompletion: () =>
                                    _markAsComplete("Personal Info"),
                              )));
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
                                onCompletion: () =>
                                    _markAsComplete("Contact Details"),
                              )));
                  // Navigate to Contact Details Screen
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
                                onCompletion: () =>
                                    _markAsComplete("Profile Picture"),
                              )));

                  // Navigate to Profile Picture Screen
                },
              ),
              const SizedBox(height: 24),
              ProfileStepItem(
                title: "Childhood Photos",
                isCompleted: _isChildhoodPhotosComplete,
                onTap: () {
                  // Navigate to Childhood Photos Screen
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChildhoodPhotosPage(
                                onItemTapped: (int) {},
                                selectedIndex: 2,
                                onCompletion: () =>
                                    _markAsComplete("Childhood Photos"),
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
