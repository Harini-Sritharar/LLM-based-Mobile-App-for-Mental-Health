import 'package:flutter/services.dart';

class SessionManager {
  static const platform =
      MethodChannel('com.example.llmBasedSatApp.auth/session');

  Future<void> setLoginStatus(bool isLoggedIn) async {
    try {
      await platform.invokeMethod('setLoginStatus', {'isLoggedIn': isLoggedIn});
    } on PlatformException catch (e) {
      print("Error: $e");
    }
  }

  Future<bool> getLoginStatus() async {
    try {
      final bool isLoggedIn = await platform.invokeMethod('getLoginStatus');
      return isLoggedIn;
    } on PlatformException catch (e) {
      print("Error: $e");
      return false;
    }
  }
}
