import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

//Singleton WebSocket service to handle the connection and message sending
class WebSocketService {
  WebSocketChannel? _channel;
  final StreamController<String> _messageController =
      StreamController.broadcast();
  bool isConnected = false;

  void connect(String userID) {
    if (isConnected) return;

    final wsUrl = Uri.parse(
        'ws://chatbot-app-128555328235.europe-central2.run.app/ws/$userID'); // Backend URL, change this to the actual host one eventually.
    _channel = WebSocketChannel.connect(wsUrl);

    _channel!.stream.listen(
      (message) {
        _messageController.add(message);
      },
      onDone: () => _reconnect(userID),
      onError: (error) {
        print("WebSocket error: $error");
        _reconnect(userID);
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

  void _reconnect(String userID) {
    isConnected = false;
    Future.delayed(Duration(seconds: 2), () {
      print("Reconnecting...");
      connect(userID); // Replace with dynamic userID
    });
  }

  void close() {
    _channel?.sink.close(status.goingAway);
    _messageController.close();
    isConnected = false;
  }
}

final webSocketService = WebSocketService();
