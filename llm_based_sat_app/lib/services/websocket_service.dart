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
  // Store the provider reference
  ChatProvider? _chatProvider;
  String? _userId;

  // Function to establish a WebSocket connection.
  void connect(String userID, BuildContext context) {
    if (isConnected) return;

    _userId = userID;

    // Store the provider reference when connecting
    _chatProvider = Provider.of<ChatProvider>(context, listen: false);

    final wsUrl = Uri.parse(
        'ws://chatbot-app-128555328235.europe-central2.run.app/ws/$userID'); // Backend URL, change this to the actual host one eventually.
    _channel = WebSocketChannel.connect(wsUrl);

    _channel!.stream.listen(
      (message) {
        // Use the stored provider reference instead of accessing context
        if (_chatProvider != null && isConnected) {
          // extract out anything we don't want to show the user
          try {
            // filters out the {"token_used": 0} messages
            final decodedMessage = jsonDecode(message);
            if (decodedMessage is Map &&
                decodedMessage.containsKey("tokens_used")) {
              // handle tokens_used case
              return;
            }
          } catch (e) {
            // If message is not a JSON, proceed with the original message
            // replacing the leading number and dashes used in the chatbot response
            message = message.replaceAll(RegExp(r'\\n'), '\n');
            message = message.replaceFirst(RegExp(r'^\d+-\s*'), '');
          }
          _chatProvider!.receiveMessage(message);
          _messageController.add(message);
        }
      },
      onDone: () => _handleDisconnection(),
      onError: (error) {
        print("WebSocket error: $error");
        _handleDisconnection();
      },
    );

    isConnected = true;
  }

  // Function to send a message to the WebSocket server
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

  // Getter for the message stream
  Stream<String> get messageStream => _messageController.stream;

  // Function to handle WebSocket disconnection.
  void _handleDisconnection() {
    // Just mark as disconnected, don't try to auto-reconnect
    if (isConnected) {
      isConnected = false;
      print("WebSocket disconnected");
      // Don't clear providers or try to reconnect automatically
    }
  }

  // Call this method from UI with a fresh context when ready to reconnect
  void reconnect(BuildContext context) {
    if (_userId != null) {
      _chatProvider = null;
      isConnected = false;
      connect(_userId!, context);
    } else {
      print("Can't reconnect: missing user ID");
    }
  }

  // Function to close the WebSocket connection
  void close() {
    _channel?.sink.close(status.goingAway);
    isConnected = false;
    _chatProvider = null;
    // Only close the controller if it's not already closed
    if (!_messageController.isClosed) {
      _messageController.close();
    }
  }
}

// Create a singleton instance of the WebSocketService
final webSocketService = WebSocketService();
