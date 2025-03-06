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

/// A page that displays all the unread notifications for the user.
/// The notifications are fetched from Firestore and can be tapped to navigate to the related pages.
/// Users can also dismiss notifications by swiping them away.
class NotificationsPage extends StatefulWidget {
  /// A callback function to handle the navigation item tap.
  final Function(int) onItemTapped;

  /// The index of the selected navigation item.
  final int selectedIndex;
  @visibleForTesting
  final FirebaseFirestore? firestoreOverride;
  @visibleForTesting
  final FirebaseNotifications? firebaseNotificationsOverride;

  const NotificationsPage({
    Key? key,
    required this.onItemTapped,
    required this.selectedIndex,
    this.firestoreOverride,
    this.firebaseNotificationsOverride,
  }) : super(key: key);

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  // Instance of FirebaseNotifications for interacting with Firestore notifications
  FirebaseNotifications get _firebaseNotifications =>
      widget.firebaseNotificationsOverride ?? FirebaseNotifications();

  /// Handles tapping on a notification. It marks the notification as read and navigates
  /// to the corresponding page based on the notification's type.
  ///
  /// [type] The type of the notification that determines the target page.
  /// [notificationId] The unique ID of the notification to mark as read.
  Future<void> _handleNotificationTap(
      
      String type, String notificationId) async {
    if (!mounted) return;

    // Determine the target page based on the notification type
    Widget targetPage;
    switch (type) {
      case "score_update":
        targetPage = ScorePage(
            
            onItemTapped: widget.onItemTapped,
           
            selectedIndex: widget.selectedIndex);
        break;
      case "session_reminder":
        targetPage = MainScreen();
        break;
      case "practice_reminder":
        targetPage = Courses(
            
            onItemTapped: widget.onItemTapped,
           
            selectedIndex: widget.selectedIndex);
        break;
      case "subscription":
        targetPage = ManagePlanPage(
            
            onItemTapped: widget.onItemTapped,
           
            selectedIndex: widget.selectedIndex);
        break;
      default:
        print("Unknown notification type: $type");
        return;
    }

    // Mark the notification as read in Firestore
    await _firebaseNotifications.markNotificationAsRead(notificationId);

    // Navigate to the target page
    navigatorKey.currentState
        
        ?.push(MaterialPageRoute(builder: (context) => targetPage));
  }

  /// Deletes a notification from Firestore. The notification is also marked as read.
  ///
  /// [notificationId] The unique ID of the notification to be deleted.
  Future<void> _deleteNotification(String notificationId) async {
    try {
      // Mark the notification as read before deleting
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
          title: "Notifications", // Title of the notifications page
          onItemTapped: widget.onItemTapped,
          selectedIndex: widget.selectedIndex,
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: StreamBuilder<QuerySnapshot>(
            // Fetch unread notifications from Firestore
            stream: _firebaseNotifications.getUnreadNotificationsStream(),
            builder: (context, snapshot) {
              // Show loading spinner while waiting for the data
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              // Handle errors if they occur
              if (snapshot.hasError) {
                return Center(child: Text("Error fetching notifications."));
              }

              // Show a message if there are no unread notifications
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(child: Text("No unread notifications."));
              }

              // Fetch the list of notifications
              var notifications = snapshot.data!.docs;

              return ListView.builder(
                itemCount:
                    notifications.length, // Total number of notifications
                itemBuilder: (context, index) {
                  var notification = notifications[index];
                  var data = notification.data() as Map<String, dynamic>?;

                  if (data == null)
                    return SizedBox.shrink(); // Skip if data is null

                  String? type = data["type"]; // Get the notification type
                  String? title = data["title"] ??
                      "Notification"; // Get the title, default to "Notification"
                  String? message = data["message"] ??
                      ""; // Get the message, default to empty
                  String notificationId =
                      notification.id; // Get the notification's unique ID

                  // Get the timestamp and format it to a readable date
                  Timestamp? timestamp = data["timestamp"];
                  DateTime notificationDateTime =
                     
                      timestamp?.toDate() ?? DateTime.now();
                  String formattedDate = DateFormat('dd MMM yyyy, hh:mm a')
                      
                      .format(notificationDateTime);

                  // Determine the appropriate icon based on the notification type
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

                  // Wrap each notification in a Dismissible widget to allow swiping to delete
                  return Dismissible(
                    key:
                        Key(
                        notificationId), // Use the notification ID as the key
                    direction:
                        DismissDirection
                        .endToStart, // Swipe from right to left to delete
                    background: Container(
                      padding: EdgeInsets.only(right: 20),
                      alignment: Alignment.centerRight,
                      color: Colors.red, // Background color when swiping
                      child: Icon(Icons.delete, color: Colors.white, size: 30),
                    ),
                    onDismissed: (direction) {
                      // Delete the notification when swiped
                      _deleteNotification(notificationId);
                    },
                    child: NotificationItem(
                      icon: iconData, // Icon based on notification type
                      title:
                          title ?? "Notification", // Title of the notification
                      description: "$message", // Message of the notification
                      timestamp:
                          notificationDateTime, // Timestamp of the notification
                      onTap: () =>
                          _handleNotificationTap(type ?? "",
                          notificationId), // Handle tap on the notification
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
