import 'package:flutter/material.dart';

class Message {
  Message({
    required this.textMessage,
    required this.senderName,
    required this.isMessageFromUser,
  });

  final String textMessage;
  final String senderName;
  final bool isMessageFromUser;

  List<Widget> getChatBubble(BuildContext context) {
    List<Widget> botMessage(context) {
      return <Widget>[
        Container(
          margin: const EdgeInsets.only(right: 16.0),
          child: const CircleAvatar(
            child: Text(
              'B',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
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
        ),
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

    return isMessageFromUser ? userMessage(context) : botMessage(context);
  }
}
