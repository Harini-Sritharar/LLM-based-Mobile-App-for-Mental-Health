// TODO: will need to move all the firebase calls to one place perhaps?

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:llm_based_sat_app/models/user_data_interface.dart';

Future<void> uploadUserProfileToFirebase(User_ userProfile) async {
  User? user = FirebaseAuth.instance.currentUser;
  FirebaseFirestore db = FirebaseFirestore.instance;
  await db.collection('Profile').doc(user!.uid).set({
    'firstname': userProfile.firstname,
    'surname': userProfile.surname,
    'dob': userProfile.dob,
    'gender': userProfile.gender,
    'zipcode': userProfile.zipcode,
    'country': userProfile.country,
    'phoneNumber': userProfile.phoneNumber,
    'profilePictureUrl': userProfile.profilePictureUrl,
  });
}
