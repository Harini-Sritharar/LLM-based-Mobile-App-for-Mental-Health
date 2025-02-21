import 'package:cloud_firestore/cloud_firestore.dart';

Future<String> getName(String uid) async {
  try {
    // Reference to the Firestore collection
    final collection = FirebaseFirestore.instance.collection('Profile');

    // Get the document for the user with the given UID
    final snapshot = await collection.doc(uid).get();

    // Check if the document exists and return the name
    if (snapshot.exists) {
      final firstName = snapshot.data()?['firstname'] as String?;
      final surname = snapshot.data()?['surname'] as String?;

      if (firstName != null &&
          firstName.isNotEmpty &&
          surname != null &&
          surname.isNotEmpty) {
        return firstName + " " + surname;
      }
    }
    // Return a default value if the name is null or the document doesn't exist
    return 'No Name Found';
  } catch (e) {
    // Handle errors and return a default value
    print('Error fetching user name: $e');
    return 'Error Fetching Name';
  }
}

Future<String> getTier(String uid) async {
  try {
    // Reference to the Firestore collection
    final collection = FirebaseFirestore.instance.collection('Profile');

    // Get the document for the user with the given UID
    final snapshot = await collection.doc(uid).get();

    // Check if the document exists and return the name
    if (snapshot.exists) {
      final tier = snapshot.data()?['tier'] as String?;

      if (tier != null && tier.isNotEmpty) return tier;
    }
    // Return a default value if the name is null or the document doesn't exist
    return 'free';
  } catch (e) {
    // Handle errors and return a default value
    print('Error fetching tier $e');
    return 'Error Fetching Tier';
  }
}

Future<DateTime> getTierExpiry(String uid) async {
  try {
    // Reference to the Firestore collection
    final collection = FirebaseFirestore.instance.collection('Profile');

    // Get the document for the user with the given UID
    final snapshot = await collection.doc(uid).get();

    // Check if the document exists
    if (snapshot.exists) {
      // Get the tier_expiry field from the document
      final tierExpiryTimestamp = snapshot.data()?['tier_expiry'] as Timestamp?;

      if (tierExpiryTimestamp != null) {
        // Return the expiry date as DateTime
        return tierExpiryTimestamp.toDate();
      } else {
        // Handle the case where tier_expiry is not found, for "free" tier
        // Setting a default far future date for free tier
        return DateTime(2100, 1, 1);
      }
    }
    // If the document doesn't exist or there's no expiry, return the default far future date
    return DateTime(2100, 1, 1);
  } catch (e) {
    // Handle errors and return a default far future date
    print('Error fetching tier expiry: $e');
    return DateTime(2100, 1, 1); // Default far future date on error
  }
}

Future<void> setTier(String uid, String tier) async {
  try {
    // Reference to the Firestore collection
    final collection = FirebaseFirestore.instance.collection('Profile');

    // Initialize expiryDate based on the tier
    DateTime expiryDate;
    if (tier == 'monthly') {
      expiryDate =
          DateTime.now().add(Duration(days: 30)); // 30 days for monthly
    } else if (tier == 'yearly') {
      expiryDate =
          DateTime.now().add(Duration(days: 365)); // 365 days for yearly
    } else if (tier == 'free') {
      expiryDate =
          DateTime(2100, 1, 1); // Set expiry far in the future for free tier
    } else {
      throw Exception('Invalid tier type');
    }

    // Update the user's tier and expiry date in Firestore
    await collection.doc(uid).set(
      {
        'tier': tier,
        'tier_expiry':
            Timestamp.fromDate(expiryDate), // Store expiry date for all tiers
      },
      SetOptions(merge: true), // Merge to avoid overwriting other fields
    );

    print('Tier updated successfully to $tier with expiry on $expiryDate');
  } catch (e) {
    print('Error setting tier: $e');
  }
}

Future<String> getProfilePictureUrl(String uid) async {
  try {
    // Reference to the Firestore collection
    final collection = FirebaseFirestore.instance.collection('Profile');

    // Get the document for the user with the given UID
    final snapshot = await collection.doc(uid).get();

    // Check if the document exists and return the profile picture URL
    if (snapshot.exists) {
      final profilePictureUrl =
          snapshot.data()?['profilePictureUrl'] as String?;

      if (profilePictureUrl != null && profilePictureUrl.isNotEmpty) {
        return profilePictureUrl;
      }
    }
    // Return a default value if the URL is null or the document doesn't exist
    return 'No Profile Picture Found';
  } catch (e) {
    // Handle errors and return a default value
    print('Error fetching profile picture URL: $e');
    return 'Error Fetching Profile Picture';
  }
}

// Remove all user documents from a given collection
Future<void> removeUserDocuments({
  required String userId,
  required String collectionName,
}) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  try {
    // Query all documents with the given userId
    QuerySnapshot querySnapshot = await firestore
        .collection(collectionName) // Target the specified collection
        .where('userId', isEqualTo: userId)
        .get();

    // Iterate through the documents and delete them
    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      await doc.reference.delete();
    }

    print(
        "All documents for userId: $userId in collection: $collectionName have been removed.");
  } catch (e) {
    print("Error removing documents for userId: $userId. Details: $e");
  }
}

Future<List<String>> getFavouritePhotos(String uid) async {
  try {
    final snapshot =
        await FirebaseFirestore.instance.collection('Profile').doc(uid).get();
    if (snapshot.exists) {
      final List<dynamic>? photos = snapshot.data()?['favouritePhotos'];
      if (photos != null) {
        return photos.cast<String>();
      }
    }
    return [];
  } catch (e) {
    print('Error fetching favourite photos: $e');
    return [];
  }
}

Future<List<String>> getNonFavouritePhotos(String uid) async {
  try {
    final snapshot =
        await FirebaseFirestore.instance.collection('Profile').doc(uid).get();
    if (snapshot.exists) {
      final List<dynamic>? photos = snapshot.data()?['nonFavouritePhotos'];
      if (photos != null) {
        return photos.cast<String>();
      }
    }
    return [];
  } catch (e) {
    print('Error fetching non-favourite photos: $e');
    return [];
  }
}