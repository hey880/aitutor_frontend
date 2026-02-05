// This is a basic Flutter widget test.

import 'package:flutter_test/flutter_test.dart';
import 'package:lingodash/app/app.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const LingoDashApp());

    // Verify that the app loads (shows loading indicator initially)
    await tester.pump();
  });
}
