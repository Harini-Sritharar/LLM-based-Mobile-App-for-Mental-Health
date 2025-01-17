import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../screens/profile_page.dart';


class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color textColor;
  final VoidCallback? onBack;
  final Function(int) onItemTapped; // Function to update navbar index
  final int selectedIndex; // Current selected index

  const CustomAppBar({
    Key? key,
    required this.title,
    this.textColor = const Color(0xFF687078), // Default text color
    this.onBack,
    required this.onItemTapped,
    required this.selectedIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(color: textColor),
      ),
      centerTitle: true,
      backgroundColor: Colors.transparent, // Keep the background clean
      iconTheme: IconThemeData(color: textColor),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: onBack ?? () => Navigator.pop(context), // Default behavior
      ),
      actions: [
        IconButton(
          icon: SvgPicture.asset(
            'assets/icons/notification.svg',
            width: 28,
            height: 28,
            colorFilter: ColorFilter.mode(textColor, BlendMode.srcIn),
          ),
          onPressed: () {}, // Define action if needed
        ),
        IconButton(
          icon: SvgPicture.asset(
            'assets/icons/profile.svg',
            width: 28,
            height: 28,
            colorFilter: ColorFilter.mode(textColor, BlendMode.srcIn),
          ),
          onPressed: () {
            // Navigate to the profile page with parameters
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfilePage(
                  onItemTapped: onItemTapped,
                  selectedIndex: selectedIndex,
                ),
              ),
            );
          },
        ),
      ],
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}