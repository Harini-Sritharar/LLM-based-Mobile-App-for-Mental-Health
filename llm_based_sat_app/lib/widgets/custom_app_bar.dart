import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:llm_based_sat_app/theme/app_colours.dart';
import '../screens/profile_page.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color textColor;
  final VoidCallback? onBack;
  final Function(int) onItemTapped; // Function to update navbar index
  final int selectedIndex; // Current selected index
  final bool backButton; // Optional parameter to control back button visibility

  const CustomAppBar({
    Key? key,
    required this.title,
    this.textColor = AppColours.neutralGreyMinusOne, // Default text color
    this.onBack,
    required this.onItemTapped,
    required this.selectedIndex,
    this.backButton = true, // Default value is true
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
      leading: backButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed:
                  onBack ?? () => Navigator.pop(context), // Default behavior
            )
          : null, // No back button if backButton is false
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
            // Check if the current route is ProfilePage
            if (ModalRoute.of(context)?.settings.name != '/profile') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage(
                    onItemTapped: onItemTapped,
                    selectedIndex: selectedIndex,
                  ),
                  settings: const RouteSettings(name: '/profile'), // Assign a name to the route
                ),
              );
            }
          },
        ),
      ],
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
