import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:llm_based_sat_app/firebase_messaging_service.dart';
import 'package:llm_based_sat_app/screens/notification/notifications_page.dart'; // Import NotificationsPage

class FCMInitializer extends StatefulWidget {
  final Widget child;

  const FCMInitializer({super.key, required this.child});

  @override
  _FCMInitializerState createState() => _FCMInitializerState();
}

class _FCMInitializerState extends State<FCMInitializer> {
  @override
  void initState() {
    super.initState();
    _initializeFCM();
  }

  Future<void> _initializeFCM() async {
    try {
      final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

      // Request notification permissions (required for iOS)
      NotificationSettings settings = await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional) {
        print('User granted permission for notifications.');

        // Fetch and print the APNs token (required for iOS)
        String? apnsToken = await _firebaseMessaging.getAPNSToken();
        print("APNs Token (iOS only): $apnsToken");

        // Fetch the FCM token
        String? token = await _firebaseMessaging.getToken();

        if (token != null && mounted) {
          print("FCM Token: $token");
          final firebaseMessagingService = FirebaseMessagingService();
          await firebaseMessagingService.saveTokenToDatabase(token);
        } else {
          print("Token is null. Retrying in 5 seconds...");
          await Future.delayed(const Duration(seconds: 5));
          if (mounted) _initializeFCM(); // Retry only if widget is still mounted
        }

        // Listen for token updates and save them
        FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
          print("Token updated: $newToken");
          if (mounted) {
            final firebaseMessagingService = FirebaseMessagingService();
            await firebaseMessagingService.saveTokenToDatabase(newToken);
          }
        });

        // Handle Foreground Notifications
        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
          print("Foreground Notification Received: ${message.notification?.title}");
          _showNotification(message);
        });

        // Handle Background Notification Click
        FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
          print("Notification Clicked (Background) - ${message.notification?.title}");
          if (mounted) _navigateToNotificationsPage();
        });

        // Handle Terminated Notification Click
        FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
          if (message != null && mounted) {
            print("App Opened from Terminated State via Notification: ${message.notification?.title}");
            _navigateToNotificationsPage();
          }
        });
      } else {
        print("User denied permission for notifications.");
      }
    } catch (e) {
      print("Error initializing FCM: $e");
    }
  }

  ///Function to navigate to the Notifications page safely
  void _navigateToNotificationsPage() {
    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NotificationsPage(
          onItemTapped: (index) {},
          selectedIndex: 0,
        ),
      ),
    );
  }

  ///Function to show a local notification in the foreground (iOS requires this)
  void _showNotification(RemoteMessage message) {
    if (!mounted) return;

    if (message.notification != null) {
      print("Displaying Local Notification: ${message.notification?.title}");

      // Show an alert dialog for demonstration (optional)
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(message.notification!.title ?? "Notification"),
            content: Text(message.notification!.body ?? "You have a new message"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _navigateToNotificationsPage(); // Navigate to notifications on dismiss
                },
                child: const Text("View"),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
