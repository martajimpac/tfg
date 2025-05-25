
import 'package:evaluacionmaquinas/features/presentation/components/buttons/my_button.dart';
import 'package:evaluacionmaquinas/features/presentation/components/textField/my_login_textfield.dart';
import 'package:evaluacionmaquinas/features/presentation/views/login_page.dart';
import 'package:evaluacionmaquinas/features/presentation/views/my_home_page.dart';
import 'package:evaluacionmaquinas/generated/l10n.dart';
import 'package:evaluacionmaquinas/main.dart' as app;
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> pumpUntil(
    WidgetTester tester,
    Finder finder, {
      Duration timeout = const Duration(seconds: 10),
    }) async {
  bool isFound = false;
  final endTime = DateTime.now().add(timeout);

  while (!isFound && DateTime.now().isBefore(endTime)) {
    await tester.pump(const Duration(milliseconds: 100));
    isFound = finder.evaluate().isNotEmpty;
  }

  if (!isFound) throw Exception('Widget not found within timeout');
}

// Función para inicializar la app y navegar a LoginPage
Future<void> initializeAppAndNavigateToLogin(WidgetTester tester) async {

  await tester.pumpWidget(app.MyApp(supabase: Supabase.instance));

  await tester.pumpAndSettle();

  // Wait for the LoginPage to appear
  await pumpUntil(tester, find.byType(LoginPage));
}



Future<void> loginAndGoToHome(
    WidgetTester tester,
    S s,
    ) async {
  await initializeAppAndNavigateToLogin(tester);
  await performLogin(
    tester,
    s: s,
    email: 'martajimpac@gmail.com',
    password: '123456',
  );
  await tester.pumpAndSettle(const Duration(seconds: 2));
  expect(find.byType(MyHomePage), findsOneWidget);
}


Future<void> performLogin(
    WidgetTester tester, {
      required S s,
      String? email,
      String? password,
    }) async {
  final emailField = find.widgetWithText(MyLoginTextField, s.hintEmail);
  final passwordField = find.widgetWithText(MyLoginTextField, s.hintPassword);
  final loginButton = find.widgetWithText(MyButton, s.loginButton.toUpperCase());

  expect(emailField, findsOneWidget);
  expect(passwordField, findsOneWidget);
  expect(loginButton, findsOneWidget);

  if (email != null) await tester.enterText(emailField, email);
  if (password != null) await tester.enterText(passwordField, password);
  await tester.tap(loginButton);
  await tester.pumpAndSettle();
}
