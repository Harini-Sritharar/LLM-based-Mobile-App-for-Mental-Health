import 'package:flutter/material.dart';


class ProfileNotifier extends ChangeNotifier {
  void notifyProfileUpdated() {
    notifyListeners();
  }
}

