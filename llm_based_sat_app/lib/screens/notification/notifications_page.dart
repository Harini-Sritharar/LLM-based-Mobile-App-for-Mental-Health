import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
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
    if (!mounted) return;

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

    await _firebaseNotifications.markNotificationAsRead(notificationId);
    navigatorKey.currentState?.push(MaterialPageRoute(builder: (context) => targetPage));
  }

  /// Deletes a notification from Firestore.
  Future<void> _deleteNotification(String notificationId) async {
    try {
      await _firebaseNotifications.markNotificationAsRead(notificationId);
      print("Notification $notificationId read.");
    } catch (error) {
      print("Error deleting notification: $error");
    }
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
            stream: _firebaseNotifications.getUnreadNotificationsStream(),
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

                  if (data == null) return SizedBox.shrink();

                  String? type = data["type"];
                  String? title = data["title"] ?? "Notification";
                  String? message = data["message"] ?? "";
                  String notificationId = notification.id;

                  // Get timestamp and format it
                  Timestamp? timestamp = data["timestamp"];
                  DateTime notificationDateTime = timestamp?.toDate() ?? DateTime.now();
                  String formattedDate = DateFormat('dd MMM yyyy, hh:mm a').format(notificationDateTime);

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

                  return Dismissible(
                    key: Key(notificationId), // Unique key for each notification
                    direction: DismissDirection.endToStart, // Swipe left to delete
                    background: Container(
                      padding: EdgeInsets.only(right: 20),
                      alignment: Alignment.centerRight,
                      color: Colors.red,
                      child: Icon(Icons.delete, color: Colors.white, size: 30),
                    ),
                    onDismissed: (direction) {
                      _deleteNotification(notificationId);
                    },
                    child: NotificationItem(
                      icon: iconData,
                      title: title ?? "Notification",
                      description: "$message",
                      timestamp: notificationDateTime,
                      onTap: () => _handleNotificationTap(type ?? "", notificationId),
                    ),
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
