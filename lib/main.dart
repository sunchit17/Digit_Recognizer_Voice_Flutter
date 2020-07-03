import 'package:flutter/material.dart';
import 'recognizer_screen.dart';

void main() => runApp(HandwrittenNumberRecognizerApp());

class HandwrittenNumberRecognizerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Number Recognizer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RecognizerScreen(
        title: 'Recognizer Screen',
      ),
    );
  }
}
