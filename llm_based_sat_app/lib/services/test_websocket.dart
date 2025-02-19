import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:flutter/widgets.dart';

import 'websocket_service.dart'; // Import your WebSocket service

void main() {
  String userID = "1234"; // Replace with a valid userID

  BuildContext bc = WidgetsBinding.instance!.renderViewElement!; // Initialize with a valid context
  webSocketService.connect(userID, bc);

  // Listen for incoming messages
  webSocketService.messageStream.listen(
    (message) => print("Received: $message"),
    onError: (error) => print("Error: $error"),
  );

  // Allow user input to send messages
  Timer.periodic(Duration(seconds: 15), (timer) {
    stdout.write("Enter message to send: ");
    String? userMessage = stdin.readLineSync();
    if (userMessage != null && userMessage.isNotEmpty) {
      webSocketService.sendMessage(userMessage);
    }
  });

  // Keep the program running
  print("WebSocket Test Started. Type messages to send.");
}
