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
    name = await getName(user!
        .uid); // probably want to change this to be fetching the username rather than their full name
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
                        itemCount: chatProvider.messages.length,
                        itemBuilder: (context, index) {
                          final message = chatProvider.messages[index];
                          return Container(
                              margin: const EdgeInsets.all(5),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppColours.brandBlueMinusOne,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(message.data!));
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
