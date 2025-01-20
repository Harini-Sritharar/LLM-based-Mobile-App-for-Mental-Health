import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:llm_based_sat_app/firebase_helpers.dart';
import 'dart:io';
import '../screens/auth/sign_in_page.dart';

import 'package:llm_based_sat_app/widgets/custom_app_bar.dart';

class ChildhoodPhotosPage extends StatefulWidget {
  static const Color primaryTextColor = Color(0xFF687078);
  static const Color secondaryTextColor = Color(0xFF123659);
  static const Color primaryButtonColor = Color(0xFF2F4A79);

  final Function(int) onItemTapped;
  final int selectedIndex;

  const ChildhoodPhotosPage({
    super.key,
    required this.onItemTapped,
    required this.selectedIndex,
  });

  @override
  State<ChildhoodPhotosPage> createState() => _ChildhoodPhotosPageState();
}

class _ChildhoodPhotosPageState extends State<ChildhoodPhotosPage> {
  final List<Map<String, dynamic>> favouritePhotos = [];
  final List<Map<String, dynamic>> nonFavouritePhotos = [];
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadInitialPhotos();
  }

  Future<void> _loadInitialPhotos() async {
    try {
      final favouritePhotoData =
          await getPhotosByCategory(userId: user!.uid, category: "Favourite");
      final nonFavouritePhotoData = await getPhotosByCategory(
          userId: user!.uid, category: "Non-Favourite");

      setState(() {
        favouritePhotos.addAll(favouritePhotoData);
        nonFavouritePhotos.addAll(nonFavouritePhotoData);
      });
    } catch (e) {
      // Handle errors, such as showing a message to the user
      debugPrint("Error loading photos: $e");
    }
  }

  Future<void> _pickImage(bool isFavourite) async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        final photoData = {
          'photoType': isFavourite ? "Favourite" : "Non-Favourite",
          'photoUrl': pickedFile.path, // Temporary URL from the local file path
          'photoName': pickedFile.name,
          'userId': user!.uid
        };
        if (isFavourite) {
          // uploadPhoto(photoFile: File(pickedFile.path), userId: user!.uid , photoType: "Favourite");
          favouritePhotos.add(photoData);
        } else {
          nonFavouritePhotos.add(photoData);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
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
              style: TextStyle(
                  fontSize: 22, color: ChildhoodPhotosPage.secondaryTextColor),
            ),
            const Text(
              "Add favourite and non-favourite Photos of your Childhood",
              style: TextStyle(
                  fontSize: 14, color: ChildhoodPhotosPage.primaryTextColor),
            ),
            const SizedBox(height: 20),
            _buildPhotoSection("Favourite photos", favouritePhotos, true),
            _buildPhotoSection(
                "Non-Favourite photos", nonFavouritePhotos, false),
            const SizedBox(height: 20),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoSection(
      String title, List<Map<String, dynamic>> photos, bool isFavourite) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ChildhoodPhotosPage.secondaryTextColor,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add,
                  color: ChildhoodPhotosPage.secondaryTextColor),
              onPressed: () => _pickImage(isFavourite),
            ),
          ],
        ),
        const SizedBox(height: 10),
        photos.isEmpty
            ? const Center(
                child: Text(
                  "No photos available.",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              )
            : Column(
                children: photos
                    .map((photoData) => _buildPhotoItem(photoData))
                    .toList(),
              ),
      ],
    );
  }

  Widget _buildPhotoItem(Map<String, dynamic> photoData) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(photoData['photoUrl']),
        backgroundColor: Colors.grey[300],
      ),
      title: Text(
        photoData['photoName'] ?? "Unknown File",
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete, color: Colors.brown),
        onPressed: () {
          setState(() {
            // Perform deletion logic, such as updating favouritePhotos/nonFavouritePhotos
            // This part will depend on how you maintain the lists
            favouritePhotos.removeWhere(
                (photo) => photo['photoName'] == photoData['photoName']);
            nonFavouritePhotos.removeWhere(
                (photo) => photo['photoName'] == photoData['photoName']);
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
          onPressed: () {
            // Clear the existing photos in the database
            removeUserDocuments(
                userId: user!.uid, collectionName: "ChildhoodPhotos");

            // Upload the favourite and non-favourite photos
            uploadPhotoListParallel(
              photoDataList: favouritePhotos,
              userId: user!.uid,
              photoType: "Favourite",
            );
            uploadPhotoListParallel(
              photoDataList: nonFavouritePhotos,
              userId: user!.uid,
              photoType: "Non-Favourite",
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: ChildhoodPhotosPage.primaryButtonColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          child: const Text(
            "Save",
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
