import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:llm_based_sat_app/firebase/firebase_helpers.dart';
import 'package:llm_based_sat_app/screens/auth/sign_in_page.dart';
import 'package:llm_based_sat_app/theme/app_colours.dart';
import 'package:llm_based_sat_app/utils/user_provider.dart';
import 'package:llm_based_sat_app/widgets/custom_button.dart';
import 'package:llm_based_sat_app/widgets/main_layout.dart';
import 'package:provider/provider.dart';
import '../widgets/custom_app_bar.dart';

/// A stateful widget representing the Help Centre page.
/// This page allows users to describe their issue, upload supporting files,
/// and submit the form for assistance.
class HelpCentrePage extends StatefulWidget {
  final Function(int) onItemTapped;
  final int selectedIndex;

  const HelpCentrePage({
    Key? key,
    required this.onItemTapped,
    required this.selectedIndex,
  }) : super(key: key);

  @override
  State<HelpCentrePage> createState() => _HelpCentrePageState();
}

class _HelpCentrePageState extends State<HelpCentrePage> {
  final TextEditingController _textController = TextEditingController();
  final int _maxChars = 250;

  // List to store the selected file paths.
  List<String> _selectedFiles = [];

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    String uid = userProvider.getUid();
    return MainLayout(
      selectedIndex: widget.selectedIndex,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: ListView(
          children: [
            CustomAppBar(
              title: "Help Centre",
              onItemTapped: widget.onItemTapped,
              selectedIndex: widget.selectedIndex,
            ),
            SizedBox(height: 20),

            Text(
              "Tell us the problem",
              style: TextStyle(
                color: AppColours.primaryGreyTextColor,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),

            _buildIssueInputField(),
            SizedBox(height: 20),

            // File upload section.
            _buildFileUploadButton(),
            SizedBox(height: 10),

            // Show selected files (if any).
            if (_selectedFiles.isNotEmpty) _buildSelectedFilesList(),

            SizedBox(height: 30),
            CustomButton(
              buttonText: "Submit",
              onPress: () async {
                if (_textController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Please describe your issue.")),
                  );
                  return;
                }
                try {
                  // Show a loading indicator (optional).
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Submitting your issue...")),
                  );
                  // Upload each file and collect their URLs.
                  List<String> uploadedUrls = [];
                  for (String filePath in _selectedFiles) {
                    File file = File(filePath);
                    String fileName = filePath.split('/').last;
                    String uploadedUrl = await uploadPhoto(
                      file,
                      'reported_issues/${DateTime.now().millisecondsSinceEpoch}_$fileName',
                    );
                    uploadedUrls.add(uploadedUrl);
                  }
                  // Save the issue to Firestore.
                  await saveReportedIssue(
                    userId: uid, // Replace with the actual user ID.
                    issue: _textController.text,
                    mediaURLs: uploadedUrls,
                  );
                  // Clear fields and notify the user.
                  setState(() {
                    _textController.clear();
                    _selectedFiles.clear();
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Issue submitted successfully!")),
                  );
                } catch (e) {
                  // Handle errors and notify the user.
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Error submitting issue: $e")),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIssueInputField() {
    return Container(
      decoration: BoxDecoration(
        color: AppColours.avatarBackgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Stack(
        children: [
          TextField(
            controller: _textController,
            maxLines: 6,
            onChanged: (value) {
              setState(() {
                if (value.length > _maxChars) {
                  _textController.text = value.substring(0, _maxChars);
                  _textController.selection = TextSelection.fromPosition(
                    TextPosition(offset: _textController.text.length),
                  );
                }
              });
            },
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "My issue is...",
              hintStyle: const TextStyle(
                color: AppColours.primaryGreyTextColor,
                fontSize: 16,
              ),
              counterText: "",
            ),
          ),
          Positioned(
            left: 0,
            bottom: 0,
            child: Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 4),
              child: Text(
                "*${_maxChars - _textController.text.length} Characters Remaining",
                style: const TextStyle(
                  color: AppColours.primaryGreyTextColor,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the file upload button.
  Widget _buildFileUploadButton() {
    return GestureDetector(
      onTap: _pickFiles,
      child: Container(
        decoration: BoxDecoration(
          color: AppColours.avatarBackgroundColor,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.cloud_upload, color: Color(0xFF1C548C), size: 40),
            SizedBox(height: 10),
            Text(
              "Upload Supporting Files\n(e.g., screenshots, videos)",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColours.primaryGreyTextColor,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a list view of the selected files.
  Widget _buildSelectedFilesList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Selected Files:",
          style: TextStyle(
            fontSize: 16,
            color: AppColours.primaryGreyTextColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: _selectedFiles.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: Icon(Icons.insert_drive_file, color: Colors.grey),
              title: Text(
                _selectedFiles[index].split('/').last,
                style: TextStyle(
                  color: AppColours.primaryGreyTextColor,
                  fontSize: 14,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  setState(() {
                    _selectedFiles.removeAt(index);
                  });
                },
              ),
            );
          },
        ),
      ],
    );
  }

  /// Handles the file selection process.
  Future<void> _pickFiles() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _selectedFiles = result.files.map((file) => file.path!).toList();
      });
    }
  }
}
