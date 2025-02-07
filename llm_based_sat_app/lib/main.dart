import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:llm_based_sat_app/consts.dart';
import 'package:llm_based_sat_app/screens/questionnaire/questionnaire_assessments_page.dart';
import 'package:llm_based_sat_app/screens/course/courses.dart';
import '/screens/auth/sign_in_page.dart';
import '../screens/community_page.dart';
import '../screens/calendar_page.dart';
import '../screens/score_page.dart';
import '../widgets/bottom_nav_bar.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'profile_notifier.dart';

void main() async {
  await _setup();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => ProfileNotifier(),
      child: MyApp(),
    ),
  );
}

Future<void> _setup() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = stripePublishableKey;
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
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSwatch(
          backgroundColor: Colors.white,
        ),
      ),
      // For now, the landing screen is the Sign In page
      home: SignInPage(),
      // home: UploadProfilePicturePage(onItemTapped: (x) => {}, selectedIndex: 0,) // for local testing
      // home:ImagePickerWidget()
      // home: Courses(onItemTapped: (x) => {}, selectedIndex: 0)
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
  bool photosLoaded = false;

  @override
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
      QuestionnaireAssessmentsPage(),
      //HomePage(onItemTapped: _onItemTapped, selectedIndex: _selectedIndex),
      ScorePage(onItemTapped: _onItemTapped, selectedIndex: _selectedIndex),
      Courses(onItemTapped: _onItemTapped, selectedIndex: _selectedIndex),
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
    );
  }
}
