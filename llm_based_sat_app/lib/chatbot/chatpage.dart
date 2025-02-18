import 'package:flutter/material.dart';
import 'package:llm_based_sat_app/chatbot/chatprovider.dart';
import 'package:llm_based_sat_app/firebase/firebase_helpers.dart';
import 'package:llm_based_sat_app/screens/auth/sign_in_page.dart';
import 'package:llm_based_sat_app/theme/app_colours.dart';
import 'package:provider/provider.dart';

class Chatpage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ChatpageState();
}

class ChatpageState extends State<Chatpage> {
  String name = '';

  @override
  void initState() {
    super.initState();
    _loadName();
  }

  Future<void> _loadName() async {
    String fullName = await getName(user!.uid);
    name = fullName.split(' ')[0];
    setState(() {});
  }

  final _textController = TextEditingController();

  sendMessage() {
    if (_textController.text.isNotEmpty) {
      final chatProvider = context.read<ChatProvider>();
      chatProvider.sendMessage(_textController.text);
      _textController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text('Hi $name, how can I help?')),
        ),
        body: SafeArea(
          child: Container(
            margin: const EdgeInsets.all(10),
            child: Column(
              children: [
                Expanded(
                  child: Consumer<ChatProvider>(
                      builder: (context, chatProvider, child) {
                    if (chatProvider.messages.isEmpty) {
                      return const Center(
                          child: Text("Start a conversation ..."));
                    }

                    return ListView.builder(
                        itemCount: chatProvider.messages.length +
                            (chatProvider.isBotTyping ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == chatProvider.messages.length &&
                              chatProvider.isBotTyping) {
                            // Show typing indicator at the bottom
                            return Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text("...",
                                    style: TextStyle(color: Colors.black54)),
                              ),
                            );
                          }
                          final message = chatProvider.messages[index];
                          return Align(
                            alignment: message.isUserMessage
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                                margin: const EdgeInsets.all(5),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: message.isUserMessage
                                        ? AppColours.brandBlueMinusOne
                                        : AppColours.neutralGreyMinusOne,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                      bottomLeft: message.isUserMessage
                                          ? Radius.circular(10)
                                          : Radius.circular(0),
                                      bottomRight: message.isUserMessage
                                          ? Radius.circular(0)
                                          : Radius.circular(10),
                                    )
                                    // borderRadius: BorderRadius.circular(10),
                                    ),
                                child: Text(message.data)),
                          );
                        });
                  }),
                ),
                Row(
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
                      onPressed: sendMessage,
                      child: const Icon(Icons.send),
                    )
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
