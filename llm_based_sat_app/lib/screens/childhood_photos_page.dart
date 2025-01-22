import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:llm_based_sat_app/firebase_helpers.dart';
import 'package:llm_based_sat_app/main.dart';
import 'package:llm_based_sat_app/theme/app_colours.dart';
import 'dart:io';
import '../screens/auth/sign_in_page.dart';
import 'package:llm_based_sat_app/screens/personal_info_page.dart';
import 'package:llm_based_sat_app/screens/personal_profile_page.dart';
import 'package:llm_based_sat_app/widgets/custom_app_bar.dart';

/// A StatefulWidget for managing and displaying childhood photos,
/// categorized into favourite and non-favourite.
/// Allows users to add, view, and delete photos and save the changes.
class ChildhoodPhotosPage extends StatefulWidget {
  final Function(int) onItemTapped; // Callback for bottom navigation bar taps.
  final int selectedIndex; // Current selected index in the navigation bar.

  const ChildhoodPhotosPage({
    super.key,
    required this.onItemTapped,
    required this.selectedIndex,
  });

  @override
  State<ChildhoodPhotosPage> createState() => _ChildhoodPhotosPageState();
}

class _ChildhoodPhotosPageState extends State<ChildhoodPhotosPage> {
  final ImagePicker _picker = ImagePicker();

  /// Method to pick an image from the gallery and categorize it as favourite or non-favourite.
  Future<void> _pickImage(bool isFavourite) async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        final photoData = {
          'photoType': isFavourite ? "Favourite" : "Non-Favourite",
          'photoUrl': pickedFile.path, // Local file path (temporary URL).
          'photoName': pickedFile.name, // File name of the photo.
          'userId': user!.uid // User ID for associating with the database.
        };

        if (isFavourite) {
          favouritePhotos.add(photoData);
        } else {
          nonFavouritePhotos.add(photoData);
        }
      });
    }
  }

  /// Builds the main UI of the page.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
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
                style: TextStyle(
                    fontSize: 22, color: AppColours.secondaryBlueTextColor),
              ),
              const Text(
                "Add favourite and non-favourite Photos of your Childhood",
                style: TextStyle(
                    fontSize: 14, color: AppColours.primaryGreyTextColor),
              ),
              const SizedBox(height: 20),
              _buildPhotoSection("Favourite photos", favouritePhotos, true),
              _buildPhotoSection(
                  "Non-Favourite photos", nonFavouritePhotos, false),
              const SizedBox(height: 20),
              _buildSaveButton(context),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds a photo section (Favourite or Non-Favourite).
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
                color: AppColours.secondaryBlueTextColor,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add,
                  color: AppColours.secondaryBlueTextColor),
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

  /// Builds a single photo item with delete functionality.
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
            // Remove the photo from the respective list.
            favouritePhotos.removeWhere(
                (photo) => photo['photoName'] == photoData['photoName']);
            nonFavouritePhotos.removeWhere(
                (photo) => photo['photoName'] == photoData['photoName']);
          });
        },
      ),
    );
  }

  /// Builds the save button to upload photos to the database and navigate back.
  Widget _buildSaveButton(BuildContext context) {
    return Center(
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: () {
            // Remove existing photos from the database.
            removeUserDocuments(
                userId: user!.uid, collectionName: "ChildhoodPhotos");

            // Upload the photos in parallel for both categories.
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

            // Navigate back to the personal profile page.
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => PersonalProfilePage()));
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColours.forwardArrowColor,
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
