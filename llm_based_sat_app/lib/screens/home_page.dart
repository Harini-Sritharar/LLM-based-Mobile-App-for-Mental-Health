import 'package:flutter/material.dart';
import 'package:llm_based_sat_app/firebase/firebase_courses.dart';
import 'package:llm_based_sat_app/firebase/firebase_helpers.dart';
import 'package:llm_based_sat_app/main.dart';
import 'package:llm_based_sat_app/screens/auth/sign_in_page.dart';
import 'package:llm_based_sat_app/screens/course/courses.dart';
import 'package:llm_based_sat_app/screens/score/score_page.dart'; // Import the ScoresPage
import 'package:llm_based_sat_app/theme/app_colours.dart';
import 'package:llm_based_sat_app/utils/user_provider.dart';
import 'package:llm_based_sat_app/widgets/custom_app_bar.dart';
import 'package:llm_based_sat_app/firebase/firebase_score.dart';
import 'package:llm_based_sat_app/screens/course/courses_helper.dart';
import 'package:llm_based_sat_app/widgets/course_widgets/course_card.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

import '../widgets/score_widgets/circular_progress_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart'; // Add this import for date formatting

/// The HomePage widget is the main screen of the application, displaying
/// various sections such as the user's score, tasks, courses, and a daily quote.
class HomePage extends StatelessWidget {
  final Function(int) onItemTapped;
  final int selectedIndex;

