import 'package:flutter/material.dart';
import 'package:llm_based_sat_app/widgets/custom_app_bar.dart';

class ChildhoodPhotosPage extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomAppBar(
                title: "Personal Profile",
                onItemTapped: onItemTapped,
                selectedIndex: selectedIndex),
            const Text(
              "Childhood photos",
              style: TextStyle(fontSize: 22, color: secondaryTextColor),
            ),
            const Text(
              "Add favourite and non-favourite Photos of your Childhood",
              style: TextStyle(fontSize: 14, color: primaryTextColor),
            ),
            const SizedBox(height: 20),
            _buildPhotoSection("Favourite photos"),
            _buildPhotoSection("Non-Favourite photos"),
            const SizedBox(height: 20),
            _buildSaveButton(),
          ],
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
                color: secondaryTextColor,
              ),
            ),
            const Icon(Icons.add, color: secondaryTextColor),
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
            uploaded ? const AssetImage('assets/sample.jpg') : null,
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

  Widget _buildSaveButton() {
    return Center(
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryButtonColor,
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
