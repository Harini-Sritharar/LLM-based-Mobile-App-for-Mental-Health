import 'package:flutter/material.dart';

/// Represents a chat message with content and sender information.
class Message {
  final String data; // The text content of the message.
  final bool
      isUserMessage; // True if the message is from the user, false if from the bot.
  Message(this.data, this.isUserMessage);
}

/// A provider class that manages the state of chat messages.
class ChatProvider with ChangeNotifier {
  final List<Message> _messages; // Stores all chat messages.
  bool _isBotTyping =
      false; // represents whether the bot is fetching a reply or not

  /// Initializes the provider with an empty message list.
  ChatProvider() : _messages = [];

  /// Provides access to the chat messages list.
  List<Message> get messages => _messages;

  /// Indicates whether the bot is currently typing.
  bool get isBotTyping => _isBotTyping;

  /// Handles sending a user message.
  /// Adds the message to the chat and notifies listeners.
  Future<void> sendMessage(String text) async {
    // Notify of the user message
    _messages.add(Message(text, true));
    notifyListeners();
  }

  /// Handles receiving a message from the bot.
  /// Adds the message to the chat and notifies listeners.
  void receiveMessage(String message) {
    messages.add(Message(message, false));
    notifyListeners();
  }
}
