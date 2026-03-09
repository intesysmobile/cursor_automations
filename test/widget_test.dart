import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cursor_automations/main.dart';

void main() {
  testWidgets('Login e navigazione alla home', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Solar System Admin'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).at(0), 'SolarAdmin');
    await tester.enterText(find.byType(TextFormField).at(1), 'MilkyWay');

    await tester.tap(find.widgetWithText(FilledButton, 'Login'));
    await tester.pumpAndSettle();

    expect(find.text('Sistema Solare'), findsOneWidget);
  });
}
