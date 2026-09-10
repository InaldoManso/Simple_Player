// Smoke test for the SimplePlayer example app.
//
// The player itself needs a platform video implementation, which is not
// available under `flutter test`, so this only checks that the demo page and
// its controls build.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:example/main.dart';

void main() {
  testWidgets('example page builds with its controls', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(debugShowCheckedModeBanner: false, home: MyHomePage()),
    );
    await tester.pump();

    expect(find.text('SimplePlayer Example'), findsOneWidget);
    expect(find.text('BoxFit'), findsOneWidget);
    expect(find.text('Using the controller'), findsOneWidget);
    expect(find.byType(DropdownButton<BoxFit>), findsNWidgets(2));
  });
}
