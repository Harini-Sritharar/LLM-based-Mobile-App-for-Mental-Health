import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:llm_based_sat_app/theme/app_colours.dart';
import 'package:llm_based_sat_app/widgets/custom_app_bar.dart';
import '../widgets/custom_button.dart';
import '../widgets/main_layout.dart';

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
              const CustomAppBar(title: "Personal Profile"),
              const SizedBox(height: 10),
              const Text(
                "Edit your Personal Profile",
                style: TextStyle(
                    fontSize: 15, color: AppColours.primaryGreyTextColor),
              ),
              const SizedBox(height: 20),
              _buildProfileOption(context, "Personal Info"),
              _buildProfileOption(context, "Contact Details"),
              _buildProfileOption(context, "Profile Picture"),
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

  // Helper function to build menu items in the edit profile page.
  // Takes in context and menu item name as parameters
  Widget _buildProfileOption(BuildContext context, String title) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
            fontSize: 17, color: AppColours.secondaryBlueTextColor),
      ),
      trailing: const Icon(Icons.arrow_forward_ios,
          size: 20, color: AppColours.forwardArrowColor),
      onTap: () {
        // Add navigation logic if required
      },
    );
  }
}
