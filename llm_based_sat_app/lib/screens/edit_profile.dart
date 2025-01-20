import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:llm_based_sat_app/screens/contact_details_page.dart';
import 'package:llm_based_sat_app/screens/personal_info_page.dart';
import 'package:llm_based_sat_app/screens/upload_profile_picture_page.dart';
import 'package:llm_based_sat_app/theme/app_colours.dart';
import 'package:llm_based_sat_app/widgets/custom_app_bar.dart';
import '../widgets/custom_button.dart';
import '../widgets/main_layout.dart';
import '../widgets/menu_item.dart';

class EditProfilePage extends StatelessWidget {
  final Function(int) onItemTapped; // Receive function to update navbar index
  final int selectedIndex; // Keep track of selected index

  const EditProfilePage(
      {super.key, required this.onItemTapped, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      selectedIndex: selectedIndex,
      body: Container(
        color: Colors.white, // Set background color to white
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomAppBar(
                  title: "Personal Profile",
                  onItemTapped: onItemTapped,
                  selectedIndex: selectedIndex),
              const SizedBox(height: 10),
              const Text(
                "Edit your Personal Profile",
                style: TextStyle(
                    fontSize: 15, color: AppColours.primaryGreyTextColor),
              ),
              const SizedBox(height: 20),
              // Use MenuItem widget here
              MenuItem(
                title: "Personal Info",
                color: AppColours.secondaryBlueTextColor,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PersonalInfoPage(
                          onItemTapped: onItemTapped,
                          selectedIndex: selectedIndex),
                    ),
                  );
                  // Add navigation logic for Personal Info
                },
              ),
              MenuItem(
                title: "Contact Details",
                color: AppColours.secondaryBlueTextColor,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ContactDetailsPage(
                          onItemTapped: onItemTapped,
                          selectedIndex: selectedIndex),
                    ),
                  );
                  // Add navigation logic for Contact Details
                },
              ),
              MenuItem(
                title: "Profile Picture",
                color: AppColours.secondaryBlueTextColor,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UploadProfilePicturePage(
                          onItemTapped: onItemTapped,
                          selectedIndex: selectedIndex),
                    ),
                  );
                  // Add navigation logic for Profile Picture
                },
              ),
              const SizedBox(height: 40),
              CustomButton(
                buttonText: "Back",
                onPress: () => Navigator.pop(context),
                leftArrowPresent: true,
                rightArrowPresent: false,
                textColor: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
