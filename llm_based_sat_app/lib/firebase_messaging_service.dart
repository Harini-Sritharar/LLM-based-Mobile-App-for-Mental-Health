import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:llm_based_sat_app/screens/notification/notifications_page.dart';
import 'package:path/path.dart';

class FirebaseMessagingService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final BuildContext context;

  FirebaseMessagingService(this.context);

  Future<void> initialize() async {
    // Get the device token
    String? token = await _firebaseMessaging.getToken();

    // Request permission for iOS
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Check the authorization status
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // User granted permission
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      // User granted provisional permission
    } else {
      // User denied permission
    }

    // Save APNs Token for iOS
    String? apnsToken = await _firebaseMessaging.getAPNSToken();

    // Initialize local notifications for Android & iOS
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    final InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );

    // Initialize the local notifications plugin
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        _navigateToNotificationsPage(context);
      },
    );

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        _showNotification(message);
      }
    });

    // Handle background messages
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _navigateToNotificationsPage(context);
    });

    // Handle terminated state notifications
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        _navigateToNotificationsPage(context);
      }
    });
  }

  // Navigate to the notifications page
  void _navigateToNotificationsPage(BuildContext context) {
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

  // Show a local notification
  Future<void> _showNotification(RemoteMessage message) async {
    if (!context.mounted) return;
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'high_importance_channel',
          'High Importance Notifications',
          channelDescription: 'This channel is used for important notifications',
          importance: Importance.high,
          priority: Priority.high,
          showWhen: false,
        );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await _flutterLocalNotificationsPlugin.show(
      0,
      message.notification?.title,
      message.notification?.body,
      platformChannelSpecifics,
      payload: 'item x',
    );
  }

  // Save the FCM token to the Firestore database
  Future<void> saveTokenToDatabase(String token) async {
    // Get the current user ID
    User? user = FirebaseAuth.instance.currentUser;
    String userId = user!.uid;

    // Reference to the user's profile in the Firestore database
    DocumentReference userRef = FirebaseFirestore.instance.collection('Profile').doc(userId);

    // Save the token
    await userRef.update({'fcmToken': token});
  }
}
