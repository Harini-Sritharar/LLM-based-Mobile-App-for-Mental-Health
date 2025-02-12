import 'package:flutter/material.dart';

// TO DO : ONLY FRONT END IN PROGRESS
/* For the time being, this does not communicate with the API, just stores all the users messages*/

class Message {
  final String data;
  final bool isUserMessage;
  Message(this.data, this.isUserMessage);
}

class ChatProvider with ChangeNotifier {
  final List<Message> _messages;

  ChatProvider() : _messages = [Message('Hello, how can I help you?', false)];

  List<Message> get messages => _messages;

  Future<void> sendMessage(String text) async {
    _messages.add(Message(text, true));
    _messages.add(Message('Chatbot reply', false));
    notifyListeners();
  }
}
