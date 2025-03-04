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

class ChildhoodPhotosPage extends StatefulWidget {
  final Function(int) onItemTapped;
  final int selectedIndex;
  final VoidCallback onCompletion;

  const ChildhoodPhotosPage({
    super.key,
    required this.onItemTapped,
    required this.selectedIndex,
    required this.onCompletion,
  });

  @override
  State<ChildhoodPhotosPage> createState() => _ChildhoodPhotosPageState();
}

class _ChildhoodPhotosPageState extends State<ChildhoodPhotosPage> {
  final ImagePicker _picker = ImagePicker();
  List<String> favouritePhotos = [];
  List<String> nonFavouritePhotos = [];
  List<String> localFavouritePhotos = [];
  List<String> localNonFavouritePhotos = [];
  List<String> deletedFavouritePhotos = [];
  List<String> deletedNonFavouritePhotos = [];
  bool isSaving = false;
  late UserProvider userProvider;
  String uid = '';

  @override
  void initState() {
    super.initState();
    _getUserId();
  }

  void _getUserId() {
    // Get UID directly from Firebase Auth
    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      setState(() {
        uid = currentUser.uid;
      });
      print("Firebase Auth UID: $uid");
    } else {
      print("No user is signed in with Firebase Auth");
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userProvider = Provider.of<UserProvider>(context);
    if (uid.isEmpty) {
      String providerUid = userProvider.getUid();
      if (providerUid.isNotEmpty) {
        setState(() {
          uid = providerUid;
        });
        print("Provider UID: $uid");
      }
    }
    _loadStoredPhotos();
  }

  Future<void> _loadStoredPhotos() async {
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection('Profile').doc(uid).get();
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

  Future<String> _uploadImage(File imageFile) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference ref =
          FirebaseStorage.instance.ref().child('childhood_photos/$fileName');
      await ref.putFile(imageFile);
      return await ref.getDownloadURL();
    } catch (e) {
      print('Error uploading image: $e');
      return '';
    }
  }

  Future<void> _savePhotos() async {
    if (isSaving) return; // Prevent multiple presses
    setState(() => isSaving = true);

    try {
      // Double-check UID at save time - might have changed since page loaded
      userProvider = Provider.of<UserProvider>(context, listen: false);
      String currentUid = userProvider.getUid();

      print("Original uid: '$uid', Current uid: '$currentUid'"); // Debug info

      // Fallback to Firebase Auth if Provider fails
      if (currentUid.isEmpty) {
        final User? firebaseUser = FirebaseAuth.instance.currentUser;
        if (firebaseUser == null) {
          throw Exception("User not authenticated");
        }
        currentUid = firebaseUser.uid;
        print("Using Firebase Auth UID: $currentUid");
      } else {
        print("Using Provider UID: $currentUid");
      }

      DocumentReference userDoc =
          FirebaseFirestore.instance.collection('Profile').doc(uid);

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
        String url = await _uploadImage(File(path));
        if (url.isNotEmpty) uploadedFavouritePhotos.add(url);
      }
      for (String path in localNonFavouritePhotos) {
        String url = await _uploadImage(File(path));
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

      // Update Firestore
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

      widget.onCompletion();
      Navigator.pop(context);
    } catch (e) {
      print('Error saving photos: $e');
    } finally {
      setState(() => isSaving = false);
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
                title: "Personal Profile",
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
                  localFavouritePhotos, true),
              _buildPhotoSection("Non-Favourite photos", nonFavouritePhotos,
                  localNonFavouritePhotos, false),
              const SizedBox(height: 20),
              _buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

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

  Widget _buildSaveButton() {
    return Center(
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: isSaving ? null : _savePhotos,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColours.brandBlueMain,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          ),
          child: isSaving
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text("Save",
                  style: TextStyle(fontSize: 18, color: Colors.white)),
        ),
      ),
    );
  }
}
