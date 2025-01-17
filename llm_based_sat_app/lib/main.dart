import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:llm_based_sat_app/screens/sign_in_page.dart';
import '../screens/community_page.dart';
import '../screens/calendar_page.dart';
import '../screens/courses_page.dart';
import '../screens/home_page.dart';
import '../screens/score_page.dart';
import '../widgets/bottom_nav_bar.dart';
import 'screens/exercise_page.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Navigation',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // For now, the landing screen is the Sign In page
      home: SignInPage(),
    );
  }
}

class MainScreen extends StatefulWidget {
  final int initialIndex;
  const MainScreen({super.key, this.initialIndex = 2});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // Default page is home page (index 2)
  int _selectedIndex = 2;

  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      CommunityPage(onItemTapped: _onItemTapped, selectedIndex: _selectedIndex),
      CalendarPage(onItemTapped: _onItemTapped, selectedIndex: _selectedIndex),
      HomePage(onItemTapped: _onItemTapped, selectedIndex: _selectedIndex),
      ScorePage(onItemTapped: _onItemTapped, selectedIndex: _selectedIndex),
      CoursesPage(onItemTapped: _onItemTapped, selectedIndex: _selectedIndex),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onTap: (index) {
          _onItemTapped(index);
        },
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
                          builder: (context) => HomePage(
                              onItemTapped: _onItemTapped,
                              selectedIndex:
                                  _selectedIndex) // Example next page
                          ),
                    );
                  },
                  rightArrowPresent: true,
                  messageText: "Leave and lose your progress. X",
                ),
              ),
            );
          },
          child: const Icon(Icons.temple_buddhist)),
    );
  }
}
