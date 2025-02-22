import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:simple_swipe_button/simple_swipe_button.dart';

void main() {
  testWidgets('Swipe button renders and swipes correctly',
      (WidgetTester tester) async {
    bool isCompleted = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SimpleSwipeButton(
            initialText: 'Swipe to start',
            completedText: 'Completed',
            onSwipeComplete: () {
              isCompleted = true;
            },
          ),
        ),
      ),
    );

    // Verify initial state
    expect(find.text('Swipe to start'), findsOneWidget);
    expect(find.text('Completed'), findsNothing);

    // Find the swipe button
    final swipeButtonFinder = find.byType(GestureDetector);
    expect(swipeButtonFinder, findsOneWidget);

    // Perform swipe action
    await tester.drag(swipeButtonFinder, const Offset(300, 0)); // Swipe right
    await tester.pumpAndSettle();

    // Verify completed state
    expect(isCompleted, isTrue);
    expect(find.text('Completed'), findsOneWidget);
  });
}