  const HomePage({
    Key? key,
    required this.onItemTapped,
    required this.selectedIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    String uid = userProvider.getUid();
    return Scaffold(
      appBar: CustomAppBar(
        title: "InvinciMind",
        onItemTapped: onItemTapped,
        selectedIndex: selectedIndex,
        backButton: false,
        image: AssetImage('assets/images/Logo.png'), // Pass the Logo.png image
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<String>(
              future: getFirstName(uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text(
                    "Welcome, ...",
                    style: TextStyle(
                        fontSize: 22, color: AppColours.primaryGreyTextColor),
                  );
                } else if (snapshot.hasError) {
                  return Text(
                    "Welcome, User",
                    style: TextStyle(
                        fontSize: 22, color: AppColours.primaryGreyTextColor),
                  );
                } else {
                  return Text(
                    "Welcome, ${snapshot.data}",
                    style: TextStyle(
                        fontSize: 22, color: AppColours.primaryGreyTextColor),
                  );
                }
              },
            ),
            const SizedBox(height: 16),
            _buildScoreCard(context), // Pass context to _buildScoreCard
            const SizedBox(height: 16),
            _buildTasksCard(uid),
            const SizedBox(height: 16),
            _buildCoursesSection(uid),
            const SizedBox(height: 16),
            _buildDailyQuote(),
          ],
        ),
      ),
    );
  }

  /// Builds the score card section which displays the user's overall score.
  Widget _buildScoreCard(BuildContext context) {
    return FutureBuilder<double>(
      future: getOverallScore(), // Fetch the overall score
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text("Error loading score");
        } else {
          double score = snapshot.data ?? 0.0;
          return InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MainScreen(
                            initialIndex: 3,
                          )));
            },
            child: Card(
              color: AppColours.brandBlueMinusThree,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Your Score",
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColours.brandBluePlusThree),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: CircularProgressBar(
                          percentage: score, title: "Overall", inMiddle: true),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }

  /// Builds the tasks card section which displays the tasks for the day.
  Widget _buildTasksCard(String uid) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: getTasks(uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text("Error loading tasks");
        } else {
          List<Map<String, dynamic>> tasks = snapshot.data ?? [];
          return Card(
            color: AppColours.brandBlueMinusTwo,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Tasks Today",
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColours.brandBluePlusThree),
                  ),
                  const SizedBox(height: 8),
                  if (tasks.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: AppColours.brandBlueMinusOne,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.task_alt,
                              color: AppColours.brandBluePlusThree,
                              size: 48,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "No tasks for today. Try starting a course!",
                              style: TextStyle(
                                fontSize: 18,
                                color: AppColours.white,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    for (var task in tasks)
                      _buildTaskItem(context, task["task"], task["completed"]),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  /// Builds a single task item with a task name and completion status.
  Widget _buildTaskItem(BuildContext context, String task, bool completed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MainScreen(
                        initialIndex: 4,
                      )));
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              formatTask(task),
              style:
                  TextStyle(color: AppColours.brandBluePlusTwo, fontSize: 16),
            ),
            completed
                ? Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFCEF2DE),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Icon(Icons.check_box, color: Color(0xFF1C8C4E)),
                  )
                : const Icon(Icons.arrow_forward_ios,
                    color: AppColours.brandBluePlusTwo),
          ],
        ),
      ),
    );
  }

  /// Builds the courses section which displays the user's courses.
  Widget _buildCoursesSection(String uid) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "My courses",
          style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColours.brandBluePlusThree),
        ),
        const SizedBox(height: 8),
        FutureBuilder<List<CourseCard>>(
          future: generateCourseCards(onItemTapped, selectedIndex, uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError ||
                !snapshot.hasData ||
                snapshot.data!.isEmpty) {
              return Center(
                child: Text(
                  'No courses available.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              );
            } else {
              return Column(
                children: snapshot.data!,
              );
            }
          },
        ),
      ],
    );
  }

  /// Builds the daily quote section which displays a motivational quote.
  Widget _buildDailyQuote() {
    return FutureBuilder<Map<String, dynamic>>(
      future: fetchDailyQuote(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          final defaultQuote = 'Believe you can and you\'re halfway there.';
          final defaultAuthor = 'Theodore Roosevelt';
          return Card(
            color: Colors.blue[100],
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Daily Quote",
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColours.brandBluePlusThree),
                  ),
                  const SizedBox(height: 8),
                  Text.rich(
                    TextSpan(
                      text: '“$defaultQuote”\n\n',
                      style: const TextStyle(
                        fontSize: 24,
                        fontStyle: FontStyle.italic,
                      ),
                      children: [
                        TextSpan(
                          text: defaultAuthor,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        } else {
          final quote = snapshot.data?['content'] ?? 'No quote available';
          final author = snapshot.data?['author'] ?? 'Unknown';
          return Card(
            color: Colors.blue[100],
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Daily Quote",
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColours.brandBluePlusThree),
                  ),
                  const SizedBox(height: 8),
                  Text.rich(
                    TextSpan(
                      text: '“$quote”\n\n',
                      style: const TextStyle(
                        fontSize: 24,
                        fontStyle: FontStyle.italic,
                      ),
                      children: [
                        TextSpan(
                          text: author,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  /// Fetches the daily quote from a remote API or from local storage if already fetched.
  Future<Map<String, dynamic>> fetchDailyQuote() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedQuote = prefs.getString('dailyQuote');
    String? storedAuthor = prefs.getString('dailyAuthor');
    String? storedDate = prefs.getString('quoteDate');

    String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    if (storedQuote != null &&
        storedAuthor != null &&
        storedDate == todayDate) {
      return {'content': storedQuote, 'author': storedAuthor};
    } else {
      final response =
          await http.get(Uri.parse('http://api.quotable.io/random'));
      if (response.statusCode == 200) {
        Map<String, dynamic> quoteData = json.decode(response.body);
        await prefs.setString('dailyQuote', quoteData['content']);
        await prefs.setString('dailyAuthor', quoteData['author']);
        await prefs.setString('quoteDate', todayDate);
        return quoteData;
      } else {
        throw Exception('Failed to load quote');
      }
    }
  }

  Future<List<Map<String, dynamic>>> getTasks(String uid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedDate = prefs.getString('tasksDate');
    String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    if (storedDate == todayDate) {
      // Load tasks from SharedPreferences if they are already set for today
      // Tasks will be saved in the format [{"task": "Course_Exercise", "completed": false}]
      // Example  [{"task": "Self-Attachment_A", "completed": false}]
      String? storedTasks = prefs.getString('tasks');
      if (storedTasks != "") {
        print("Tasks loaded from SharedPreferences");
        print(storedTasks);
        List<dynamic> tasksJson = json.decode(storedTasks!);
        return tasksJson
            .map((task) => Map<String, dynamic>.from(task))
            .toList();
      }
    }

    // Fetch the user's started courses
    List<String> startedCourses = await getStartedCourses(uid);
    List<Map<String, dynamic>> tasks = [];

    if (startedCourses.isEmpty) {
      // Default tasks if no courses have been started
      tasks = [
        {"task": "Self-Attachment_A", "completed": false},
        {"task": "Self-Attachment_B", "completed": false},
        {"task": "Self-Attachment_C", "completed": false},
      ];
    } else {
      for (String course in startedCourses) {
        (String?, String?) currentChapterAndExercise =
            await getCurrentChapterAndExerciseForCourse(uid, course);

        String? currentChapter = currentChapterAndExercise.$1;
        String? currentExercise = currentChapterAndExercise.$2;

        print(
            "$course on chapter: $currentChapter on exercise: $currentExercise");

        if (currentChapter == null || currentExercise == null) continue;

        // Get all incompleted exercises in the latest chapter
        List<String> incompletedExercises =
            await getIncompleteExercisesInLatestChapter(uid, course);

        if (incompletedExercises.isEmpty) {
          // Get the last chapter of this course dynamically
          String? lastChapter = await getLastChapter(course);
          print("last chapter from course is $lastChapter");
          if (lastChapter == null) continue;

          // Check if the latest chapter is the last chapter of the course
          if (currentChapter == lastChapter) {
            // Skip this course entirely as the user has completed it.
            continue;
          } else {
            // Determine the next chapter by incrementing the current chapter number
            int currentChapterNumber =
                int.parse(currentChapter.split(' ').last);
            String nextChapter = 'Chapter ${currentChapterNumber + 1}';

            // Get all exercises of the next chapter
            List<String> nextChapterExercises =
                await getAllExercisesInChapter(course, nextChapter);
            if (nextChapterExercises.isEmpty) continue;

            // Recommend all exercises in the next chapter
            for (String exercise in nextChapterExercises) {
              // Add the task in the format Course_Exercise
              tasks.add({
                "task": "${course}_${exercise.split('_').last}",
                "completed": false
              });
              print("Added task: ${course}_${exercise.split('_').last}");
            }
          }
        } else {
          // Add all incompleted exercises in the current chapter
          for (String exercise in incompletedExercises) {
            tasks.add({
              "task": "${course}_${exercise.split("_").last}",
              "completed": false
            });
            print("Added task: ${course}_${exercise.split('_').last}");
          }
        }
      }

      // Limit to 3 tasks per day
      tasks = tasks.take(3).toList();
    }

    // Save tasks to SharedPreferences
    await prefs.setString('tasks', json.encode(tasks));
    await prefs.setString('tasksDate', todayDate);

    return tasks;
  }

  /// Converts a task string from the format Course_Exercise to 'Course Exercise X'.
  String formatTask(String task) {
    List<String> parts = task.split('_');
    if (parts.length == 2) {
      return '${parts[0]} Exercise ${parts[1]}';
    } else {
      return task; // Return the original task if it doesn't match the expected format
    }
  }
}
