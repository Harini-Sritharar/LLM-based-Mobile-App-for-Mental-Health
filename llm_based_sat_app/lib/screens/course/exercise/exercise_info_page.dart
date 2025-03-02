import 'package:flutter/material.dart';
import 'package:llm_based_sat_app/models/firebase-exercise-uploader/interface/chapter_interface.dart';
import 'package:llm_based_sat_app/screens/course/exercise/exercise_info_page_helper.dart';
import 'package:llm_based_sat_app/theme/app_colours.dart';
import 'package:llm_based_sat_app/utils/user_provider.dart';
import 'package:llm_based_sat_app/widgets/custom_app_bar.dart';
import 'package:llm_based_sat_app/widgets/custom_button.dart';
import 'package:llm_based_sat_app/widgets/exercise_widgets/learning_tile.dart';
import 'package:llm_based_sat_app/widgets/exercise_widgets/checkbox_tile.dart';
import 'package:provider/provider.dart';
import '../../../data/cache_manager.dart';
import '../../../models/firebase-exercise-uploader/interface/course_interface.dart';
import '../../../models/firebase-exercise-uploader/interface/exercise_interface.dart';

/* This file defines the ExerciseInfoPage widget, which provides detailed information about a specific exercise. Users can review preparation steps, learning materials, and key objectives before starting the exercise.
Parameters:
- [course]: The Course object containing course-related details.
- [exercise]: The Exercise object representing the specific exercise being viewed.
- [chapter]: The Chapter object to which the exercise belongs.
- [onItemTapped]: Callback function to update the navigation bar index.
- [selectedIndex]: The current selected index of the navigation bar.
- [exerciseSession]: The current session count for the given exercise. */
class ExerciseInfoPage extends StatefulWidget {
  final Course course;
  final Exercise exercise;
  final Chapter chapter;
  final Function(int) onItemTapped; // Function to update navbar index
  final int selectedIndex; // Current selected index
  final int exerciseSession;

  const ExerciseInfoPage({
    super.key,
    required this.course,
    required this.exercise,
    required this.chapter,
    required this.onItemTapped,
    required this.selectedIndex,
    required this.exerciseSession,
  });

  @override
  _ExerciseInfoPageState createState() => _ExerciseInfoPageState();
}

class _ExerciseInfoPageState extends State<ExerciseInfoPage> {
  late UserProvider userProvider;
  late String uid;
  @override
  void dispose() {
    // Removes current step from cache so user must reset exercise
    CacheManager.removeValue(widget.exercise.id);
    super.dispose();
  }

  final Set<String> checkedTasks = {};

  bool get allRequiredChecked =>
      checkedTasks.length == widget.exercise.preExerciseTasks.length;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Access Provider here
    userProvider = Provider.of<UserProvider>(context); // listen: false?
    uid = userProvider.getUid();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
          title: widget.course.title,
          onItemTapped: widget.onItemTapped,
          selectedIndex: widget.selectedIndex),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Exercise ${widget.exercise.id.substring(widget.exercise.id.length - 1)}",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: AppColours.brandBluePlusThree),
            ),
            const SizedBox(height: 10),
            const Text(
              'Complete the preparation and learn more about the exercise before you can start practising.',
              style: TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 16),
            const Text(
              'Preparation',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF293138)),
            ),
            const SizedBox(height: 8),
            Column(
              children: [
                ...widget.exercise.preExerciseTasks.map((item) => CheckboxTile(
                      title: item,
                      icon: Icons.push_pin,
                      value: checkedTasks.contains(item),
                      onChanged: (bool? newValue) {
                        setState(() {
                          if (newValue == true) {
                            checkedTasks.add(item);
                          } else {
                            checkedTasks.remove(item);
                          }
                        });
                      },
                    ))
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Learning',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF293138)),
            ),
            const SizedBox(height: 8),
            Column(
              children: [
                LearningTile(
                  title: 'Aim',
                  icon: Icons.lightbulb,
                  subject: 'Aim',
                  content: widget.exercise.objective,
                ),
                LearningTile(
                  title: 'Theory',
                  icon: Icons.article,
                  subject: 'Theory',
                  content: getLearning(widget.exercise),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Minimum practice time:',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF293138)),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Color(0xFFCEDFF2),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Color(0xFF123659)),
                      ),
                      child: Text(
                        widget.exercise.minimumPracticeTime,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF062240)),
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Exercise session:',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF293138)),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                          color: Color(0xFFCEDFF2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Color(0xFF123659))),
                      child: Text(
                        (widget.exerciseSession + 1).toString(),
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF062240)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (allRequiredChecked) // Show button only when all Checkboxes are checked
              Center(
                child: CustomButton(
                  buttonText: 'Start Exercise',
                  onPress: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => getExerciseStep(widget.exercise,
                            widget.course, widget.chapter, uid),
                      ),
                    );
                  },
                  rightArrowPresent: true,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
