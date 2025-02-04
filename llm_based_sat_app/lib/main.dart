import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:llm_based_sat_app/firebase_messaging_service.dart';
import 'package:llm_based_sat_app/screens/personal_profile_page.dart';
import 'package:llm_based_sat_app/screens/auth/sign_up_page.dart';
import 'package:llm_based_sat_app/screens/contact_details_page.dart';
import 'package:llm_based_sat_app/screens/personal_info_page.dart';
import 'package:llm_based_sat_app/theme/app_colours.dart';
import 'package:llm_based_sat_app/widgets/profile_widgets/image_picker.dart';
import 'package:llm_based_sat_app/screens/course/courses.dart';
import 'package:llm_based_sat_app/firebase_helpers.dart';
import 'package:llm_based_sat_app/screens/childhood_photos_page.dart';
import '/screens/auth/sign_in_page.dart';
import '../screens/community_page.dart';
import '../screens/calendar_page.dart';
import '../screens/home_page.dart';
import '../screens/score_page.dart';
import '../widgets/bottom_nav_bar.dart';
import 'firebase_options.dart';

List<Map<String, dynamic>> favouritePhotos = [];
List<Map<String, dynamic>> nonFavouritePhotos = [];

Future<void> _backgroundHandler(RemoteMessage message) async {
  print('Handling a background message: ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

    // Request permission for notifications
  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
  final firebaseMessagingService = FirebaseMessagingService();
  await firebaseMessagingService.initialize();
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
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSwatch(
          backgroundColor: Colors.white,
        ),
      ),
      // For now, the landing screen is the Sign In page
      home: SignInPage(),
      // home: UploadProfilePicturePage(onItemTapped: (x) => {}, selectedIndex: 0,) // for local testing
      // home:ImagePickerWidget()
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
    if (!photosLoaded) {
      _loadInitialPhotos();
      photosLoaded = true;
    }
  }

  Future<void> _loadInitialPhotos() async {
    try {
      final favouritePhotoData =
          await getPhotosByCategory(userId: user!.uid, category: "Favourite");
      final nonFavouritePhotoData = await getPhotosByCategory(
          userId: user!.uid, category: "Non-Favourite");

      setState(() {
        favouritePhotos.addAll(favouritePhotoData);
        nonFavouritePhotos.addAll(nonFavouritePhotoData);
      });
    } catch (e) {
      // Handle errors, such as showing a message to the user
      debugPrint("Error loading photos: $e");
    }
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


