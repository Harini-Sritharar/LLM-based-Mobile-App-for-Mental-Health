import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:llm_based_sat_app/screens/profile/childhood_photos_page.dart';
import 'package:llm_based_sat_app/utils/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:provider/provider.dart';

/// A simple fake UserProvider that always returns the test uid.
class FakeUserProvider implements UserProvider {
  @override
  String getUid() => 'test_uid';

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  // We create our fake Firebase instances here.
  late FakeFirebaseFirestore fakeFirestore;
  late MockFirebaseStorage fakeStorage;
  late MockFirebaseAuth fakeAuth;

  setUp(() async {
    // Set up a fake Firestore with an initial document for our test user.
    fakeFirestore = FakeFirebaseFirestore();
    await fakeFirestore.collection('Profile').doc('test_uid').set({
      'favouritePhotos': <String>[],
      'nonfavouritePhotos': <String>[],
    });

    // Create a fake Storage instance.
    fakeStorage = MockFirebaseStorage();

    // Create a fake authenticated user.
    final mockUser = MockUser(uid: 'test_uid', email: 'test@example.com');
    fakeAuth = MockFirebaseAuth(signedIn: true, mockUser: mockUser);
  });

  testWidgets(
      'Uploading photo correctly updates Firestore and clears local list',
      (WidgetTester tester) async {
    // Create a temporary file to simulate a picked image.
    final tempDir = await Directory.systemTemp.createTemp();
    final fakeImageFile = File('${tempDir.path}/fake_image.jpg');
    await fakeImageFile.writeAsBytes([0, 1, 2, 3]);

    // Pump the widget wrapped with a Provider that supplies our fake uid.
    await tester.pumpWidget(
      Provider<UserProvider>.value(
        value: FakeUserProvider(),
        child: MaterialApp(
          home: ChildhoodPhotosPage(
            onItemTapped: (_) {},
            selectedIndex: 0,
            onCompletion: () {},
          ),
        ),
      ),
    );

    // Get access to the widget's state so we can simulate a local photo pick.
    final state = tester.state(find.byType(ChildhoodPhotosPage))
        as _ChildhoodPhotosPageState;
    state.setState(() {
      state.localFavouritePhotos.add(fakeImageFile.path);
    });
    await tester.pump();

    // Tap the Save button to trigger the upload.
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    // Verify that the Firestore document now contains one favourite photo URL.
    final docSnapshot =
        await fakeFirestore.collection('Profile').doc('test_uid').get();
    final data = docSnapshot.data() as Map<String, dynamic>;
    final List<dynamic> favouritePhotos = data['favouritePhotos'];
    expect(favouritePhotos.length, 1);

    // The URL is generated by the _uploadImage method.
    expect((favouritePhotos.first as String).contains('childhood_photos/'),
        isTrue);

    // Also verify that the local list has been cleared.
    expect(state.localFavouritePhotos.isEmpty, isTrue);
  });

  testWidgets('Deleting a network photo correctly removes it from Firestore',
      (WidgetTester tester) async {
    // Pre-populate Firestore with a network photo URL.
    const preExistingPhotoUrl = 'http://fakeurl.com/photo.jpg';
    await fakeFirestore.collection('Profile').doc('test_uid').set({
      'favouritePhotos': [preExistingPhotoUrl],
      'nonfavouritePhotos': <String>[],
    });

    await tester.pumpWidget(
      Provider<UserProvider>.value(
        value: FakeUserProvider(),
        child: MaterialApp(
          home: ChildhoodPhotosPage(
            onItemTapped: (_) {},
            selectedIndex: 0,
            onCompletion: () {},
          ),
        ),
      ),
    );

    // Allow the widget to load photos from Firestore.
    await tester.pumpAndSettle();

    // Verify that one ListTile (representing the network photo) is shown.
    expect(find.byType(ListTile), findsOneWidget);

    // Tap the delete icon (the first one) to remove the photo.
    await tester.tap(find.byIcon(Icons.delete).first);
    await tester.pump();

    // Tap the Save button to persist the deletion.
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    // Verify that Firestore now has an empty favouritePhotos list.
    final docSnapshot =
        await fakeFirestore.collection('Profile').doc('test_uid').get();
    final data = docSnapshot.data() as Map<String, dynamic>;
    final List<dynamic> favouritePhotos = data['favouritePhotos'];
    expect(favouritePhotos.isEmpty, isTrue);
  });
}

class _ChildhoodPhotosPageState extends State<ChildhoodPhotosPage> {
  List<String> localFavouritePhotos = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Childhood Photos'),
      ),
      body: Column(
        children: [
          // Your actual widget tree here
        ],
      ),
    );
  }
}