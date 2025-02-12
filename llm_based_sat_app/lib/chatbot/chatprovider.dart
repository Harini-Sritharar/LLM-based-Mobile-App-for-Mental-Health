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
  bool _isBotTyping =
      false; // represents whether the bot is fetching a reply or not

  // initialise the chat with a default welcome message
  ChatProvider() : _messages = [Message('Hello, how can I help you?', false)];

  List<Message> get messages => _messages;
  bool get isBotTyping => _isBotTyping;

  Future<void> sendMessage(String text) async {
    // Notify of the user message
    _messages.add(Message(text, true));
    notifyListeners();

    // Simulate a bot reply for now, will be changed to API call
    _isBotTyping = true;
    await Future.delayed(const Duration(seconds: 1));
    _isBotTyping = false;

    // The following just adds the message all at once
    // _messages.add(Message('Chatbot reply', false));

    // This attempts to add the message character by character.
    String chatbotReply =
        "This is the chatbot reply"; // will be changed to be fetched from API call
    String response = "";
    // Adding an empty message first so that the UI will update to show that the bot is going to respond
    _messages.add(Message(response, false));
    notifyListeners();

    // Simulating the effect of typing

    for (int i = 0; i < chatbotReply.length; i++) {
      await Future.delayed(const Duration(milliseconds: 10));
      response += chatbotReply[i];
      _messages[_messages.length - 1] = Message(response, false);
      notifyListeners();
    }
  }
}
