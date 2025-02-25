import 'package:flutter/material.dart';
import 'package:llm_based_sat_app/firebase/firebase_helpers.dart';
import 'package:llm_based_sat_app/screens/auth/sign_in_page.dart';
import 'package:llm_based_sat_app/screens/score/score_page.dart'; // Import the ScoresPage
import 'package:llm_based_sat_app/theme/app_colours.dart';
import 'package:llm_based_sat_app/widgets/custom_app_bar.dart';
import 'package:llm_based_sat_app/firebase/firebase_score.dart';
import 'package:llm_based_sat_app/screens/course/courses_helper.dart';
import 'package:llm_based_sat_app/widgets/course_widgets/course_card.dart';

import '../widgets/score_widgets/circular_progress_bar.dart';

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
              future: getFirstName(user!.uid),
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
            _buildTasksCard(),
            const SizedBox(height: 16),
            _buildCoursesSection(),
            const SizedBox(height: 16),
            _buildDailyQuote(),
          ],
        ),
      ),
    );
  }

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
                    builder: (context) => ScorePage(
                          onItemTapped: (int) {},
                          selectedIndex: 0,
                        )),
              );
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

  Widget _buildTasksCard() {
    return Card(
      color: AppColours.brandBlueMinusTwo,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
            _buildTaskItem("Upload Childhood Photos", true),
            _buildTaskItem("Practise Exercise A", false),
            _buildTaskItem("Learn Song", false),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskItem(String task, bool completed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            task,
            style: TextStyle(color: AppColours.brandBluePlusTwo, fontSize: 16),
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
    );
  }

  Widget _buildCoursesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "My courses",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        FutureBuilder<List<CourseCard>>(
          future: generateCourseCards(onItemTapped, selectedIndex),
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

  Widget _buildDailyQuote() {
    return Card(
      color: Colors.blue[100],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: const [
            Text(
              "Daily Quote",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              '“The only true wisdom is in knowing you know nothing.”\n\nSocrates',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }
}
