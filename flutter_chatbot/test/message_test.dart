import 'package:flutter/material.dart';
import 'package:flutter_chatbot/src/features/chatting/domain/models/message.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockBuildContext extends Mock implements BuildContext {}

void main() {
  group('Message', () {
    test('getChatBubble returns correct chat bubble for user message', () {
      final message = Message(
        textMessage: 'Hello, there!',
        senderName: 'Jerry',
        isMessageFromUser: true,
      );

      final chatBubble = message.getChatBubble(MockBuildContext());

      final expectedChat = <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                message.senderName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Container(
                margin: const EdgeInsets.only(top: 5.0),
                child: Text(message.textMessage),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 16.0),
          child: CircleAvatar(
            child: Text(
              message.senderName[0],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ];

      expect(chatBubble, equals(expectedChat));
    });

    test('getChatBubble returns correct chat bubble for bot message', () {
      final message = Message(
        textMessage: 'Hello, Jerry!',
        senderName: 'Bot',
        isMessageFromUser: false,
      );

      final chatBubble = message.getChatBubble(MockBuildContext());

      List<Widget> expectedChat = [
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
              const Text(
                'Bot',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Container(
                margin: const EdgeInsets.only(top: 5.0),
                child: const Text('Hello, Jerry!'),
              ),
            ],
          ),
        ),
      ];

      expect(chatBubble, expectedChat);
    });
  });
}
