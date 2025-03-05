import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:file/memory.dart'; // For in-memory File
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:llm_based_sat_app/screens/profile/childhood_photos_page.dart';
import 'package:llm_based_sat_app/utils/user_provider.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

// ------------------
// Mock classes
// ------------------
class StubUserProvider extends ChangeNotifier implements UserProvider {
  // Always return same UID
  @override
  String getUid() => 'test-uid';
  @override
  String? get email => throw UnimplementedError();
  @override
  Future<void> fetchUserData() => throw UnimplementedError();
  @override
  String getFirstName() => throw UnimplementedError();
  @override
  String getName() => throw UnimplementedError();
  @override
  String getProfilePictureUrl() => throw UnimplementedError();
  @override
  void setEmail(String email) {}
  @override
  void setUid(String uid) {}
  @override
  void setUserData(Map<String, dynamic> userData) {}
  @override
  String? get uid => throw UnimplementedError();
  @override
  Map<String, dynamic> get userData => throw UnimplementedError();
}

class MockPicker extends Mock implements ImagePicker {}

class MockFirebaseStorage extends Mock implements FirebaseStorage {}

class MockReference extends Mock implements Reference {}

class MockUploadTask extends Mock implements UploadTask {}

class MockTaskSnapshot extends Mock implements TaskSnapshot {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockUser mockUser;
  late MockFirebaseAuth mockAuth;
  late FakeFirebaseFirestore fakeFirestore;
  late StubUserProvider stubUserProvider;
  late MockPicker mockImagePicker;
  late MockFirebaseStorage mockFirebaseStorage;
  late MockReference mockRef;
  late MockUploadTask mockUploadTask;
  late MockTaskSnapshot mockTaskSnapshot;

  setUp(() {
    // Use a mocked user/ auth
    mockUser = MockUser(uid: 'test-uid');
    mockAuth = MockFirebaseAuth(signedIn: true, mockUser: mockUser);

    // Fake Firestore
    fakeFirestore = FakeFirebaseFirestore();

    // Stub provider always returns 'test-uid'
    stubUserProvider = StubUserProvider();

    // Image picker
    mockImagePicker = MockPicker();

    // Seed empty arrays, so we don’t hit example.com URLs
    fakeFirestore.collection('Profile').doc('test-uid').set({
      'favouritePhotos': [],
      'nonfavouritePhotos': [],
    });

    // FirebaseStorage (mock)
    mockFirebaseStorage = MockFirebaseStorage();
    mockRef = MockReference();
    mockUploadTask = MockUploadTask();
    mockTaskSnapshot = MockTaskSnapshot();
  });

  Widget createTestWidget() {
    return MaterialApp(
      home: ChangeNotifierProvider<UserProvider>.value(
        value: stubUserProvider,
        child: ChildhoodPhotosPage(
          onItemTapped: (_) {},
          selectedIndex: 0,
          onCompletion: () {},
          authOverride: mockAuth,
          firestoreOverride: fakeFirestore,
          pickerOverride: mockImagePicker,
          storageOverride: mockFirebaseStorage,
        ),
      ),
    );
  }

  testWidgets('renders ChildhoodPhotosPage with empty lists',
      (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    // Basic UI checks
    expect(find.text('Personal Profile'), findsOneWidget);
    expect(find.text('Childhood photos'), findsOneWidget);
    expect(
        find.text('Add favourite and non-favourite Photos of your Childhood'),
        findsOneWidget);
    expect(find.text('Favourite photos'), findsOneWidget);
    expect(find.text('Non-Favourite photos'), findsOneWidget);
    expect(find.text('Save'), findsOneWidget);

    // Because we used empty arrays, there should be zero initial photos
    expect(find.byType(ListTile), findsNWidgets(0));
  });

  // testWidgets('adds a new favourite photo when picker returns an image',
  //     (WidgetTester tester) async {
  //   // Return a pseudo-file from the image picker
  //   when(mockImagePicker.pickImage(source: ImageSource.gallery))
  //       .thenAnswer((_) async => XFile('test_fav.jpg'));

  //   await tester.pumpWidget(createTestWidget());
  //   await tester.pumpAndSettle();

  //   final addFavButton = find.descendant(
  //     of: find.text('Favourite photos'),
  //     matching: find.byIcon(Icons.add),
  //   );
  //   await tester.tap(addFavButton);
  //   await tester.pumpAndSettle();

  //   // Should now have 1 item (the newly added "test_fav.jpg")
  //   expect(find.byType(ListTile), findsNWidgets(1));
  // });

}
