import 'package:flutter/material.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter ChatBot',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const DialogScreen(),
    );
  }
}

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

  void nextResponse(query) async {
    _textEditingController.clear();
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

class ChatMessage extends StatelessWidget {
  const ChatMessage({
    Key? key,
    required this.textMessage,
    required this.senderName,
    required this.isMessageFromUser,
  }) : super(key: key);

  final String textMessage;
  final String senderName;
  final bool isMessageFromUser;

  List<Widget> botMessage(context) {
    return <Widget>[
      Container(
        margin: const EdgeInsets.only(right: 16.0),
        child: const CircleAvatar(
            child: Text(
          'B',
          style: TextStyle(fontWeight: FontWeight.bold),
        )),
      ),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              senderName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Container(
              margin: const EdgeInsets.only(top: 5.0),
              child: Text(textMessage),
            )
          ],
        ),
      )
    ];
  }

  List<Widget> userMessage(context) {
    return <Widget>[
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              senderName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Container(
              margin: const EdgeInsets.only(top: 5.0),
              child: Text(textMessage),
            )
          ],
        ),
      ),
      Container(
        margin: const EdgeInsets.only(left: 16.0),
        child: CircleAvatar(
          child: Text(
            senderName[0],
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:
            isMessageFromUser ? userMessage(context) : botMessage(context),
      ),
    );
  }
}
