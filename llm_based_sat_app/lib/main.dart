import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:country_codes/country_codes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:llm_based_sat_app/firebase_messaging_service.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:llm_based_sat_app/chatbot/chatprovider.dart';
import 'package:llm_based_sat_app/screens/home_page.dart';
import 'package:llm_based_sat_app/screens/score/questionnaire_assessments_page.dart';
import 'package:llm_based_sat_app/screens/course/courses.dart';
import 'package:llm_based_sat_app/utils/user_provider.dart';
import 'package:llm_based_sat_app/utils/wrapper.dart';
import '/screens/auth/sign_in_page.dart';
import 'package:llm_based_sat_app/widgets/fcm_init.dart';
import 'screens/calendar/calendar_page.dart';
import 'screens/score/score_page.dart';
import '../widgets/bottom_nav_bar.dart';
import 'firebase/firebase_options.dart';
import 'package:provider/provider.dart';
import 'utils/profile_notifier.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Background message handler
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message: ${message.messageId}');
}

// Global keys for navigation and scaffold
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await CountryCodes.init();

  // Register background handler before initializing Firebase
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  // Load environment variables
  await dotenv.load(fileName: ".env");

  await _setup(); // Ensures Stripe and other initializations

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Request permission for notifications (iOS)
  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.playIntegrity,
    appleProvider: AppleProvider.deviceCheck,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ProfileNotifier()),
        ChangeNotifierProvider(create: (context) => ChatProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
      ],
      child: MyApp(),
    ),
  );
}

Future<void> _setup() async {
  Stripe.publishableKey = dotenv.env['STRIPE_PUBLISHABLE_KEY'] ?? '';
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late FirebaseMessagingService _firebaseMessagingService;

  @override
  void initState() {
    super.initState();
    _firebaseMessagingService = FirebaseMessagingService();
    _firebaseMessagingService.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Navigation',
      navigatorKey: navigatorKey, // Global navigator key for navigation
      scaffoldMessengerKey: scaffoldMessengerKey, // Global scaffold key
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSwatch(
          backgroundColor: Colors.white,
        ),
      ),
      home: FCMInitializer(
        // DO NOT REMOVE IF YOU WANT TO KEEP NOTIFICATIONS WORKING
        child: Wrapper(),
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
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    _initializeUserData();
  }

  Future<void> _initializeUserData() async {
    try {
      // Give Firebase Auth time to fully initialize
      await Future.delayed(Duration(milliseconds: 500));

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        if (mounted) {
          setState(() {
            _errorMessage = "Not authenticated";
            _isLoading = false;
          });
        }
        return;
      }

      // Force refresh user token to ensure we have the latest data
      await user.getIdToken(true);

      // Fetch user profile data
      final doc = await FirebaseFirestore.instance
          .collection('Profile')
          .doc(user.uid)
          .get();

      // Log user data status
      if (!doc.exists) {
        print(
            "User document doesn't exist yet for ${user.uid}. Creating profile may be needed.");
      } else {
        print("User data loaded successfully for ${user.uid}");

        // Update UserProvider with the latest user data
        if (mounted) {
          final userProvider =
              Provider.of<UserProvider>(context, listen: false);
          userProvider.setUid(user.uid);

          // If there's user data, you might want to load it into your provider
          if (doc.data() != null) {
            // Example: userProvider.setUserData(doc.data()!);
          }
        }
      }

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error initializing user data: $e");
      if (mounted) {
        setState(() {
          _errorMessage = "Error loading data: $e";
          _isLoading = false;
        });
      }
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text(
                "Loading your profile...",
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: Colors.red),
              SizedBox(height: 20),
              Text(
                "Error: $_errorMessage",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isLoading = true;
                    _errorMessage = null;
                  });
                  _initializeUserData();
                },
                child: Text("Retry"),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => SignInPage()),
                    (route) => false,
                  );
                },
                child: Text("Sign Out"),
              ),
            ],
          ),
        ),
      );
    }

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
