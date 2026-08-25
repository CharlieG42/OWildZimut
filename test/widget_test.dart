// This is a basic Flutter widget test.
// To learn more about Flutter widget testing, visit:
// https://docs.flutter.dev/cookbook/testing/widget/introduction

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:o_wild_zimut/main.dart';

void main() {
  testWidgets('OWildZimut app loads correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MaterialApp(home: OWildZimutApp()));
    await tester.pumpAndSettle();

    // Verify that the app bar title is present
    expect(find.text('OWildZimut'), findsOneWidget);

    // Verify that the app loads without errors
    expect(find.byType(Scaffold), findsOneWidget);
  });

  testWidgets('About dialog shows correct version', (WidgetTester tester) async {
    // Build our app
    await tester.pumpWidget(const MaterialApp(home: OWildZimutApp()));
    await tester.pumpAndSettle();

    // Tap the help button
    await tester.tap(find.byIcon(Icons.help_outline));
    await tester.pumpAndSettle();

    // Verify the dialog appears
    expect(find.text('À propos de OWildZimut'), findsOneWidget);
    expect(find.text('Version: 0.0.001'), findsOneWidget);

    // Close the dialog
    await tester.tap(find.text('Fermer'));
    await tester.pumpAndSettle();
  });
}
