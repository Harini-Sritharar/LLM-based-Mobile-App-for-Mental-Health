import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EditProfilePage extends StatelessWidget {
  static const Color primaryTextColor = Color(0xFF687078);
  static const Color secondaryTextColor = Color(0xFF123659);
  static const Color primaryButtonColor = Color(0xFF2F4A79);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
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
              colorFilter: ColorFilter.mode(primaryTextColor, BlendMode.srcIn),
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: SvgPicture.asset(
              'assets/icons/profile.svg',
              width: 28,
              height: 28,
              colorFilter: ColorFilter.mode(primaryTextColor, BlendMode.srcIn),
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
      padding: EdgeInsets.symmetric(
          horizontal: 10), // Adds 10px padding on both sides
      child: SizedBox(
        width: double.infinity, // Full width minus padding
        height: 50, // Adjust button height for better proportion
        child: ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF1C548C), // Button color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25), // Rounded button
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center, // Center text + icon
            children: [
              SvgPicture.asset(
                'assets/icons/back_icon.svg', // Using back_icon.svg
                width: 30,
                height: 30,
              ),
              SizedBox(width: 10), // Space between icon and text
              Text("Back", style: TextStyle(fontSize: 18, color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}
