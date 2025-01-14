import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:llm_based_sat_app/screens/sign_in_page.dart';
import 'edit_profile.dart'; // Import the new page

class ProfilePage extends StatelessWidget {
  static const Color primaryTextColor = Color(0xFF687078);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Profile Settings",
          style: TextStyle(color: primaryTextColor),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
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
        elevation: 0,
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          CircleAvatar(
            radius: 50,
            backgroundColor: const Color(0xFFCEDFF2),
            child: Icon(Icons.person, size: 80, color: Color(0xFFF2F9FF)),
          ),
          SizedBox(height: 10),
          Text(
            'Neophytos Polydorou',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: primaryTextColor,
            ),
          ),
          Text(
            'neophytos@invincimind.com',
            style: TextStyle(
              fontSize: 16,
              color: primaryTextColor,
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: ListView(
              children: [
                _buildMenuItem(
                    context, 'Edit Profile', 'assets/icons/user_edit.svg', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EditProfilePage()),
                  );
                }),
                _buildMenuItem(
                    context, 'Settings', 'assets/icons/setting-2.svg', () {}),
                _buildMenuItem(
                    context, 'Ultimate Goal', 'assets/icons/cup.svg', () {}),
                _buildMenuItem(context, 'Childhood photos',
                    'assets/icons/gallery.svg', () {}),
                _buildMenuItem(context, 'Payment Option',
                    'assets/icons/empty-wallet.svg', () {}),
                _buildMenuItem(
                    context, 'Invite Friends', 'assets/icons/send.svg', () {}),
                _buildMenuItem(context, 'Logout', 'assets/icons/logout.svg',
                    () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignInPage()),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
      BuildContext context, String title, dynamic icon, VoidCallback onTap) {
    return ListTile(
      leading: (icon is String)
          ? SvgPicture.asset(
              icon,
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(primaryTextColor, BlendMode.srcIn),
            )
          : Icon(icon, color: primaryTextColor),
      title: Text(
        title,
        style: TextStyle(fontSize: 18, color: primaryTextColor),
      ),
      trailing:
          Icon(Icons.arrow_forward_ios, size: 18, color: primaryTextColor),
      onTap: onTap, // Executes the navigation function
    );
  }
}
