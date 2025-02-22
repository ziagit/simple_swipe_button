import 'package:flutter/material.dart';
import 'package:simple_swipe_button/simple_swipe_button.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Simple Swipe Button Example')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SimpleSwipeButton(
              initialText: "Swipe to start",
              completedText: "Completed",
              onSwipeComplete: () {
                debugPrint("Swipe Completed!");
              },
            ),
          ),
        ),
      ),
    );
  }
}
