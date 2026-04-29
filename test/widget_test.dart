import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fpo_app/main.dart';

void main() {
  testWidgets('shows the login screen', (WidgetTester tester) async {
    await tester.pumpWidget(const FpoApp());

    expect(find.text('Welcome Back'), findsOneWidget);
    expect(find.text('Login to continue'), findsOneWidget);
    expect(find.text('Register FPO'), findsWidgets);
  });
}
