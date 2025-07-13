import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:attempt_3/pages/home_page.dart';

void main() {
  testWidgets('Shows loading indicator before camera initializes', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomePage()));

    // Should show a CircularProgressIndicator while camera is initializing
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}