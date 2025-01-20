import 'package:flutter/material.dart';
import 'package:llm_based_sat_app/theme/app_colours.dart';
import 'package:llm_based_sat_app/screens/personal_info_page.dart';
import 'package:llm_based_sat_app/screens/personal_profile_page.dart';
import 'package:llm_based_sat_app/widgets/custom_app_bar.dart';

class ChildhoodPhotosPage extends StatelessWidget {
  final Function(int) onItemTapped;
  final int selectedIndex;

  const ChildhoodPhotosPage({
    super.key,
    required this.onItemTapped,
    required this.selectedIndex,
  });

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
                  onItemTapped: onItemTapped,
                  selectedIndex: selectedIndex),
              const Text(
                "Childhood photos",
                style: TextStyle(fontSize: 22, color: AppColours.brandBluePlusTwo),
              ),
              const Text(
                "Add favourite and non-favourite Photos of your Childhood",
                style: TextStyle(fontSize: 14, color: AppColours.neutralGreyMinusOne),
              ),
              const SizedBox(height: 20),
              _buildPhotoSection("Favourite photos"),
              _buildPhotoSection("Non-Favourite photos"),
              const SizedBox(height: 20),
              _buildSaveButton(context),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.photo), label: "Photos"),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: "Settings"),
        ],
      ),
    );
  }

  Widget _buildPhotoSection(String title) {
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
                color: AppColours.brandBluePlusTwo,
              ),
            ),
            const Icon(Icons.add, color: AppColours.brandBluePlusTwo),
          ],
        ),
        const SizedBox(height: 10),
        _buildPhotoItem("photo_name.jpg", "Uploaded Successfully!", true),
        _buildPhotoItem("photo_name.jpg", "Uploaded Successfully!", true),
        _buildPhotoItem("photo_name.jpg", "Processing...", false),
      ],
    );
  }

  Widget _buildPhotoItem(String fileName, String status, bool uploaded) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey[300],
        backgroundImage:
            uploaded ? const AssetImage('assets/images/nature.png') : null,
      ),
      title: Text(
        fileName,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        status,
        style: TextStyle(
          fontSize: 14,
          color: uploaded ? Colors.green : Colors.orange,
        ),
      ),
      trailing: const Icon(Icons.delete, color: Colors.brown),
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return Center(
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: () {
            // the save button should navigate back to the personal profile page
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => PersonalProfilePage()));
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColours.brandBlueMain,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          child: const Text("Save",
              style: TextStyle(fontSize: 18, color: Colors.white)),
        ),
      ),
    );
  }
}
