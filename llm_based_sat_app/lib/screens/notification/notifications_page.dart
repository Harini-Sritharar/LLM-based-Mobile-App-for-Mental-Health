import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:llm_based_sat_app/widgets/custom_app_bar.dart';
import 'package:llm_based_sat_app/widgets/main_layout.dart';
import 'package:llm_based_sat_app/widgets/notification_widgets/notification_item.dart';
import 'package:llm_based_sat_app/firebase/firebase_notifications.dart';

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
            stream: _firebaseNotifications.getNotificationsStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text("Error fetching notifications."));
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(child: Text("No notifications yet."));
              }

              var notifications = snapshot.data!.docs;

              return ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  var notification = notifications[index];
                  var data = notification.data() as Map<String, dynamic>;

                  // Map notification type to icon
                  IconData iconData;
                  switch (data["type"]) {
                    case "reminder":
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
                    title: data["title"] ?? "Notification",
                    description: data["message"] ?? "",
                    onTap: () {
                      _firebaseNotifications.markNotificationAsRead(notification.id);
                    },
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
