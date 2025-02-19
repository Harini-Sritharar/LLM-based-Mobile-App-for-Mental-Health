import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:llm_based_sat_app/chatbot/chatprovider.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

//Singleton WebSocket service to handle the connection and message sending
class WebSocketService {
  WebSocketChannel? _channel;
  final StreamController<String> _messageController =
      StreamController.broadcast();
  bool isConnected = false;

  void connect(String userID, BuildContext context) {
    if (isConnected) return;

    final wsUrl = Uri.parse(
        'ws://chatbot-app-128555328235.europe-central2.run.app/ws/$userID'); // Backend URL, change this to the actual host one eventually.
    _channel = WebSocketChannel.connect(wsUrl);

    _channel!.stream.listen(
      (message) {
        // Notify the ChatProvider about the new message
        final chatProvider = Provider.of<ChatProvider>(context, listen: false);
        // extract out anything we don't want to show the user
        try {
          // filters out the {"token_used": 0} messages
          final decodedMessage = jsonDecode(message);
          if (decodedMessage is Map && decodedMessage.containsKey("tokens_used")) {
            // handle tokens_used case
            return;
          }
        } catch (e) {
          // If message is not a JSON, proceed with the original message
          // replacing the leading number and dashes used in the chatbot response
            message = message.replaceAll(RegExp(r'\\n'), '\n');
            message = message.replaceFirst(RegExp(r'^\d+-\s*'), '');
        }
        chatProvider.receiveMessage(message);
        _messageController.add(message);
      },
      onDone: () => _reconnect(userID, context),
      onError: (error) {
        print("WebSocket error: $error");
        _reconnect(userID, context);
      },
    );

    isConnected = true;
  }

  void sendMessage(String message) {
    if (_channel != null && isConnected) {
      final jsonMessage = jsonEncode({
        "role": "user",
        "content": message,
        "location": {"latitude": "", "longitude": ""},
        "datetime": DateTime.now().toIso8601String()
      });

      _channel!.sink.add(jsonMessage);
    } else {
      print("WebSocket is not connected!");
    }
  }

  Stream<String> get messageStream => _messageController.stream;

  void _reconnect(String userID, BuildContext context) {
    isConnected = false;
    Future.delayed(Duration(seconds: 2), () {
      print("Reconnecting...");
      connect(userID, context); // Replace with dynamic userID
    });
  }

  void close() {
    _channel?.sink.close(status.goingAway);
    _messageController.close();
    isConnected = false;
  }
}

final webSocketService = WebSocketService();
