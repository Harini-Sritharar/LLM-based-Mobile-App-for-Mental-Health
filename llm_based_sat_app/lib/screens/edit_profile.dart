import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // For handling SVG images
import 'package:llm_based_sat_app/screens/contact_details_page.dart';
import 'package:llm_based_sat_app/screens/personal_info_page.dart'; // Importing PersonalInfoPage screen
import 'package:llm_based_sat_app/screens/upload_profile_picture_page.dart';
import 'package:llm_based_sat_app/theme/app_colours.dart'; // Custom theme colors
import 'package:llm_based_sat_app/widgets/custom_app_bar.dart'; // Custom AppBar widget
import '../widgets/custom_button.dart'; // Custom button widget
import '../widgets/main_layout.dart'; // Main layout widget
import '../widgets/menu_item.dart'; // Reusable menu item widget

/// The `EditProfilePage` is a stateless widget that provides users with options
/// to edit their personal profile details. It includes navigation to specific
/// sections such as personal information, contact details, and profile picture.
///
/// This page utilizes a consistent layout and design by leveraging reusable
/// widgets such as `CustomAppBar`, `MenuItem`, and `CustomButton`.
///
/// Parameters:
/// - [onItemTapped]: A callback function to update the navigation bar index.
/// - [selectedIndex]: The currently selected navigation bar index.
///
/// This widget adheres to the [MainLayout], maintaining consistency with other
/// screens in the app.
class EditProfilePage extends StatelessWidget {
  // Callback function to handle bottom navigation updates
  final Function(int) onItemTapped;

  // Index of the currently selected navigation bar item
  final int selectedIndex;

  /// Constructor for `EditProfilePage`.
  ///
  /// Accepts the required parameters [onItemTapped] and [selectedIndex].
  const EditProfilePage({
    super.key,
    required this.onItemTapped,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      // Passing the selected navigation index to the MainLayout
      selectedIndex: selectedIndex,

      // The main body of the page
      body: Container(
        color: Colors.white, // Background color of the page
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 20), // Horizontal padding for consistent spacing
          child: Column(
            crossAxisAlignment: CrossAxisAlignment
                .start, // Aligns children to the start of the column
            children: [
              // Custom app bar at the top of the page
              CustomAppBar(
                title: "Personal Profile", // Title for the app bar
                onItemTapped:
                    onItemTapped, // Callback to update navigation index
                selectedIndex: selectedIndex, // Currently selected index
              ),

              const SizedBox(
                  height: 10), // Vertical spacing between app bar and title

              // Subtitle for the page
              const Text(
                "Edit your Personal Profile",
                style: TextStyle(
                  fontSize: 15, // Font size for the text
                  color: AppColours
                      .primaryGreyTextColor, // Grey text color from theme
                ),
              ),

              const SizedBox(height: 20), // Vertical spacing before menu items

              // Menu item for navigating to the Personal Info page
              MenuItem(
                title: "Personal Info", // Title displayed in the menu item
                color:
                    AppColours.secondaryBlueTextColor, // Text color from theme
                onTap: () {
                  // Navigation to PersonalInfoPage
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PersonalInfoPage(
                          
                        onItemTapped: onItemTapped,
                         
                        selectedIndex: selectedIndex,
                      ),
                    ),
                  );
                },
              ),

              // Menu item for navigating to Contact Details
              MenuItem(
                title: "Contact Details", // Title displayed in the menu item
                color:
                    AppColours.secondaryBlueTextColor, // Text color from theme
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ContactDetailsPage(
                          onItemTapped: onItemTapped,
                          selectedIndex: selectedIndex),
                    ),
                  );
                  // TODO: Implement navigation logic for Contact Details
                },
              ),

              // Menu item for navigating to Profile Picture settings
              MenuItem(
                title: "Profile Picture", // Title displayed in the menu item
                color:
                    AppColours.secondaryBlueTextColor, // Text color from theme
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UploadProfilePicturePage(
                          onItemTapped: onItemTapped,
                          selectedIndex: selectedIndex),
                    ),
                  );
                  // TODO: Implement navigation logic for Profile Picture
                },
              ),

              const SizedBox(
                  height: 40), // Vertical spacing before the back button

              // Back button to return to the previous screen
              CustomButton(
                buttonText: "Back", // Text displayed on the button
                onPress: () => Navigator.pop(
                    context), // Closes the current screen and returns to the previous one
                leftArrowPresent:
                    true, // Displays a left-facing arrow on the button
                rightArrowPresent: false, // No right-facing arrow on the button
                textColor: Colors.white, // Text color for the button
              ),
            ],
          ),
        ),
      ),
    );
  }
}
