import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color textColor;
  final VoidCallback? onBack;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.textColor = const Color(0xFF687078), // Default text color
    this.onBack,
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
          onPressed: () {}, // Define action if needed
        ),
      ],
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
