import 'package:flutter/material.dart';
import 'package:llm_based_sat_app/widgets/custom_app_bar.dart';
import 'package:llm_based_sat_app/widgets/main_layout.dart';
import 'package:llm_based_sat_app/widgets/notification_widgets/notification_item.dart';
import 'package:llm_based_sat_app/widgets/bottom_nav_bar.dart';
import 'package:llm_based_sat_app/widgets/notification_widgets/notification_item.dart';

class NotificationsPage extends StatefulWidget {
  final Function(int) onItemTapped;
  final int selectedIndex;

  const NotificationsPage({
    Key? key,
    required this.onItemTapped,
    required this.selectedIndex,
  }) : super(key: key);

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  // Sample notifications data
  final List<Map<String, String>> notifications = [
    {
      "icon": "assignment",
      "title": "Incomplete task",
      "description": "Start the task now.",
    },
    {
      "icon": "timer",
      "title": "Practice Time Remaining",
      "description": "Start exercise A of Self-attachment.",
    },
    {
      "icon": "menu_book",
      "title": "New Course Available!",
      "description": "Start now to boost your creativity.",
    },
    {
      "icon": "star",
      "title": "Subscription",
      "description": "Your subscription has been renewed.",
    },
    {
      "icon": "trending_up",
      "title": "Check your Score",
      "description": "There was a change in your score.",
    }
  ];

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      selectedIndex: widget.selectedIndex,
      body: Scaffold(
        appBar: CustomAppBar(
          title: "Notifications",
          onItemTapped: widget.onItemTapped,
          selectedIndex: widget.selectedIndex,
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              children: notifications.map((notification) {
                IconData iconData;
                switch (notification["icon"]) {
                  case "assignment":
                    iconData = Icons.assignment;
                    break;
                  case "timer":
                    iconData = Icons.timer;
                    break;
                  case "menu_book":
                    iconData = Icons.menu_book;
                    break;
                  case "star":
                    iconData = Icons.star;
                    break;
                  case "trending_up":
                    iconData = Icons.trending_up;
                    break;
                  default:
                    iconData = Icons.notifications;
                }
                return NotificationItem(
                  icon: iconData,
                  title: notification["title"]!,
                  description: notification["description"]!,
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}