import 'package:evaluacionmaquinas/features/presentation/cubit/login_cubit.dart';
import 'package:evaluacionmaquinas/generated/l10n.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'initegration_helpers.dart';

void main() {

  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late S s;
  // Declara una variable para mantener la instancia de Supabase inicializada
  late SupabaseClient supabaseClient;

  setUpAll(() async {

    WidgetsFlutterBinding.ensureInitialized();


    // Simula la inicialización de Supabase que ocurre en tu main.dart
    await dotenv.load(fileName: ".env");
    // Inicializa Supabase con variables desde el .env
    await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL']!,
      anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
    );
    supabaseClient = Supabase.instance.client; // Guarda la instancia inicializada

    // 3. Carga las localizaciones
    s = await S.load(const Locale('es'));

    SharedPreferences.setMockInitialValues({});
  });

  // Preparación antes de cada test (sin tester)
  setUp(() async {
    // Clear any saved session data
    SharedPreferences.setMockInitialValues({});
  });




  group('Login Tests', () {
    testWidgets('Successful login', (WidgetTester tester) async {
      await initializeAppAndNavigateToLogin(tester);
      await performLogin(tester,
          s: s,
          email: 'martajimpac@gmail.com',
          password: '123456'
      );
      // Espera
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verificación del estado del cubit
      final authCubit = BlocProvider.of<LoginCubit>(tester.element(find.byType(MaterialApp)));
      expect(authCubit.state, isA<LoginSuccess>());
    });

    testWidgets('Invalid credentials shows error message', (WidgetTester tester) async {
      await initializeAppAndNavigateToLogin(tester);
      await performLogin(tester,
          s: s,
          email: 'wrong@email.com',
          password: 'wrongPassword'
      );

      // Verificación del estado del cubit
      final authCubit = BlocProvider.of<LoginCubit>(tester.element(find.byType(MaterialApp)));
      expect(authCubit.state, isA<LoginError>());
      final errorState = authCubit.state as LoginError;
      expect(errorState.message, s.errorAuthenticationCredentials);
    });

    testWidgets('Unconfirmed email shows error message', (WidgetTester tester) async {
      await initializeAppAndNavigateToLogin(tester);
      await performLogin(tester,
          s: s,
          email: 'sinconfirmar@gmail.com',
          password: '123456'
      );
      // Verificación del estado del cubit
      final authCubit = BlocProvider.of<LoginCubit>(tester.element(find.byType(MaterialApp)));
      expect(authCubit.state, isA<LoginError>());
      final errorState = authCubit.state as LoginError;
      expect(errorState.message, s.errorAuthenticationNotConfirmed);
    });

    testWidgets('Empty fields show validation errors', (WidgetTester tester) async {
      await initializeAppAndNavigateToLogin(tester);
      await performLogin(tester, s: s); // Sin credenciales
      // Verificación del estado del cubit
      final authCubit = BlocProvider.of<LoginCubit>(tester.element(find.byType(MaterialApp)));
      expect(authCubit.state, isA<LoginError>());
      final errorState = authCubit.state as LoginError;
      expect(errorState.message, s.errorEmpty);
    });
  });


}
