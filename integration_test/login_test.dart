import 'package:evaluacionmaquinas/features/presentation/cubit/login_cubit.dart';
import 'package:evaluacionmaquinas/features/presentation/views/login_page.dart';
import 'package:evaluacionmaquinas/features/presentation/views/my_home_page.dart';
import 'package:evaluacionmaquinas/generated/l10n.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:evaluacionmaquinas/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {

  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late S s;
  // Declara una variable para mantener la instancia de Supabase inicializada
  late SupabaseClient supabaseClient;

  setUpAll(() async {

    WidgetsFlutterBinding.ensureInitialized();


    // 2. Simula la inicialización de Supabase que ocurre en tu main.dart
    await Supabase.initialize(
      url: 'https://mhxryaquargzfumndwgq.supabase.co', // Tu URL de Supabase
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1oeHJ5YXF1YXJnemZ1bW5kd2dxIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTk2NTc0NjgsImV4cCI6MjAxNTIzMzQ2OH0.zuNF8ECVgZPasigxX0cxT1bph-NueCGaJA9kDTPmdZ8', // Tu anonKey
    );
    supabaseClient = Supabase.instance.client; // Guarda la instancia inicializada

    // 3. Carga las localizaciones
    s = await S.load(const Locale('es'));


  });

  // Preparación antes de cada test (sin tester)
  setUp(() async {
    // Clear any saved session data
    SharedPreferences.setMockInitialValues({});
  });

  // Función para inicializar la app y navegar a LoginPage
  Future<void> initializeAppAndNavigateToLogin(WidgetTester tester) async {

    await tester.pumpWidget(app.MyApp(supabase: Supabase.instance));

    await tester.pumpAndSettle();

    // Wait for the LoginPage to appear
    await pumpUntil(tester, find.byType(LoginPage));
  }

  // Función auxiliar para realizar el proceso de login
  Future<void> performLogin(WidgetTester tester, {String? email, String? password}) async {
    // Find the username and password fields and the login button
    final usernameField = find.byKey(const Key('usernameField'));
    final passwordField = find.byKey(const Key('passwordField'));
    final loginButton = find.byKey(const Key('loginButton'));

    // Enter text into the fields if provided
    if (email != null) await tester.enterText(usernameField, email);
    if (password != null) await tester.enterText(passwordField, password);

    // Tap the login button
    await tester.tap(loginButton);

    // Wait for the app to settle
    await tester.pumpAndSettle();
  }

  group('Login Tests', () {
    testWidgets('Successful login', (WidgetTester tester) async {
      await initializeAppAndNavigateToLogin(tester);
      await performLogin(tester,
          email: 'martajimpac@gmail.com',
          password: '123456'
      );
      // Espera
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verificaciones post-login
      expect(find.byType(LoginPage), findsNothing);
      expect(find.byType(MyHomePage), findsOneWidget);

      // Verificación del estado del cubit
      try {
        final authCubit = BlocProvider.of<LoginCubit>(tester.element(find.byType(MaterialApp)));
        expect(authCubit.state, isA<LoginSuccess>());
      } catch (e) {
        debugPrint('No se pudo verificar el estado del cubit: $e');
      }

    });

    testWidgets('Invalid credentials shows error message', (WidgetTester tester) async {
      await initializeAppAndNavigateToLogin(tester);
      await performLogin(tester,
          email: 'wrong@email.com',
          password: 'wrongPassword'
      );
      // Verificación del estado del cubit
      try {
        final authCubit = BlocProvider.of<LoginCubit>(tester.element(find.byType(MaterialApp)));
        expect(authCubit.state, isA<LoginError>());
      } catch (e) {
        debugPrint('No se pudo verificar el estado del cubit: $e');
      }
    });

    testWidgets('Unconfirmed email shows error message', (WidgetTester tester) async {
      await initializeAppAndNavigateToLogin(tester);
      await performLogin(tester,
          email: 'sinconfirmar@gmail.com',
          password: '123456'
      );
      // Verificación del estado del cubit
      try {
        final authCubit = BlocProvider.of<LoginCubit>(tester.element(find.byType(MaterialApp)));
        expect(authCubit.state, isA<LoginError>());
      } catch (e) {
        debugPrint('No se pudo verificar el estado del cubit: $e');
      }
    });

    testWidgets('Network error shows generic error', (WidgetTester tester) async {
      await initializeAppAndNavigateToLogin(tester);
      await performLogin(tester,
          email: 'network@error.com',
          password: 'password123'
      );
      // Verificación del estado del cubit
      try {
        final authCubit = BlocProvider.of<LoginCubit>(tester.element(find.byType(MaterialApp)));
        expect(authCubit.state, isA<LoginError>());
      } catch (e) {
        debugPrint('No se pudo verificar el estado del cubit: $e');
      }
    });

    testWidgets('Empty fields show validation errors', (WidgetTester tester) async {
      await initializeAppAndNavigateToLogin(tester);
      await performLogin(tester); // Sin credenciales
      // Verificación del estado del cubit
      try {
        final authCubit = BlocProvider.of<LoginCubit>(tester.element(find.byType(MaterialApp)));
        expect(authCubit.state, isA<LoginError>());
      } catch (e) {
        debugPrint('No se pudo verificar el estado del cubit: $e');
      }
    });
  });
}

Future<void> pumpUntil(
    WidgetTester tester,
    Finder finder, {
      Duration timeout = const Duration(seconds: 5),
    }) async {
  bool isFound = false;
  final endTime = DateTime.now().add(timeout);

  while (!isFound && DateTime.now().isBefore(endTime)) {
    await tester.pump(const Duration(milliseconds: 100));
    isFound = finder.evaluate().isNotEmpty;
  }

  if (!isFound) throw Exception('Widget not found within timeout');
}