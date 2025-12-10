import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ecoquest_app/main.dart';

void main() {
  testWidgets('App shows Explore screen', (WidgetTester tester) async {
    await tester.pumpWidget(const EcoQuestApp());
    await tester.pumpAndSettle();

    // The initial screen is Explore — verify its app bar/title is present
    expect(find.text('Explore'), findsOneWidget);
  });
}
