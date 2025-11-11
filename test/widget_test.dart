import 'package:flutter_test/flutter_test.dart';

// THIS IS THE LINE YOU FIXED IN STEP 1
import 'package:flutter_application_1/main.dart'; // <-- Make sure this matches your project name!

void main() {
  testWidgets('Namer App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our app shows the introductory text.
    expect(find.text('A random idea:'), findsOneWidget);

    // Verify that it does NOT show the old counter text.
    expect(find.text('0'), findsNothing);
  });
}
