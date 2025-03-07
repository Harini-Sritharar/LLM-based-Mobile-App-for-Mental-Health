import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:llm_based_sat_app/theme/app_colours.dart';
import 'package:llm_based_sat_app/utils/user_provider.dart';
import 'package:llm_based_sat_app/widgets/custom_app_bar.dart';
import 'package:provider/provider.dart';

// This page allows the user to upload childhood photos, categorize them as
// "favourite" or "non-favourite", and save the changes to Firestore.
// It also allows the user to delete photos from their lists (favourite or non-favourite).
// The photos are uploaded to Firebase Storage, and their URLs are stored in Firestore.
// The page also interacts with Firebase Authentication and UserProvider to retrieve and save user-specific data.
class ChildhoodPhotosPage extends StatefulWidget {
  final Function(int) onItemTapped;
  final int selectedIndex;
  final VoidCallback onCompletion;

  // Override fields
  final FirebaseAuth? authOverride; 
  final FirebaseFirestore? firestoreOverride;
  final ImagePicker? pickerOverride;
  final FirebaseStorage? storageOverride;

  const ChildhoodPhotosPage({
    super.key,
    required this.onItemTapped,
    required this.selectedIndex,
    required this.onCompletion,
    this.authOverride,
    this.firestoreOverride,
    this.pickerOverride,
    this.storageOverride,
  });

  @override
  State<ChildhoodPhotosPage> createState() => _ChildhoodPhotosPageState();
}

class _ChildhoodPhotosPageState extends State<ChildhoodPhotosPage> {
  // Use the injected instances or fall back to real ones
  FirebaseAuth get _auth => widget.authOverride ?? FirebaseAuth.instance;
  FirebaseFirestore get _firestore =>
      widget.firestoreOverride ?? FirebaseFirestore.instance;
  ImagePicker get _picker => widget.pickerOverride ??
      ImagePicker(); // Image picker instance for photo selection
  FirebaseStorage get _storage => widget.storageOverride ?? FirebaseStorage.instance;

  List<String> favouritePhotos = []; // List to store URLs of favourite photos
  List<String> nonFavouritePhotos =
      []; // List to store URLs of non-favourite photos
  List<String> localFavouritePhotos =
      []; // List to store locally picked favourite photos
  List<String> localNonFavouritePhotos =
      []; // List to store locally picked non-favourite photos
  List<String> deletedFavouritePhotos =
      []; // List to track deleted favourite photos
  List<String> deletedNonFavouritePhotos =
      []; // List to track deleted non-favourite photos
  bool isSaving = false; // Flag to prevent multiple saves
  late UserProvider userProvider; // User provider for managing user data
  String uid = ''; // User ID to identify the user

  @override
  void initState() {
    super.initState();
    _getUserId(); // Fetch user ID from Firebase Auth on initialization
  }

