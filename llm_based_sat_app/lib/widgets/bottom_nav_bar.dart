import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const BottomNavBar(
      {super.key, required this.selectedIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.grey.shade300,
            width: 1, // Top border for contrast
          ),
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: onTap,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black, // Active tab color
        unselectedItemColor: Colors.grey,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        type: BottomNavigationBarType.fixed, // Ensures consistent spacing
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/people.svg',
              height: 24,
              width: 24,
              color: selectedIndex == 0 ? Colors.black : Colors.grey,
            ),
            label: 'Community',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/calendar.svg',
              height: 24,
              width: 24,
              color: selectedIndex == 1 ? Colors.black : Colors.grey,
            ),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/people.svg',
              height: 24,
              width: 24,
              color: selectedIndex == 2 ? Colors.black : Colors.grey,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/diagram.svg',
              height: 24,
              width: 24,
              color: selectedIndex == 3 ? Colors.black : Colors.grey,
            ),
            label: 'Score',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/book.svg',
              height: 24,
              width: 24,
              color: selectedIndex == 4 ? Colors.black : Colors.grey,
            ),
            label: 'Courses',
          ),
        ],
      ),
    );
  }
}
