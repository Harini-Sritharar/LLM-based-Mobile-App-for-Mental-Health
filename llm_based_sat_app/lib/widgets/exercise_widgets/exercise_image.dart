import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:llm_based_sat_app/data/cache_manager.dart';

/* A widget that displays an exercise-related image. The image is retrieved from a cache based on the provided `imageType` ("Happy" or "Sad"). If no cached images exist, a default image is loaded from assets. The widget ensures smooth loading by displaying a progress indicator until the image is available. */
class ExerciseImage extends StatefulWidget {
  final String imageType; // "Happy" or "Sad"

  const ExerciseImage({super.key, required this.imageType});

  @override
  State<ExerciseImage> createState() => _ExerciseImageState();
}

class _ExerciseImageState extends State<ExerciseImage> {
  // Stores the currently displayed image as `Uint8List` (binary data).
  Uint8List? imageData;

  @override
  void initState() {
    super.initState();
    loadImage();
  }

  /* Loads the image based on `imageType` and updates the state. If no cached images exist, a default image is loaded instead. */
  Future<void> loadImage() async {
    Uint8List image = await getNextImage(widget.imageType);
    setState(() {
      imageData = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0), // Consistent style
      ),
      child: Center(
        child: imageData != null
            ? Image.memory(
                imageData!,
                fit: BoxFit.cover,
              )
            : const CircularProgressIndicator(), // Loading state
      ),
    );
  }

  // Returns a default image from assets when no cached images are available. This function loads the image file `assets/images/nature.png` and converts it to `Uint8List`.
  Future<Uint8List> getDefaultImage() async {
    ByteData bytes = await rootBundle.load("assets/images/nature.png");
    return bytes.buffer.asUint8List();
  }

  /* Retrieves the next image from the cache based on `type` ("Happy" or "Sad").
  - If images exist in the cache, it retrieves the next image in sequence.
  - If no images exist, it returns the default image from assets. */
  Future<Uint8List> getNextImage(String type) async {
    List<Uint8List>? images = CacheManager.getValue(type);
    print(images);

    if (images == null || images.isEmpty) {
      return await getDefaultImage(); // Return default image
    }

    int currentIndex = CacheManager.getValue("${type}_current_index") ?? 0;
    Uint8List imageData = images[currentIndex];

    // Update index for next retrieval (looping)
    CacheManager.setValue(
        "${type}_current_index", (currentIndex + 1) % images.length);

    return imageData;
  }
}
