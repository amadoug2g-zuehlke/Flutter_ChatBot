import 'package:flutter/material.dart';
import 'package:flutter_chatbot/src/constants/constants.dart';
import 'package:flutter_chatbot/src/features/chatting/data/repository/bot_service.dart';
import 'package:flutter_chatbot/src/features/chatting/domain/models/message.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';
import '../components/chat_bubble.dart';

class DialogScreen extends StatefulWidget {
  const DialogScreen({Key? key}) : super(key: key);

  @override
  State<DialogScreen> createState() => _DialogScreenState();
}

class _DialogScreenState extends State<DialogScreen> {
  final List<ChatMessage> _messages = [];
  final TextEditingController _textEditingController = TextEditingController();
  ChatService chatService = ChatService();

  Widget _buildInputField() {
    return IconTheme(
      data: const IconThemeData(),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                controller: _textEditingController,
                onSubmitted: _handleSubmitted,
                decoration:
                    const InputDecoration.collapsed(hintText: inputHintText),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                icon: const Icon(Icons.send),
                onPressed: () async {
                  _handleSubmitted(_textEditingController.text);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void nextResponse(query) async {
    _textEditingController.clear();
    final response = await chatService.getResponse(query);

    ChatMessage botChatMessage = ChatMessage(
        message: Message(
            textMessage: response.getMessage() ??
                CardDialogflow(response.getListMessage()[0]).title,
            senderName: botName,
            isMessageFromUser: false));
    setState(() {
      _messages.insert(0, botChatMessage);
    });
  }

  void _handleSubmitted(String text) {
    _textEditingController.clear();

    ChatMessage userChatMessage = ChatMessage(
        message: Message(
            textMessage: text, senderName: userName, isMessageFromUser: true));
    setState(() {
      _messages.insert(0, userChatMessage);
    });
    nextResponse(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(appTitle),
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              reverse: true,
              itemBuilder: (_, int index) => _messages[index],
              itemCount: _messages.length,
            ),
          ),
          const Divider(
            height: 1.0,
          ),
          Container(
            decoration: BoxDecoration(color: Theme.of(context).cardColor),
            child: _buildInputField(),
          )
        ],
      ),
    );
  }
}
