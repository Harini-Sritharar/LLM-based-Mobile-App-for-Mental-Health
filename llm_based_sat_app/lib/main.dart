import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:llm_based_sat_app/firebase_messaging_service.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:llm_based_sat_app/chatbot/chatprovider.dart';
import 'package:llm_based_sat_app/screens/home_page.dart';
import 'package:llm_based_sat_app/screens/score/questionnaire_assessments_page.dart';
import 'package:llm_based_sat_app/utils/consts.dart';
import 'package:llm_based_sat_app/screens/course/courses.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:llm_based_sat_app/widgets/fcm_init.dart';
import '/screens/auth/sign_in_page.dart';
import 'screens/calendar/calendar_page.dart';
import 'screens/score/score_page.dart';
import '../widgets/bottom_nav_bar.dart';
import 'firebase/firebase_options.dart';
import 'package:provider/provider.dart';
import 'utils/profile_notifier.dart';

// Background message handler
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message: ${message.messageId}');
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Register background handler before initializing Firebase
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  await _setup();  // Ensures Stripe and other initializations

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Request permission for notifications (iOS)
  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ProfileNotifier()),
        ChangeNotifierProvider(create: (context) => ChatProvider()),
      ],
      child: MyApp(),
    ),
  );
}

Future<void> _setup() async {
  Stripe.publishableKey = stripePublishableKey;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize Firebase Messaging Service with context
    final firebaseMessagingService = FirebaseMessagingService(context);
    firebaseMessagingService.initialize();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Navigation',
      navigatorKey: navigatorKey,  // Set up global navigator key
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSwatch(
          backgroundColor: Colors.white,
        ),
      ),
      home: FCMInitializer(   // DO NOT REMOVE THE FCMINITIALIZER WIDGET IF YOU WANT TO CHANGE THE LANDING PAGE OR NOTIFICATIONS WILL BREAK
        child: SignInPage(),
      ),
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
  int _selectedIndex = 2;

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
      QuestionnaireAssessmentsPage(),
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
