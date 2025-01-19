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
  final List<File> favouritePhotos = [];
  final List<File> nonFavouritePhotos = [];

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(bool isFavourite) async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        if (isFavourite) {
          uploadPhoto(photoFile: File(pickedFile.path), userId: user!.uid , photoType: "Favourite");
          favouritePhotos.add(File(pickedFile.path));
        } else {
          nonFavouritePhotos.add(File(pickedFile.path));
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: widget.selectedIndex,
        onTap: widget.onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.photo), label: "Photos"),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: "Settings"),
        ],
      ),
    );
  }

  Widget _buildPhotoSection(String title, List<File> photos, bool isFavourite) {
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
        ...photos.map((photo) => _buildPhotoItem(photo)).toList(),
      ],
    );
  }

  Widget _buildPhotoItem(File photo) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: FileImage(photo),
        backgroundColor: Colors.grey[300],
      ),
      title: const Text(
        "Photo",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete, color: Colors.brown),
        onPressed: () {
          setState(() {
            favouritePhotos.remove(photo);
            nonFavouritePhotos.remove(photo);
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
