import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final DateTime timestamp;
  final VoidCallback? onTap;

  const NotificationItem({
    Key? key,
    required this.icon,
    required this.title,
    required this.description,
    required this.timestamp,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Trigger the onTap action when tapped
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Color(0xFFF2F9FF), // Light blue background
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Color(0xFF1C548C)), // Border color
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Color(0xFFCEDFF2),
              child: Icon(icon, color: Color(0xFF1C548C)),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 22,
                      fontFamily: 'Roboto',
                      color: Color(0xFF062240),
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    "${DateFormat('dd MMM yyyy, hh:mm a').format(timestamp)}", // Only show timestamp here
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
