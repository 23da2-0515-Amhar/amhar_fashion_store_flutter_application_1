import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:amhar_fashion_store_flutter_application_1/main.dart';

void main() {
  testWidgets('App launches and shows Welcome Screen', (
    WidgetTester tester,
  ) async {
    // Build the app
    await tester.pumpWidget(const AmharFashionApp());

    // Verify Welcome screen texts
    expect(find.text('AMHAR'), findsOneWidget);
    expect(find.text('FASHION'), findsOneWidget);
    expect(find.text('WELCOME'), findsOneWidget);

    // Verify main button
    expect(find.text('GETTING START'), findsOneWidget);
  });
}
