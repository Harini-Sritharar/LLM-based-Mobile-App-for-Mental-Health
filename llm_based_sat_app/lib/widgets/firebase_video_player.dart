import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class LocalVideoPlayer extends StatefulWidget {
  const LocalVideoPlayer({Key? key}) : super(key: key);

  @override
  _LocalVideoPlayerState createState() => _LocalVideoPlayerState();
}

class _LocalVideoPlayerState extends State<LocalVideoPlayer> {
  late VideoPlayerController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    // Initialize the video controller with the provided video URL
    _controller = VideoPlayerController.networkUrl(Uri.parse(
        'https://firebasestorage.googleapis.com/v0/b/llm-based-sat-app.firebasestorage.app/o/introductory_videos%2FKohli%20creams%20a%20classic%20cover%20drive.mp4?alt=media&token=d5c2d47f-869a-474b-90f6-40750b0b7c37'))
      ..initialize().then((_) {
        setState(() {
          _isLoading = false;
        });
        _controller.setLooping(true); // Optional: Loop the video
        _controller.play(); // Optional: Auto-play the video
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Local Video Player')),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9, // Limit width
                  height: MediaQuery.of(context).size.height * 0.5, // Limit height
                  child: FittedBox(
                    fit: BoxFit.contain, // Ensures the video fits within bounds
                    child: SizedBox(
                      width: _controller.value.size.width,
                      height: _controller.value.size.height,
                      child: VideoPlayer(_controller),
                    ),
                  ),
                ),
              ),
      ),
      floatingActionButton: !_isLoading
          ? FloatingActionButton(
              onPressed: () {
                setState(() {
                  _controller.value.isPlaying ? _controller.pause() : _controller.play();
                });
              },
              child: Icon(
                _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
              ),
            )
          : null,
    );
  }
}
