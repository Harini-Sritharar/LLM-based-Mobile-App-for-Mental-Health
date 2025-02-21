import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseNotifications {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Fetch the current user's ID
  String? getCurrentUserId() {
    return _auth.currentUser?.uid;
  }

  /// Returns a stream of notifications for the logged-in user
  Stream<QuerySnapshot> getNotificationsStream() {
    final String? userId = getCurrentUserId();
    if (userId == null) {
      throw Exception("User not logged in");
    }
    
    return _firestore
        .collection("Profile")
        .doc(userId)
        .collection("notifications")
        .orderBy("timestamp", descending: true)
        .snapshots();
  }

  /// Mark a notification as read
  Future<void> markNotificationAsRead(String notificationId) async {
    final String? userId = getCurrentUserId();
    if (userId == null) {
      throw Exception("User not logged in");
    }

    await _firestore
        .collection("Profile")
        .doc(userId)
        .collection("notifications")
        .doc(notificationId)
        .update({"isRead": true});
  }
}
