import 'package:flutter/material.dart';
import 'package:flutter_chatbot/src/features/chatting/presentation/screens/dialog_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter ChatBot',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const DialogScreen(),
    );
  }
}
