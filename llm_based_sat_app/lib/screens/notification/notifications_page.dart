import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:llm_based_sat_app/screens/course/courses.dart';
import 'package:llm_based_sat_app/screens/home_page.dart';
import 'package:llm_based_sat_app/screens/payments/manage_plan_page.dart';
import 'package:llm_based_sat_app/screens/score/score_page.dart';
import 'package:llm_based_sat_app/widgets/custom_app_bar.dart';
import 'package:llm_based_sat_app/widgets/main_layout.dart';
import 'package:llm_based_sat_app/widgets/notification_widgets/notification_item.dart';
import 'package:llm_based_sat_app/firebase/firebase_notifications.dart';

// Import navigatorKey from main.dart
import '../../main.dart';

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
  final FirebaseNotifications _firebaseNotifications = FirebaseNotifications();

  /// Handles tapping a notification: Marks as read and navigates to the correct page.
  Future<void> _handleNotificationTap(String type, String notificationId) async {
    if (!mounted) return; // Ensure widget is still active before navigation

    Widget targetPage;
    switch (type) {
      case "score_update":
        targetPage = ScorePage(onItemTapped: widget.onItemTapped, selectedIndex: widget.selectedIndex);
        break;
      case "session_reminder":
        targetPage = MainScreen();
        break;
      case "practice_reminder":
        targetPage = Courses(onItemTapped: widget.onItemTapped, selectedIndex: widget.selectedIndex);
        break;
      case "subscription":
        targetPage = ManagePlanPage(onItemTapped: widget.onItemTapped, selectedIndex: widget.selectedIndex);
        break;
      default:
        print("Unknown notification type: $type");
        return;
    }

    // Mark the notification as read before navigating
    await _firebaseNotifications.markNotificationAsRead(notificationId);

    // Use navigatorKey to ensure safe navigation
    navigatorKey.currentState?.push(
      MaterialPageRoute(builder: (context) => targetPage),
    );
  }

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
          child: StreamBuilder<QuerySnapshot>(
            stream: _firebaseNotifications.getUnreadNotificationsStream(), // Fetch only unread notifications
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text("Error fetching notifications."));
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(child: Text("No unread notifications."));
              }

              var notifications = snapshot.data!.docs;

              return ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  var notification = notifications[index];
                  var data = notification.data() as Map<String, dynamic>?;

                  if (data == null) return SizedBox.shrink(); // Skip if data is missing

                  String? type = data["type"];
                  String? title = data["title"] ?? "Notification";
                  String? message = data["message"] ?? "";
                  String notificationId = notification.id;

                  // Map notification type to icon
                  IconData iconData;
                  switch (type) {
                    case "session_reminder":
                      iconData = Icons.assignment;
                      break;
                    case "time_alert":
                      iconData = Icons.timer;
                      break;
                    case "new_course":
                      iconData = Icons.menu_book;
                      break;
                    case "subscription":
                      iconData = Icons.star;
                      break;
                    case "score_update":
                      iconData = Icons.trending_up;
                      break;
                    default:
                      iconData = Icons.notifications;
                  }

                  return NotificationItem(
                    icon: iconData,
                    title: title ?? "Notification",
                    description: message ?? "",
                    onTap: () => _handleNotificationTap(type ?? "", notificationId),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
