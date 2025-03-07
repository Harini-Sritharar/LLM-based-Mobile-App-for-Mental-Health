import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:llm_based_sat_app/models/calendar/calendar_exercise_entry.dart';
import 'package:llm_based_sat_app/screens/calendar/calendar_page.dart';
import 'package:llm_based_sat_app/utils/user_provider.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

class MockUserProvider extends Mock implements UserProvider {
  @override
  String getUid() => 'test-user-id';
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  
  late FakeFirebaseFirestore fakeFirestore;
  late MockUserProvider mockUserProvider;
  
  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    mockUserProvider = MockUserProvider();
    
    // No need to add test data to Firestore since we're completely mocking getExercisesByDate
  });
  
  // Create a list of predefined exercises for testing
  List<CalendarExerciseEntry> _createTestExercises() {
    return [
      CalendarExerciseEntry(
        exerciseName: 'Self-Attachment Exercise 1',
        courseName: 'Self-Attachment',
        date: DateTime.now(),
        duration: '15 minutes',
        notes: 'This was a very insightful exercise.',
      ),
      CalendarExerciseEntry(
        exerciseName: 'Self-Attachment Exercise 2',
        courseName: 'Self-Attachment',
        date: DateTime.now(),
        duration: '15 minutes',
        notes: 'No special notes.',
      ),
    ];
  }
  
  // Mock function that returns our test exercises instead of querying Firestore
  Future<List<CalendarExerciseEntry>> mockGetExercisesByDate(String uid, DateTime date) async {
    // Ignore the parameters and return our predefined list
    return _createTestExercises();
  }
  
  // Mock function that always returns empty list
  Future<List<CalendarExerciseEntry>> mockEmptyExercises(String uid, DateTime date) async {
    return [];
  }
  
  testWidgets('CalendarPage shows exercises for the selected date', (WidgetTester tester) async {
    // Build our app and trigger a frame
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<UserProvider>.value(
          value: mockUserProvider,
          child: CalendarPage(
            onItemTapped: (_) {},
            selectedIndex: 0,
            getExercisesByDateOverride: mockGetExercisesByDate,
          ),
        ),
      ),
    );

    // Wait for all async operations to complete
    await tester.pumpAndSettle(const Duration(seconds: 2));
    
    // Debug: Print the widget tree to see what's actually rendered
    //debugDumpApp();
    
    // Now look for our exercise data
    expect(find.text('Self-Attachment Exercise 1'), findsOneWidget);
    expect(find.textContaining('Self-Attachment'), findsWidgets);
    expect(find.textContaining('15 minutes'), findsWidgets);
    expect(find.text('This was a very insightful exercise.'), findsOneWidget);
  });
  
  testWidgets('CalendarPage shows empty state for dates with no exercises', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<UserProvider>.value(
          value: mockUserProvider,
          child: CalendarPage(
            onItemTapped: (_) {},
            selectedIndex: 0,
            getExercisesByDateOverride: mockEmptyExercises,
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();
    
    expect(find.text('No exercises completed on this date.'), findsOneWidget);
  });
}