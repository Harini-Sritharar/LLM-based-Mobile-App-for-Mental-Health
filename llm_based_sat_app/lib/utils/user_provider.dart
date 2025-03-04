import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/// A [ChangeNotifier] class that manages the user data fetched from Firebase.
class UserProvider with ChangeNotifier {
  /// A private map to store the user data fetched from Firestore.
  Map<String, dynamic> _userData = {};

  /// A private string to store the user's email address.
  String? _email;

  /// A private string to store the user's UID.
  String? _uid;
  Map<String, dynamic> get userData => _userData;
  String? get email => _email;
  String? get uid => _uid;

  /// Fetches user data from Firebase.
  /// This method retrieves the current user's UID and email from FirebaseAuth,
  /// and fetches additional user data from the Firestore collection 'Profile'.
  /// If the user exists in Firestore, their data is stored in [_userData],
  /// and the UI is notified to update via [notifyListeners].
  Future<void> fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _uid = user.uid;
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

  /// Sets the UID for the user.
  /// This method is used to manually set the user's UID and notify listeners
  /// to trigger UI updates.
  ///
  /// [uid] - The unique identifier for the user.
  void setUid(String uid) {
    _uid = uid;
    notifyListeners();
  }

  /// Sets the email for the user.
  /// This method is used to manually set the user's email and notify listeners
  /// to trigger UI updates.
  ///
  /// [email] - The email address of the user.
  void setEmail(String email) {
    _email = email;
    notifyListeners();
  }

  /// Updates the user data.
  /// This method is used to update the entire user data map and notify listeners
  /// so that the UI can reflect the changes.
  ///
  /// [userData] - A map containing the user's data to update.
  void setUserData(Map<String, dynamic> userData) {
    _userData = userData;
    notifyListeners();
  }

  /// Gets the user's UID.
  /// This method returns the UID of the user, and if the UID is null or empty,
  /// it returns a default error message.
  ///
  /// Returns a [String] representing the user's UID or a default message if not found.
  String getUid() {
    try {
      final uid = _uid;
      if (uid != null && uid.isNotEmpty) {
        return uid;
      }
    } catch (e) {
      throw ('Error getting uid: $e');
    }
    return 'No UID Found';
  }

  /// Gets the user's first name.
  /// This method retrieves the user's first name from the stored user data,
  /// and if it's not available or empty, it returns a default message.
  ///
  /// Returns a [String] representing the user's first name or a default message if not found.
  String getFirstName() {
    try {
      final firstName = _userData['firstname'] as String?;
      if (firstName != null && firstName.isNotEmpty) {
        return firstName;
      }
    } catch (e) {
      throw ('Error fetching first name: $e');
    }
    return 'No First Name Found';
  }

  /// Gets the user's full name.
  /// This method combines the user's first name and surname to form the full name.
  /// If either part is missing, it returns a default message indicating no name was found.
  ///
  /// Returns a [String] representing the user's full name or a default message if not found.
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

  /// Gets the user's profile picture URL.
  /// This method retrieves the URL of the user's profile picture from the stored user data.
  /// If the URL is not available or empty, it returns a default message.
  ///
  /// Returns a [String] representing the URL of the user's profile picture or a default message if not found.
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
