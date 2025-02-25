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
      UserProvider userProvider = Provider.of<UserProvider>(context);
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
      print("Error signing out: $e");
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

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
