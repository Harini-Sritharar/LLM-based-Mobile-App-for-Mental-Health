import 'package:flutter/material.dart';
import 'package:llm_based_sat_app/screens/course/course_info_helper.dart';
import 'package:llm_based_sat_app/screens/course/course_page.dart';
import 'package:llm_based_sat_app/widgets/course_widgets/course_exercise_duration.dart';
import 'package:llm_based_sat_app/widgets/course_widgets/course_type_rating.dart';
import 'package:llm_based_sat_app/widgets/course_widgets/pre_course_list.dart';
import 'package:llm_based_sat_app/widgets/custom_app_bar.dart';
import 'package:llm_based_sat_app/widgets/expandable_text.dart';
import '../../models/firebase-exercise-uploader/interface/course_interface.dart';
import '../../widgets/firebase_video_player.dart';

class CourseInfo extends StatefulWidget {
  final Course course;
  final Function(int) onItemTapped;
  final int selectedIndex;

  const CourseInfo({
    super.key,
    required this.course,
    required this.onItemTapped,
    required this.selectedIndex,
  });

  @override
  _CourseInfoState createState() => _CourseInfoState();
}

class _CourseInfoState extends State<CourseInfo> {
  @override
  Widget build(BuildContext context) {
    Future.microtask(() {
      setState(() {}); // Triggers UI refresh after returning
    });
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
          title: "Courses",
          onItemTapped: widget.onItemTapped,
          selectedIndex: widget.selectedIndex),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CourseTypeRating(
                courseType: widget.course.courseType,
                rating: widget.course.rating),
            const SizedBox(height: 10),
            Text(
              widget.course.title,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 14),
            CourseExerciseDuration(
                exercises: getNumberOfExercises(widget.course),
                duration: widget.course.duration),
            const SizedBox(height: 20),
            ExpandableText(
                // Course Aim
                text: widget.course.aim),
            const SizedBox(height: 40),
            PreCourseList(
              // TODO
              // prerequisites: course.prerequisites,
              prerequisites: [],
              onUploadChildhoodPhotosPressed: (BuildContext context) {},
              onWatchIntroductoryVideoPressed: (BuildContext context) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FirebaseVideoPlayer(
                            course: widget.course,
                          )),
                );
                setState(() {}); // Refresh after returning;
              },
              onStartCoursePressed: (BuildContext context) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CoursePage(
                      course: widget.course,
                      courseTitle: widget.course.title,
                      chapters: getChapters(widget.course, widget.onItemTapped,
                          widget.selectedIndex),
                      onItemTapped: widget.onItemTapped,
                      selectedIndex: widget.selectedIndex,
                    ),
                  ),
                );
              },
              watchedIntroductoryVideo:
                  getWatchedIntroductoryVideo(widget.course),
              childhoodPhotosUploaded:
                  getChildhoodPhotosUploaded(widget.course),
              course: widget.course,
            ),
          ],
        ),
      ),
    );
  }
}
