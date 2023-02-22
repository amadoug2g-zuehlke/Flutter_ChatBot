import 'package:flutter/material.dart';
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
                    const InputDecoration.collapsed(hintText: "Send a message"),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                icon: const Icon(Icons.send),
                onPressed: () => _handleSubmitted(_textEditingController.text),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //TODO: create Service class and reformat Dialogflow call
  void nextResponse(query) async {
    _textEditingController.clear();
    //TODO: hide credentials properly
    AuthGoogle authGoogle =
        await AuthGoogle(fileJson: "assets/credentials.json").build();
    Dialogflow dialogflow = Dialogflow(
      authGoogle: authGoogle,
      language: Language.english,
    );
    AIResponse response = await dialogflow.detectIntent(query);
    ChatMessage botMessage = ChatMessage(
      textMessage: response.getMessage() ??
          CardDialogflow(response.getListMessage()[0]).title,
      senderName: "Bot",
      isMessageFromUser: false,
    );
    setState(() {
      _messages.insert(0, botMessage);
    });
  }

  void _handleSubmitted(String text) {
    _textEditingController.clear();
    ChatMessage userMessage = ChatMessage(
      textMessage: text,
      senderName: 'User',
      isMessageFromUser: true,
    );
    setState(() {
      _messages.insert(0, userMessage);
    });
    nextResponse(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter ChatBot'),
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
