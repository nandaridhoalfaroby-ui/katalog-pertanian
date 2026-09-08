// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:katalog_tani/main.dart';

void main() {
  testWidgets('search filters products while typing',
      (WidgetTester tester) async {
    await tester.pumpWidget(const TaniMartApp());

    final searchField = find.byType(TextField);
    expect(searchField, findsOneWidget);

    await tester.enterText(searchField, 'melon');
    await tester.pump();
    await tester.drag(find.byType(CustomScrollView), const Offset(0, -900));
    await tester.pump();

    expect(find.text('Benih Melon Golden Harapan'), findsOneWidget);
    expect(find.text('Benih Tomat Mutiara'), findsNothing);
  });
}

