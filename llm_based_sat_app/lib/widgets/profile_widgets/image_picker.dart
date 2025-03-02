import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

class ImagePickerWidget extends StatefulWidget {
  final void Function(File? image)? onImagePicked;

  const ImagePickerWidget({Key? key, this.onImagePicked}) : super(key: key);

  @override
  _ImagePickerState createState() => _ImagePickerState();
}

class _ImagePickerState extends State<ImagePickerWidget> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    if (Platform.isIOS) {
      var status = await Permission.photos.request();

      if (status.isGranted) {
        try {
          final XFile? pickedFile = await _picker.pickImage(
            source: ImageSource.gallery,
            requestFullMetadata: false, // Fixes potential crash on iOS
          );

          if (pickedFile != null) {
            setState(() {
              _selectedImage = File(pickedFile.path);
            });
            widget.onImagePicked?.call(_selectedImage);
          }
        } catch (e) {
          print('Error picking image: $e');
        }
      } else if (status.isDenied) {
        print('Photo permission denied.');
      } else if (status.isPermanentlyDenied) {
        openAppSettings(); // Opens settings so the user can enable manually
      }
    } else {
      try {
        final XFile? pickedFile = await _picker.pickImage(
          source: ImageSource.gallery,
        );

        if (pickedFile != null) {
          setState(() {
            _selectedImage = File(pickedFile.path);
          });
          widget.onImagePicked?.call(_selectedImage);
        }
      } catch (e) {
        print('Error picking image: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Circular profile picture or default image
        ClipOval(
            child: _selectedImage != null
                ? Image.file(
                    _selectedImage!,
                    width: 150,
                    height: 150,
                    fit: BoxFit.cover,
                  )
                : Container(
                    width: 200,
                    height: 200,
                    color: Color(0xFFCEDFF2),
                    child:
                        Icon(Icons.person, size: 150, color: Color(0XFFF2F9FF)),
                  )),
        // Floating button overlay
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: _pickImage,
            child: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.blue,
              child: Icon(
                Icons.camera_alt_outlined,
                size: 30,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
