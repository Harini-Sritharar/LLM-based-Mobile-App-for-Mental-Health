import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:llm_based_sat_app/widgets/custom_app_bar.dart';
import '../widgets/main_layout.dart';

class EditProfilePage extends StatelessWidget {
  static const Color primaryTextColor = Color(0xFF687078);
  static const Color secondaryTextColor = Color(0xFF123659);
  static const Color primaryButtonColor = Color(0xFF2F4A79);

  final Function(int) onItemTapped; // Receive function to update navbar index
  final int selectedIndex; // Keep track of selected index

  const EditProfilePage(
      {super.key, required this.onItemTapped, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      selectedIndex: selectedIndex,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomAppBar(title: "Personal Profile"),
            const SizedBox(height: 10),
            const Text(
              "Edit your Personal Profile",
              style: TextStyle(fontSize: 16, color: primaryTextColor),
            ),
            const SizedBox(height: 20),
            _buildProfileOption(context, "Personal Info"),
            _buildProfileOption(context, "Contact Details"),
            _buildProfileOption(context, "Profile Picture"),
            const SizedBox(height: 40),
            _buildBackButton(context),
          ],
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
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: secondaryTextColor),
      ),
      trailing: const Icon(Icons.arrow_forward_ios,
          size: 20, color: Color(0xFF1C548C)),
      onTap: () {
        // Add navigation logic if required
      },
    );
  }

  // Helper function to build the back button - once pressed will go back to the main profile page.
  // Takes in context as parameter
  Widget _buildBackButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1C548C),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/icons/back_icon.svg',
                width: 30,
                height: 30,
              ),
              const SizedBox(width: 10),
              const Text("Back",
                  style: TextStyle(fontSize: 18, color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}
