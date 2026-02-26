// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:TimelessApp/main.dart';

void main() {
  testWidgets('App loads without errors', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());
    
    // Pump a few frames to let initialization complete
    for (int i = 0; i < 5; i++) {
      await tester.pump(const Duration(seconds: 1));
    }

    // Verify that the app loaded successfully (should find a Scaffold)
    expect(find.byType(Scaffold), findsOneWidget);
    
    // Verify that we don't have any error widgets
    expect(tester.takeException(), isNull);
  });

  testWidgets('MyHomePage counter increments smoke test', (WidgetTester tester) async {
    // Build the MyHomePage widget directly for counter testing
    await tester.pumpWidget(MaterialApp(
      home: MyHomePage(title: 'Test Counter'),
    ));

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
