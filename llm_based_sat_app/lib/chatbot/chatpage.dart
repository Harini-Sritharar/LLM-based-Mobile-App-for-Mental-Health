import 'package:flutter/material.dart';
import 'package:llm_based_sat_app/chatbot/chatprovider.dart';
import 'package:llm_based_sat_app/firebase/firebase_helpers.dart';
import 'package:llm_based_sat_app/services/websocket_service.dart';
import 'package:llm_based_sat_app/theme/app_colours.dart';
import 'package:llm_based_sat_app/utils/user_provider.dart';
import 'package:provider/provider.dart';

class Chatpage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ChatpageState();
}

class _ChatpageState extends State<Chatpage> {
  String name = '';
  late String uid;
  final WebSocketService _webSocketService = WebSocketService();

  bool _isWebSocketConnected = false;
  final _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _initializeChat();
    });
  }

  void _initializeChat() {
    // Avoid accessing context if disposed
    if (!mounted) return;

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    uid = userProvider.getUid();

    if (!_isWebSocketConnected) {
      _isWebSocketConnected = true;
      _webSocketService.connect(uid, context);
    }

    _loadName();
  }

  @override
  void dispose() {
    webSocketService.close();
    _isWebSocketConnected = false;
    super.dispose();
  }

  Future<void> _loadName() async {
    String fullName = await getName(uid);
    String firstName = fullName.split(' ')[0];

    if (!mounted) return;
    setState(() {
      name = firstName;
    });
  }

  void _sendMessage() {
    if (_textController.text.isNotEmpty) {
      final chatProvider = context.read<ChatProvider>();
      if (!_isWebSocketConnected) return;
      chatProvider.sendMessage(_textController.text);
      _webSocketService.sendMessage(_textController.text);
      _textController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Hi $name')),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Expanded(
                child: Consumer<ChatProvider>(
                  builder: (context, chatProvider, child) {
                    if (chatProvider.messages.isEmpty) {
                      return const Center(child: Text("Start a conversation ..."));
                    }

                    return ListView.builder(
                      itemCount: chatProvider.messages.length +
                          (chatProvider.isBotTyping ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == chatProvider.messages.length &&
                            chatProvider.isBotTyping) {
                          return _typingIndicator();
                        }
                        final message = chatProvider.messages[index];
                        return _buildMessageBubble(message);
                      },
                    );
                  },
                ),
              ),
              _buildMessageInput(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _typingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text("...", style: TextStyle(color: Colors.black54)),
      ),
    );
  }

  Widget _buildMessageBubble(Message message) {
    return Align(
      alignment: message.isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: message.isUserMessage ? AppColours.brandBlueMinusOne : AppColours.neutralGreyMinusOne,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomLeft: message.isUserMessage ? Radius.circular(10) : Radius.circular(0),
            bottomRight: message.isUserMessage ? Radius.circular(0) : Radius.circular(10),
          ),
        ),
        child: Text(
          message.data,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _textController,
            decoration: InputDecoration(
              hintText: 'Type a message',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        ElevatedButton(
          onPressed: _sendMessage,
          child: const Icon(Icons.send),
        )
      ],
    );
  }
}