  // Fetches the current user's UID from Firebase Authentication
  void _getUserId() {
    // Get UID directly from Firebase Auth
    final User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      setState(() {
        uid = currentUser.uid; // Store UID
      });
      print("Firebase Auth UID: $uid");
    } else {
      print("No user is signed in with Firebase Auth");
    }
  }

  // Called when dependencies change to initialize UserProvider and load photos
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userProvider = Provider.of<UserProvider>(context);

    // Fallback to Provider if UID from Firebase Auth is not available
    if (uid.isEmpty) {
      String providerUid = userProvider.getUid();
      if (providerUid.isNotEmpty) {
        setState(() {
          uid = providerUid;
        });
        print("Provider UID: $uid");
      }
    }
    _loadStoredPhotos(); // Load photos from Firestore if available
  }

  // Loads stored photos from Firestore for the current user
  Future<void> _loadStoredPhotos() async {
    DocumentSnapshot snapshot =
        await _firestore.collection('Profile').doc(uid).get();
    if (!mounted) return;

    if (snapshot.exists) {
      Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

      setState(() {
        favouritePhotos = List<String>.from(data?['favouritePhotos'] ?? []);
        nonFavouritePhotos =
            List<String>.from(data?['nonfavouritePhotos'] ?? []);
      });
    }
  }

  // Picks an image from the gallery and adds it to the appropriate list (favourite or non-favourite)
  Future<void> _pickImage(bool isFavourite) async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (!mounted) return;

    if (pickedFile != null) {
      setState(() {
        if (isFavourite) {
          localFavouritePhotos.add(pickedFile.path);
        } else {
          localNonFavouritePhotos.add(pickedFile.path);
        }
      });
    }
  }

  // Uploads an image to Firebase Storage and returns the URL
  Future<String> _uploadImage(File imageFile) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference ref =
          _storage.ref().child('childhood_photos/$fileName');
      await ref.putFile(imageFile); // Upload the image
      return await ref.getDownloadURL(); // Get and return the download URL
    } catch (e) {
      print('Error uploading image: $e');
      return '';
    }
  }

  // Saves the user's favourite and non-favourite photos to Firestore
  Future<void> _savePhotos() async {
    if (isSaving) return; // Prevent multiple presses while saving
    setState(() => isSaving = true);

    try {
      userProvider = Provider.of<UserProvider>(context, listen: false);
      String currentUid = userProvider.getUid(); // Get UID from provider

      // Fallback to Firebase Auth UID if provider UID is empty
      if (currentUid.isEmpty) {
        final User? firebaseUser = _auth.currentUser;
        if (firebaseUser == null) {
          throw Exception("User not authenticated");
        }
        currentUid = firebaseUser.uid;
        print("Using Firebase Auth UID: $currentUid");
      } else {
        print("Using Provider UID: $currentUid");
      }

      // Document reference for the user's profile
      DocumentReference userDoc =
          _firestore.collection('Profile').doc(uid);

      DocumentSnapshot snapshot = await userDoc.get();
      Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

      List<String> storedFavouritePhotos =
          List<String>.from(data?['favouritePhotos'] ?? []);
      List<String> storedNonFavouritePhotos =
          List<String>.from(data?['nonfavouritePhotos'] ?? []);

      // Upload new local photos
      List<String> uploadedFavouritePhotos = [];
      List<String> uploadedNonFavouritePhotos = [];

      for (String path in localFavouritePhotos) {
        String url = await _uploadImage(File(path)); // Upload favourite photo
        if (url.isNotEmpty) uploadedFavouritePhotos.add(url);
      }
      for (String path in localNonFavouritePhotos) {
        String url =
            await _uploadImage(File(path)); // Upload non-favourite photo
        if (url.isNotEmpty) uploadedNonFavouritePhotos.add(url);
      }

      // Remove deleted photos from stored lists
      storedFavouritePhotos
          .removeWhere((url) => deletedFavouritePhotos.contains(url));
      storedNonFavouritePhotos
          .removeWhere((url) => deletedNonFavouritePhotos.contains(url));

      // Merge uploaded and stored photos
      storedFavouritePhotos.addAll(uploadedFavouritePhotos);
      storedNonFavouritePhotos.addAll(uploadedNonFavouritePhotos);

      // Update Firestore with the new lists of photos
      await userDoc.set({
        'favouritePhotos': storedFavouritePhotos,
        'nonfavouritePhotos': storedNonFavouritePhotos,
      }, SetOptions(merge: true));

      if (!mounted) return;

      setState(() {
        favouritePhotos = storedFavouritePhotos;
        nonFavouritePhotos = storedNonFavouritePhotos;
        localFavouritePhotos.clear();
        localNonFavouritePhotos.clear();
        deletedFavouritePhotos.clear();
        deletedNonFavouritePhotos.clear();
      });

      widget.onCompletion(); // Notify the parent widget on completion
      Navigator.pop(context); // Navigate back after saving
    } catch (e) {
      print('Error saving photos: $e');
    } finally {
      setState(() => isSaving = false); // Reset the saving state
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomAppBar(
                title: "Personal Profile", // Title for the app bar
                onItemTapped: widget.onItemTapped,
                selectedIndex: widget.selectedIndex,
              ),
              const Text(
                "Childhood photos",
                style:
                    TextStyle(fontSize: 22, color: AppColours.brandBluePlusTwo),
              ),
              const Text(
                "Add favourite and non-favourite Photos of your Childhood",
                style: TextStyle(
                    fontSize: 14, color: AppColours.neutralGreyMinusOne),
              ),
              const SizedBox(height: 20),
              _buildPhotoSection("Favourite photos", favouritePhotos,
                  localFavouritePhotos, true), // Section for favourite photos
              _buildPhotoSection(
                  "Non-Favourite photos",
                  nonFavouritePhotos,
                  localNonFavouritePhotos,
                  false), // Section for non-favourite photos
              const SizedBox(height: 20),
              _buildSaveButton(), // Save button at the bottom
            ],
          ),
        ),
      ),
    );
  }

  // Builds the section for displaying photos
  Widget _buildPhotoSection(String title, List<String> networkPhotos,
      List<String> localPhotos, bool isFavourite) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey)),
            IconButton(
                icon: const Icon(Icons.add, color: AppColours.brandBluePlusTwo),
                onPressed: () => _pickImage(isFavourite)),
          ],
        ),
        const SizedBox(height: 10),
        Column(
          children: [
            ...networkPhotos
                .map((url) => _buildPhotoItem(url, true, isFavourite))
                .toList(),
            ...localPhotos
                .map((path) => _buildPhotoItem(path, false, isFavourite))
                .toList(),
          ],
        ),
      ],
    );
  }

  // Builds each individual photo item (either network or local)
  Widget _buildPhotoItem(String photo, bool isNetwork, bool isFavourite) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: isNetwork
            ? NetworkImage(photo)
            : FileImage(File(photo)) as ImageProvider,
        backgroundColor: Colors.grey[300],
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete, color: Colors.brown),
        onPressed: () {
          setState(() {
            if (isNetwork) {
              if (isFavourite) {
                deletedFavouritePhotos.add(photo);
                favouritePhotos.remove(photo);
              } else {
                deletedNonFavouritePhotos.add(photo);
                nonFavouritePhotos.remove(photo);
              }
            } else {
              if (isFavourite) {
                localFavouritePhotos.remove(photo);
              } else {
                localNonFavouritePhotos.remove(photo);
              }
            }
          });
        },
      ),
    );
  }

  // Builds the save button at the bottom of the page
  Widget _buildSaveButton() {
    return Center(
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: isSaving ? null : _savePhotos, // Disable if already saving
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColours.brandBlueMain,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          ),
          child: isSaving
              ? const CircularProgressIndicator(
                  color: Colors.white) // Show progress indicator if saving
              : const Text("Save",
                  style: TextStyle(
                      fontSize: 18, color: Colors.white)), // Save button text
        ),
      ),
    );
  }
}
