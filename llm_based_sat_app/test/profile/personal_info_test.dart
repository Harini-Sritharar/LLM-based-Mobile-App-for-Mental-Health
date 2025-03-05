import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:llm_based_sat_app/screens/profile/personal_info_page.dart';
import 'package:provider/provider.dart';
import 'package:llm_based_sat_app/utils/profile_notifier.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';

// Create mocks
class MockProfileNotifier extends Mock implements ProfileNotifier {}

void main() {
  // Skip Firebase initialization completely
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PersonalInfoPage Tests', () {
    late MockFirebaseAuth mockAuth;
    late FakeFirebaseFirestore fakeFirestore;
    late ProfileNotifier profileNotifier;
    late MockUser mockUser;

    setUp(() {
      // Use firebase_auth_mocks package for auth mocking
      mockUser = MockUser(
        uid: 'test-uid',
        email: 'test@example.com',
        displayName: 'Test User',
      );

      mockAuth = MockFirebaseAuth(signedIn: true, mockUser: mockUser);
      fakeFirestore = FakeFirebaseFirestore();
      profileNotifier = ProfileNotifier();

      // Add test profile data to fake Firestore
      fakeFirestore.collection('Profile').doc('test-uid').set({
        'firstname': 'John',
        'surname': 'Doe',
        'dob': '01/01/2000',
        'gender': 'Male',
      });
    });

    Widget createTestWidget() {
      return MaterialApp(
        home: ChangeNotifierProvider<ProfileNotifier>.value(
          value: profileNotifier,
          child: PersonalInfoPage(
            onItemTapped: (_) {},
            selectedIndex: 0,
            onCompletion: () {},
            // Pass our mock parameters
            authOverride: mockAuth,
            firestoreOverride: fakeFirestore,
            updatePersonalInfoOverride:
                (firstName, surname, dob, gender) async {
              // Use the mock Firestore directly
              await fakeFirestore.collection('Profile').doc('test-uid').set({
                'firstname': firstName,
                'surname': surname,
                'dob': dob,
                'gender': gender,
              });
            },
          ),
        ),
      );
    }

    testWidgets('renders all UI elements correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Verify UI elements
      expect(find.text('Personal Profile'), findsOneWidget);
      expect(find.text('Personal Info'), findsOneWidget);
      expect(find.text('Complete your Personal Information'), findsOneWidget);
      expect(find.text('Name'), findsOneWidget);
      expect(find.text('Surname'), findsOneWidget);
      expect(find.text('Date of Birth'), findsOneWidget);
      expect(find.text('Gender'), findsOneWidget);
      expect(find.text('Save'), findsOneWidget);

      // Check that data is loaded (might need time to load)
      await tester.pump(Duration(milliseconds: 500));
      expect(find.text('John'), findsOneWidget);
      expect(find.text('Doe'), findsOneWidget);
      expect(find.text('01/01/2000'), findsOneWidget);
      expect(find.text('Male'), findsOneWidget);
    });

    testWidgets('shows date picker when date field is tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Find the date field GestureDetector
      final Finder dateFieldFinder = find.ancestor(
        of: find.widgetWithText(TextFormField, 'Date of Birth'),
        matching: find.byType(GestureDetector),
      );

      // Tap the date field
      await tester.tap(dateFieldFinder);
      await tester.pumpAndSettle();

      // Verify date picker is shown
      expect(find.byType(DatePickerDialog), findsOneWidget);
    });

    testWidgets('saves form data when valid', (WidgetTester tester) async {
      // Create a mock ProfileNotifier instance
      final mockProfileNotifier = MockProfileNotifier();

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<ProfileNotifier>.value(
            value: mockProfileNotifier,
            child: PersonalInfoPage(
              onItemTapped: (_) {},
              selectedIndex: 0,
              onCompletion: () {},
              authOverride: mockAuth,
              firestoreOverride: fakeFirestore,
              updatePersonalInfoOverride:
                  (firstName, surname, dob, gender) async {
                await fakeFirestore.collection('Profile').doc('test-uid').set({
                  'firstname': firstName,
                  'surname': surname,
                  'dob': dob,
                  'gender': gender,
                });
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Fill in all fields with valid data
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Name'), 'Jane');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Surname'), 'Smith');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Date of Birth'), '02/02/1995');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Gender'), 'Female');

      // Find the Save button
      final saveButtonFinder = find.text('Save');

      // Ensure the Save button is visible by scrolling to it
      await tester.ensureVisible(saveButtonFinder);
      await tester.pumpAndSettle();

      // Tap save button
      await tester.tap(saveButtonFinder);
      await tester.pumpAndSettle();

      // Verify that data was saved to Firestore
      final updatedData =
          await fakeFirestore.collection('Profile').doc('test-uid').get();
      expect(updatedData.exists, isTrue);
      expect(updatedData.data()!['firstname'], 'Jane');
      expect(updatedData.data()!['surname'], 'Smith');
      expect(updatedData.data()!['dob'], '02/02/1995');
      expect(updatedData.data()!['gender'], 'Female');
    });
  });
}
