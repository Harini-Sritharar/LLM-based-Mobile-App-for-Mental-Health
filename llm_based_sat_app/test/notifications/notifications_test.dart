import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:llm_based_sat_app/firebase/firebase_notifications.dart';
import 'package:llm_based_sat_app/screens/notification/notifications_page.dart';
import 'package:llm_based_sat_app/widgets/notification_widgets/notification_item.dart';
import 'package:mockito/mockito.dart';

// Mock FirebaseNotifications to override its behavior in tests
class MockFirebaseNotifications extends Mock implements FirebaseNotifications {
  final FakeFirebaseFirestore fakeFirestore;
  final String userId;

  MockFirebaseNotifications(this.fakeFirestore, this.userId);

  @override
  Stream<QuerySnapshot> getUnreadNotificationsStream() {
    return fakeFirestore
        .collection('Profile')
        .doc(userId)
        .collection('notifications')
        .where('isRead', isEqualTo: false)
        .snapshots();
  }

  @override
  Future<void> markNotificationAsRead(String notificationId) async {
    await fakeFirestore
        .collection('Profile')
        .doc(userId)
        .collection('notifications')
        .doc(notificationId)
        .update({'isRead': true});
  }
}

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late MockFirebaseNotifications mockFirebaseNotifications;
  final String userId = 'test-user-id';

  setUp(() {
    // Create a FakeFirebaseFirestore instance for testing
    fakeFirestore = FakeFirebaseFirestore();
    mockFirebaseNotifications = MockFirebaseNotifications(fakeFirestore, userId);

    // Add test notifications to the fake Firestore using the requested structure
    fakeFirestore
        .collection('Profile')
        .doc(userId)
        .collection('notifications')
        .doc('notification1')
        .set({
      "isRead": false,
      "message": "You haven't completed 20 minutes of practice today. Keep learning!",
      "timestamp": Timestamp.fromDate(DateTime.utc(2025, 2, 24, 16, 59, 3)),
      "title": "Practice Time Remaining!",
      "type": "practice_reminder",
    });

    fakeFirestore
        .collection('Profile')
        .doc(userId)
        .collection('notifications')
        .doc('notification2')
        .set({
      "isRead": false,
      "message": "Don't forget your therapy session at 3pm",
      "timestamp": Timestamp.fromDate(DateTime.now().subtract(Duration(hours: 5))),
      "title": "Session Today",
      "type": "session_reminder",
    });

    fakeFirestore
        .collection('Profile')
        .doc(userId)
        .collection('notifications')
        .doc('notification3')
        .set({
      "isRead": false,
      "message": "Upgrade to premium for 20% off",
      "timestamp": Timestamp.fromDate(DateTime.now().subtract(Duration(days: 1))),
      "title": "Premium Offer",
      "type": "subscription",
    });
  });

  testWidgets('NotificationsPage displays notifications from Firestore',
      (WidgetTester tester) async {
    // Build NotificationsPage with direct override 
    await tester.pumpWidget(
      MaterialApp(
        home: NotificationsPage(
          onItemTapped: (_) {},
          selectedIndex: 0,
          firebaseNotificationsOverride: mockFirebaseNotifications,
        ),
      ),
    );

    // Wait for the StreamBuilder to get the data and build
    await tester.pumpAndSettle();

    // Verify the page title is displayed
    expect(find.text('Notifications'), findsOneWidget);

    // Verify all notification titles are displayed
    expect(find.text('Practice Time Remaining!'), findsOneWidget);
    expect(find.text('Session Today'), findsOneWidget);
    expect(find.text('Premium Offer'), findsOneWidget);

    // Verify notification messages are displayed
    expect(find.text("You haven't completed 20 minutes of practice today. Keep learning!"), 
           findsOneWidget);
    expect(find.text('Don\'t forget your therapy session at 3pm'), findsOneWidget);
    expect(find.text('Upgrade to premium for 20% off'), findsOneWidget);

    // Verify that we have 3 NotificationItems
    expect(find.byType(NotificationItem), findsNWidgets(3));
  });

  testWidgets('NotificationsPage shows empty state when no notifications',
      (WidgetTester tester) async {
    // Create a clean fake Firestore with no notifications
    final emptyFirestore = FakeFirebaseFirestore();
    final emptyMockNotifications = MockFirebaseNotifications(emptyFirestore, userId);

    await tester.pumpWidget(
      MaterialApp(
        home: NotificationsPage(
          onItemTapped: (_) {},
          selectedIndex: 0,
          firebaseNotificationsOverride: emptyMockNotifications,
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify empty state message is shown
    expect(find.text('No unread notifications.'), findsOneWidget);
    expect(find.byType(NotificationItem), findsNothing);
  });

  testWidgets('Dismissing a notification marks it as read',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: NotificationsPage(
          onItemTapped: (_) {},
          selectedIndex: 0,
          firebaseNotificationsOverride: mockFirebaseNotifications,
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Initially we have 3 notifications
    expect(find.byType(NotificationItem), findsNWidgets(3));

    // Get the first Dismissible
    final dismissibleFinder = find.byType(Dismissible).first;

    // Swipe to dismiss
    await tester.drag(dismissibleFinder, const Offset(-500, 0));
    await tester.pumpAndSettle();

    // Now verify the notification was marked as read
    // Instead, we'll just verify there are now only 2 notifications visible
    expect(find.byType(NotificationItem), findsNWidgets(2));

    // Extra verification: check the Firestore document was updated
    final docSnapshot = await fakeFirestore
        .collection('Profile')
        .doc(userId)
        .collection('notifications')
        .doc('notification1')  // Assuming first notification is dismissed
        .get();
    
    expect(docSnapshot.data()?['isRead'], true);
  });
}