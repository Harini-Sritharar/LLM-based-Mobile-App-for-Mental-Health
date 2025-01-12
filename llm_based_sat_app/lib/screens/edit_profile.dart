import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/main_layout.dart'; // Import MainLayout

class EditProfilePage extends StatelessWidget {
  static const Color primaryTextColor = Color(0xFF687078);
  static const Color secondaryTextColor = Color(0xFF123659);
  static const Color primaryButtonColor = Color(0xFF2F4A79);

  final Function(int) onItemTapped; // Receive function to update navbar index
  final int selectedIndex; // Keep track of selected index

  EditProfilePage({required this.onItemTapped, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      selectedIndex: selectedIndex,
      onItemTapped: onItemTapped,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppBar(
              title: Text(
                "Personal Profile",
                style: TextStyle(color: primaryTextColor, fontSize: 20),
              ),
              centerTitle: true,
              backgroundColor: Colors.white,
              elevation: 0,
              iconTheme: IconThemeData(color: primaryTextColor),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
              actions: [
                IconButton(
                  icon: SvgPicture.asset(
                    'assets/icons/notification.svg',
                    width: 28,
                    height: 28,
                    colorFilter:
                        ColorFilter.mode(primaryTextColor, BlendMode.srcIn),
                  ),
                  onPressed: () {},
                ),
                IconButton(
                  icon: SvgPicture.asset(
                    'assets/icons/profile.svg',
                    width: 28,
                    height: 28,
                    colorFilter:
                        ColorFilter.mode(primaryTextColor, BlendMode.srcIn),
                  ),
                  onPressed: () {},
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              "Edit your Personal Profile",
              style: TextStyle(fontSize: 16, color: primaryTextColor),
            ),
            SizedBox(height: 20),
            _buildProfileOption(context, "Personal Info", secondaryTextColor),
            _buildProfileOption(context, "Contact Details", secondaryTextColor),
            _buildProfileOption(context, "Profile Picture", secondaryTextColor),
            SizedBox(height: 40),
            _buildBackButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption(
      BuildContext context, String title, Color secondaryTextColor) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: secondaryTextColor),
      ),
      trailing:
          Icon(Icons.arrow_forward_ios, size: 20, color: Color(0xFF1C548C)),
      onTap: () {
        // Add navigation logic if required
      },
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF1C548C),
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
              SizedBox(width: 10),
              Text("Back", style: TextStyle(fontSize: 18, color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}
