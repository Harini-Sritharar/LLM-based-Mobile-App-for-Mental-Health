import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:llm_based_sat_app/screens/auth/sign_in_page.dart';
import 'package:llm_based_sat_app/screens/notification/notifications_page.dart';

// Import Global Keys from main.dart
import '../main.dart';

/// A service class to handle Firebase Cloud Messaging (FCM) and local notifications.
class FirebaseMessagingService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  FirebaseMessagingService();

  ///Navigate to Notifications Page when a notification is clicked
  void _navigateToNotificationsPage() {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // User is not logged in, redirect to Sign-in Page
      navigatorKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => SignInPage()),
        (route) => false, // Clears the navigation stack
      );
    } else {
      // User is logged in, go to Notifications Page
      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (context) => NotificationsPage(
            onItemTapped: (index) {},
            selectedIndex: 0,
          ),
        ),
      );
    }
  }

  /// Initializes the Firebase Messaging and local notifications.
  Future<void> initialize() async {
    // Get and save the FCM token
    String? token = await _firebaseMessaging.getToken();
    if (token != null) {
      await saveTokenToDatabase(token);
    }

    // Request permission for notifications
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Initialize Local Notifications
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        _navigateToNotificationsPage();
      },
    );

    // Foreground notifications (Show In-App Notification)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showInAppNotification(message);
    });

    // Background & Terminated Notifications
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _navigateToNotificationsPage();
    });

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        _navigateToNotificationsPage();
      }
    });
  }

  ///Save the FCM token to Firestore under the user's profile
  Future<void> saveTokenToDatabase(String token) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return; // Ensure user is logged in

    String userId = user.uid;
    DocumentReference userRef =
        FirebaseFirestore.instance.collection('Profile').doc(userId);

    // Save or update the token
    await userRef.set({'fcmToken': token}, SetOptions(merge: true));
  }

  ///Show an in-app notification using ScaffoldMessengerKey
  void _showInAppNotification(RemoteMessage message) {
    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message.notification?.body ?? "New Notification"),
        action: SnackBarAction(
          label: 'View',
          onPressed: _navigateToNotificationsPage,
        ),
        duration: Duration(seconds: 5),
      ),
    );
  }
}
