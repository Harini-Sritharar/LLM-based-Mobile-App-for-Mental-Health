// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  /* Returns the Firebase options for the current platform. Throws an error if the platform is not supported */
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  /// Firebase configuration options for the Web platform
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBbop_K4oX-fn3qDdvBJL4L2PCDFAio-tE',
    appId: '1:128555328235:web:553a30f691410a81b9d4ae',
    messagingSenderId: '128555328235',
    projectId: 'llm-based-sat-app',
    authDomain: 'llm-based-sat-app.firebaseapp.com',
    storageBucket: 'llm-based-sat-app.firebasestorage.app',
    measurementId: 'G-5R02DP5E9T',
  );

  /// Firebase configuration options for the Android platform.
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC9ihVmKyo3AZXYdo06yk7j7jxgeVHlR10',
    appId: '1:128555328235:android:1258809a117affd2b9d4ae',
    messagingSenderId: '128555328235',
    projectId: 'llm-based-sat-app',
    storageBucket: 'llm-based-sat-app.firebasestorage.app',
  );

  /// Firebase configuration options for the IOS platform.
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDgse9hgX6mqfhZGBRQ7WoQFQ5CueTHbn0',
    appId: '1:128555328235:ios:4d09a79a2d667192b9d4ae',
    messagingSenderId: '128555328235',
    projectId: 'llm-based-sat-app',
    storageBucket: 'llm-based-sat-app.firebasestorage.app',
    iosBundleId: 'com.invincimind.satapp',
  );

  /// Firebase configuration options for the macOS platform.
  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDgse9hgX6mqfhZGBRQ7WoQFQ5CueTHbn0',
    appId: '1:128555328235:ios:4d09a79a2d667192b9d4ae',
    messagingSenderId: '128555328235',
    projectId: 'llm-based-sat-app',
    storageBucket: 'llm-based-sat-app.firebasestorage.app',
    iosBundleId: 'com.invincimind.satapp',
  );

  /// Firebase configuration options for the Windows platform.
  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBbop_K4oX-fn3qDdvBJL4L2PCDFAio-tE',
    appId: '1:128555328235:web:ce4534ee44bfdce2b9d4ae',
    messagingSenderId: '128555328235',
    projectId: 'llm-based-sat-app',
    authDomain: 'llm-based-sat-app.firebaseapp.com',
    storageBucket: 'llm-based-sat-app.firebasestorage.app',
    measurementId: 'G-5ZY72557NE',
  );
}
