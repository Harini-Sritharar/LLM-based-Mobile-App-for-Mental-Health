import 'package:flutter/material.dart';
import 'package:llm_based_sat_app/data/cache_manager.dart';
import 'package:llm_based_sat_app/firebase/firebase_courses.dart';
import 'package:llm_based_sat_app/utils/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import '../models/firebase-exercise-uploader/interface/course_interface.dart';
import '../screens/auth/sign_in_page.dart';

/* This file defines a FirebaseVideoPlayer widget that streams and plays course-related introductory videos from Firebase Storage. It ensures that the video is watched and updates the cache and database accordingly.

 Parameters:
 - [course]: A Course object representing the course whose introductory video is being played */
class FirebaseVideoPlayer extends StatefulWidget {
  final Course course;
  const FirebaseVideoPlayer({Key? key, required this.course}) : super(key: key);

  @override
  _FirebaseVideoPlayerState createState() => _FirebaseVideoPlayerState();
}

class _FirebaseVideoPlayerState extends State<FirebaseVideoPlayer> {
  late VideoPlayerController _controller;
  bool _isLoading = true;
  late UserProvider userProvider;
  late String uid;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userProvider = Provider.of<UserProvider>(context);
    uid = userProvider.getUid();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    // Initialize the video controller with the provided video URL
    _controller = VideoPlayerController.networkUrl(Uri.parse(
        'https://firebasestorage.googleapis.com/v0/b/llm-based-sat-app.firebasestorage.app/o/introductory_videos%2F${widget.course.id}.mp4?alt=media&token=ab6614f3-d0d9-4d4e-a365-e96565039b5e'))
      ..initialize().then((_) {
        setState(() {
          _isLoading = false;
        });
        _controller.setLooping(false); // Optional: Loop the video
        _controller.play(); // Optional: Auto-play the video

        // Update cache and database to indicate intro video has been watched if doesn't exist in cache
        if (CacheManager.getValue("${widget.course.id}_introductory_video") ==
                null ||
            CacheManager.getValue("${widget.course.id}_introductory_video") ==
                false) {
          CacheManager.setValue("${widget.course.id}_introductory_video", true);
          updateWatchedIntroductoryVideo(uid, widget.course.id, true);
        }
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
      appBar: AppBar(title: Text(widget.course.id)),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9, // Limit width
                  height:
                      MediaQuery.of(context).size.height * 0.5, // Limit height
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
                  _controller.value.isPlaying
                      ? _controller.pause()
                      : _controller.play();
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
