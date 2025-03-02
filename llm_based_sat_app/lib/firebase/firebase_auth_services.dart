import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:llm_based_sat_app/utils/user_provider.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  Future<User?> signUpWithEmailAndPassword(
      BuildContext context, String email, String password) async {
    try {
      // Create a new user with the email and password
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      // Create an empty record in the collection 'Profile' with the user's uid
      FirebaseFirestore db = FirebaseFirestore.instance;
      await db.collection('Profile').doc(credential.user!.uid).set({});

      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        _handleFirebaseAuthError(context, e);
      }
    } catch (e) {
      if (context.mounted) {
        // Handle any other errors
        _showSnackBar(
            context, 'An unexpected error occurred. Please try again.');
      }
    }
    return null;
  }

  Future<User?> signInWithEmailandPassword(
      BuildContext context, String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        _handleFirebaseAuthError(context, e);
      }
    } catch (e) {
      if (context.mounted) {
        // Handle any other errors
        _showSnackBar(
            context, 'An unexpected error occurred. Please try again.');
      }
    }
    return null;
  }

  Future<void> signOut(BuildContext context) async {
    try {
      UserProvider userProvider =
          Provider.of<UserProvider>(context, listen: false);
      User? user = _auth.currentUser; // Get the user before signing out
      if (user != null) {
        String userId = userProvider.getUid();

        // Remove FCM token from Firestore
        await _firestore.collection('Profile').doc(userId).update({
          'fcmToken': FieldValue.delete(),
        });

        // Optionally delete FCM token from the device (for security)
        await _messaging.deleteToken();
      }
      await _auth.signOut();
      print("User signed out and FCM token removed successfully.");
    } catch (e) {
      throw ("Error signing out: $e");
    }
  }

  void _handleFirebaseAuthError(BuildContext context, FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        _showSnackBar(context,
            'This email address is already registered. Try signing in instead!');
        break;
      case 'invalid-email':
        _showSnackBar(context, 'The email address provided is not valid.');
        break;
      case 'invalid-credential':
        _showSnackBar(context, 'The email address or password is incorrect.');
        break;
      case 'weak-password':
        _showSnackBar(context,
            'The password is too weak. Please use a stronger password.');
        break;
      case 'user-not-found':
        _showSnackBar(context, 'No user found with this email address.');
        break;
      case 'wrong-password':
        _showSnackBar(context, 'Incorrect password provided.');
        break;
      case 'user-disabled':
        _showSnackBar(context, 'This account has been disabled.');
        break;
      default:
        _showSnackBar(context, 'An error occurred: ${e.message}');
    }
  }

  Future<bool> deleteAccount(
      BuildContext context, String password, String reason) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        _showSnackBar(context, "No user signed in.");
        return false;
      }

      // Re-authenticate user
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );

      await user.reauthenticateWithCredential(credential);

      FirebaseFirestore db = FirebaseFirestore.instance;

      // Save deletion reason before deleting account
      await db.collection("DeletedAccounts").doc(user.uid).set({
        "reason": reason.isNotEmpty ? reason : "Other",
        "timestamp": FieldValue.serverTimestamp(),
      });

      // Delete user's profile data
      await db.collection('Profile').doc(user.uid).delete();

      // Delete user authentication
      await user.delete();

      _showSnackBar(context, "Account successfully deleted.");
      return true; // Indicate success
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        _showSnackBar(context, "Incorrect password. Please try again.");
      } else if (e.code == 'requires-recent-login') {
        _showSnackBar(
            context, "Please log in again before deleting your account.");
      } else {
        _showSnackBar(context, "Error: ${e.message}");
      }
    } catch (e) {
      _showSnackBar(context, "An error occurred while deleting the account.");
    }
    return false; // Indicate failure
  }

  Future<bool> resetSettings(BuildContext context, String password) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        _showSnackBar(context, "No user signed in.");
        return false;
      }

      // Re-authenticate user
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );

      await user.reauthenticateWithCredential(credential);

      FirebaseFirestore db = FirebaseFirestore.instance;
      DocumentReference profileRef = db.collection('Profile').doc(user.uid);

      // Fetch the document
      DocumentSnapshot profileSnapshot = await profileRef.get();
      if (!profileSnapshot.exists) {
        _showSnackBar(context, "Profile not found.");
        return false;
      }

      // Fields to keep
      List<String> fieldsToKeep = [
        "country",
        "dob",
        "favouritePhotos",
        "firstname",
        "gender",
        "phoneNumber",
        "surname",
        "tier",
        "zipcode"
      ];

      // Retain only the allowed fields
      Map<String, dynamic> profileData =
          profileSnapshot.data() as Map<String, dynamic>;
      Map<String, dynamic> filteredData = {};

      for (String field in fieldsToKeep) {
        if (profileData.containsKey(field)) {
          filteredData[field] = profileData[field];
        }
      }

      // Update Firestore with only the allowed fields
      await profileRef.set(filteredData);

      // Delete all subcollections
      await _deleteSubcollection(profileRef, "responses");
      await _deleteSubcollection(profileRef, "course_progress");
      await _deleteSubcollection(profileRef, "notifications");

      _showSnackBar(context, "Settings have been reset.");

      return true; // Indicate success
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        _showSnackBar(context, "Incorrect password. Please try again.");
      } else {
        _showSnackBar(context, "Error: ${e.message}");
      }
    } catch (e) {
      _showSnackBar(context, "Error resetting settings.");
    }

    return false;
  }

  Future<void> _deleteSubcollection(
      DocumentReference userDoc, String subcollection) async {
    final subcollectionRef = userDoc.collection(subcollection);
    final snapshot = await subcollectionRef.get();

    for (DocumentSnapshot doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

// If we want the reset password link to open up inside the app, then we'll have to add dynamic links; the current implementation does not do that
  Future<void> resetPassword(String email) async {
      await _auth.sendPasswordResetEmail(email: email);      
  }
}
