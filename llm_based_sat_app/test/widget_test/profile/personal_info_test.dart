import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:llm_based_sat_app/screens/profile/personal_info_page.dart';
import 'package:provider/provider.dart';
import 'package:llm_based_sat_app/utils/profile_notifier.dart';
import '../../test_helpers/firebase_mocks.dart';

class MockDocumentSnapshot extends Mock implements DocumentSnapshot<Map<String, dynamic>> {
  final Map<String, dynamic> _data;

  MockDocumentSnapshot(this._data);

  Map<String, dynamic> getData() => _data;
}

class MockFirebaseAuth extends Mock implements FirebaseAuth {}
class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}
class MockUser extends Mock implements User {}

void main() {
  setupFirebaseMocks();

  // Ensure the test binding is initialized immediately.
  final TestWidgetsFlutterBinding binding = TestWidgetsFlutterBinding.ensureInitialized();

  // Register the mock handler on the default binary messenger.
  const MethodChannel firebaseCoreChannel = MethodChannel('plugins.flutter.io/firebase_core');
  binding.defaultBinaryMessenger.setMockMethodCallHandler(firebaseCoreChannel, (MethodCall call) async {
    if (call.method == 'Firebase#initializeCore') {
      // Return a list with one default app.
      return <dynamic>[
        <String, dynamic>{
          'name': '[DEFAULT]',
          'options': {
            'appId': '1:1234567890:android:abcdef',
            'apiKey': 'fake-api-key',
            'projectId': 'fake-project-id',
            'messagingSenderId': '1234567890',
          },
          'pluginConstants': {},
        }
      ];
    }
    if (call.method == 'Firebase#initializeApp') {
      // Return the app configuration.
      return <String, dynamic>{
        'name': call.arguments['appName'],
        'options': call.arguments['options'],
        'pluginConstants': {},
      };
    }
    return null;
  });

  // Initialize Firebase inside setUpAll to ensure the mock is already in place.
  setUpAll(() async {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'fake-api-key',
        appId: '1:1234567890:android:abcdef',
        messagingSenderId: '1234567890',
        projectId: 'fake-project-id',
      ),
    );
  });

  group('Personal Info Page Tests', () {
    late MockFirebaseAuth mockAuth;
    late MockFirebaseFirestore mockFirestore;
    late MockUser mockUser;

    setUp(() {
      mockAuth = MockFirebaseAuth();
      mockFirestore = MockFirebaseFirestore();
      mockUser = MockUser();

      // Setup mock behavior
      when(mockUser.uid).thenReturn('test-uid');
      when(mockAuth.currentUser).thenReturn(mockUser);
      when(mockFirestore.collection('Profile').doc('test-uid').get()).thenAnswer(
        (_) async => MockDocumentSnapshot({
          'firstname': 'John',
          'surname': 'Doe',
          'dob': '01/01/2000',
          'gender': 'Male',
        }),
      );
    });

    testWidgets('PersonalInfoPage widget test', (WidgetTester tester) async {
      // Pump the widget.
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            Provider<FirebaseAuth>.value(value: mockAuth),
            Provider<FirebaseFirestore>.value(value: mockFirestore),
            ChangeNotifierProvider<ProfileNotifier>(
              create: (_) => ProfileNotifier(),
            ),
          ],
          child: MaterialApp(
            home: PersonalInfoPage(
              onItemTapped: (_) {},
              selectedIndex: 0,
              onCompletion: () {},
            ),
          ),
        ),
      );

      // Verify that key texts are present.
      expect(find.text('Personal Profile'), findsOneWidget);
      expect(find.text('Personal Info'), findsOneWidget);
      expect(find.text('Complete your Personal Information'), findsOneWidget);
      expect(find.text('Name'), findsOneWidget);
      expect(find.text('Surname'), findsOneWidget);
      expect(find.text('Date of Birth'), findsOneWidget);
      expect(find.text('Gender'), findsOneWidget);
      expect(find.text('Save'), findsOneWidget);
    });
  });
}