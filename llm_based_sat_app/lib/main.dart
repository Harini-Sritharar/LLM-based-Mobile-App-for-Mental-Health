import 'package:flutter/material.dart';
import 'package:llm_based_sat_app/screens/exercise_page.dart';
import 'screens/community_page.dart';
import 'screens/calendar_page.dart';
import 'screens/courses_page.dart';
import 'screens/home_page.dart';
import 'screens/score_page.dart';
import 'widgets/bottom_nav_bar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Navigation',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 2; // Default to Home page

  final List<Widget> _pages = [
    CommunityPage(),
    CalendarPage(),
    HomePage(),
    ScorePage(),
    CoursesPage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      // TODO
      // Convert to map and invoke from the map based on index
      floatingActionButton: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ExercisePage(
                  heading: 'Exercise A', // Example heading
                  step: "Step 1", // Example step
                  description:
                      'Look at your happy photo below. Recall positive childhood memories.', // Example description
                  imageUrl:
                      'assets/icons/exercise_page_1.png', // Example image URL
                  buttonText: 'Next Step', // Example button text
                  onButtonPress: () {
                    // Define the behavior for button press
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(), // Example next page
                      ),
                    );
                  },
                  rightArrowPresent: true,
                ),
              ),
            );
          },
          child: const Icon(Icons.temple_buddhist)),
    );
  }
}
