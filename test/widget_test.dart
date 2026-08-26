// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:o_wild_zimut/main.dart';

void main() {
  testWidgets('OWildZimut app launches correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const OWildZimutApp());

    // Verify that the app title is displayed
    expect(find.text('OWildZimut'), findsOneWidget);

    // Verify that the main screen is loaded
    expect(find.byType(MainScreen), findsOneWidget);
  });

  testWidgets('App bar has info button', (WidgetTester tester) async {
    await tester.pumpWidget(const OWildZimutApp());

    // Verify that the info button is present
    expect(find.byIcon(Icons.info_outline), findsOneWidget);
  });
}
