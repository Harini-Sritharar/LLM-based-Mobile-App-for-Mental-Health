import 'package:flutter/material.dart';

// TO DO : ONLY FRONT END IN PROGRESS
/* For the time being, this does not communicate with the API, just stores all the users messages*/
class ChatProvider with ChangeNotifier {
  final List<Text> _messages = [];
  List<Text> get messages => _messages;

  Future<void> sendMessage(String text) async {
    _messages.add(Text(text));
    notifyListeners();
  }
}
