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
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late S s;
  // Declara una variable para mantener la instancia de Supabase inicializada
  late SupabaseClient supabaseClient;

  setUpAll(() async {
    // 1. Inicializa WidgetsBinding (ya lo hace ensureInitialized() arriba, pero no está de más)
    WidgetsFlutterBinding.ensureInitialized();

    // 2. Simula la inicialización de Supabase que ocurre en tu main.dart
    //    USA LAS MISMAS CREDENCIALES QUE EN TU main.dart
    await Supabase.initialize(
      url: 'https://mhxryaquargzfumndwgq.supabase.co', // Tu URL de Supabase
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1oeHJ5YXF1YXJnemZ1bW5kd2dxIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTk2NTc0NjgsImV4cCI6MjAxNTIzMzQ2OH0.zuNF8ECVgZPasigxX0cxT1bph-NueCGaJA9kDTPmdZ8', // Tu anonKey
    );
    supabaseClient = Supabase.instance.client; // Guarda la instancia inicializada

    // 3. Carga las localizaciones
    s = await S.load(const Locale('es'));

    // 4. Si tu app tiene lógica de splash que necesitas esperar, puedes simularla aquí
    //    o simplemente asegurarte que pumpAndSettle en el test es suficiente.
    //    FlutterNativeSplash.remove(); // Si quieres removerlo aquí, aunque usualmente se maneja en MyApp
  });

  // Preparación antes de cada test (sin tester)
  setUp(() async {
    // Clear any saved session data
    SharedPreferences.setMockInitialValues({});
  });

  group('Login Page Tests', () {
    testWidgets('Invalid credentials shows error message', (WidgetTester tester) async {
      // AHORA USA LA INSTANCIA DE SUPABASE QUE INICIALIZASTE EN setUpAll
      // Es crucial que MyApp reciba la instancia de Supabase, no que intente obtenerla
      // de un Supabase.instance potencialmente no inicializado en este punto.
      await tester.pumpWidget(app.MyApp(supabase: Supabase.instance)); // Supabase.instance ahora está inicializado
      // gracias al setUpAll

      await tester.pumpAndSettle(const Duration(seconds: 3));

      expect(find.text(s.loginTitle), findsOneWidget);

      final emailField = find.byKey(const Key('usernameField'));
      final passwordField = find.byKey(const Key('passwordField'));
      final loginButton = find.byKey(const Key('loginButton'));

      expect(emailField, findsOneWidget);
      expect(passwordField, findsOneWidget);
      expect(loginButton, findsOneWidget);

      await tester.enterText(emailField, 'usuario@incorrecto.com');
      await tester.pumpAndSettle();
      await tester.enterText(passwordField, 'passwordmal');
      await tester.pumpAndSettle();

      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      expect(find.byType(Dialog), findsOneWidget);
      expect(find.text(s.error), findsOneWidget);
      // Ajusta este mensaje al error específico que esperas para credenciales inválidas
      expect(find.text(s.errorAuthentication), findsOneWidget);
    });

    // ... otros tests ...
    // Asegúrate de que todos los tests que bombean MyApp usen la instancia de Supabase
    // que ya debería estar lista por setUpAll.
    testWidgets('Empty fields shows error message', (WidgetTester tester) async {
      await tester.pumpWidget(app.MyApp(supabase: Supabase.instance)); // De nuevo, Supabase.instance ya está listo
      await tester.pumpAndSettle(const Duration(seconds: 3));

      final loginButton = find.byKey(const Key('loginButton'));
      expect(loginButton, findsOneWidget);

      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      expect(find.text(s.errorEmpty), findsOneWidget);
      await tester.pumpAndSettle(const Duration(seconds: 3));
    });
  });
}