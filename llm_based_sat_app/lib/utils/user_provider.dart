import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  Map<String, dynamic> _userData = {};
  String? _email;
  Map<String, dynamic> get userData => _userData;
  String? get email => _email;

  Future<void> fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _email = user.email;
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Profile')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        _userData = userDoc.data() as Map<String, dynamic>;
        notifyListeners();
      }
    }
  }

  /// Returns the user's full name from the stored data.
  String getName() {
    try {
      String? firstName = _userData['firstname'];
      String? surname = _userData['surname'];

      if (firstName != null &&
          firstName.isNotEmpty &&
          surname != null &&
          surname.isNotEmpty) {
        return "$firstName $surname";
      }
    } catch (e) {
      throw ("Error getting name: $e");
    }
    return "No Name Found";
  }

  // Returns the user's profile picture URL from the stored data.
  String getProfilePictureUrl() {
    try {
      // Check if the document exists and return the profile picture URL
      final profilePictureUrl = _userData['profilePictureUrl'] as String?;

      if (profilePictureUrl != null && profilePictureUrl.isNotEmpty) {
        return profilePictureUrl;
      }
      // Return a default value if the URL is null or the document doesn't exist
      return 'No Profile Picture Found';
    } catch (e) {
      // Handle errors and return a default value
      throw ('Error fetching profile picture URL: $e');
    }
  }
}
