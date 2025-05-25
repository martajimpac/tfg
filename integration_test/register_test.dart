// filepath: c:\Users\marta\Documents\TFG\NUEVA APP\tfg\integration_test\register_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:evaluacionmaquinas/main.dart' as app;
import 'package:flutter/material.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Register page test', (WidgetTester tester) async {
    // Start the app
    app.main();
    await tester.pumpAndSettle();

    // Find the fields and the register button
    final usernameField = find.byKey(const Key('registerUsernameField'));
    final emailField = find.byKey(const Key('registerEmailField'));
    final passwordField = find.byKey(const Key('registerPasswordField'));
    final registerButton = find.byKey(const Key('registerButton'));

    // Enter text into the fields
    await tester.enterText(usernameField, 'newuser');
    await tester.enterText(emailField, 'newuser@example.com');
    await tester.enterText(passwordField, 'password123');

    // Tap the register button
    await tester.tap(registerButton);

    // Wait for the app to settle
    await tester.pumpAndSettle();

    // Verify that the registration was successful (replace with your success condition)
    expect(find.text('Registration Successful'), findsOneWidget);
  });
}
