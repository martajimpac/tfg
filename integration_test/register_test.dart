import 'package:evaluacionmaquinas/features/presentation/components/buttons/my_button.dart';
import 'package:evaluacionmaquinas/features/presentation/components/textField/my_login_textfield.dart';
import 'package:evaluacionmaquinas/features/presentation/cubit/login_cubit.dart';
import 'package:evaluacionmaquinas/features/presentation/cubit/register_cubit.dart';
import 'package:evaluacionmaquinas/features/presentation/views/login_page.dart';
import 'package:evaluacionmaquinas/features/presentation/views/my_home_page.dart';
import 'package:evaluacionmaquinas/features/presentation/views/register_page.dart';
import 'package:evaluacionmaquinas/generated/l10n.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:evaluacionmaquinas/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'initegration_helpers.dart';
import 'login_test.dart';
// Para mocking (si lo usas para errores específicos de Supabase)
// import 'package:mockito/mockito.dart';
// import '../test/mocks/mock_repositories.mocks.dart'; // Asegúrate que este mock incluya SupabaseAuthRepository

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late S s;
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
    supabaseClient = Supabase.instance.client;
    s = await S.load(const Locale('es'));
  });

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
  });

  // Función para inicializar la app y navegar a RegisterPage
  Future<void> initializeAppAndNavigateToRegister(WidgetTester tester) async {
    await tester.pumpWidget(app.MyApp(supabase: Supabase.instance));
    await tester.pumpAndSettle();

    // Espera a que aparecezca el login
    await pumpUntil(tester, find.byType(LoginPage));
    // Encuentra y presiona el botón de registro en LoginPage
    final registerButtonOnLogin = find.widgetWithText(MyButton, s.loginButton.toUpperCase());
    expect(registerButtonOnLogin, findsOneWidget, reason: "Botón para ir a registro no encontrado en LoginPage");
    await tester.tap(registerButtonOnLogin);
    await tester.pumpAndSettle();

    // Espera a que aparezca RegisterPage
    await pumpUntil(tester, find.byType(RegisterPage));
    expect(find.byType(RegisterPage), findsOneWidget, reason: "No se pudo navegar a RegisterPage");
  }

  // Función auxiliar para realizar el proceso de registro
  Future<void> performRegistration(WidgetTester tester, {
    String? name,
    String? email,
    String? password,
    String? repeatPassword,
  }) async {
    // Find fields using widgetWithText
    final nameField = find.widgetWithText(MyLoginTextField, s.hintName);
    final emailField = find.widgetWithText(MyLoginTextField, s.hintEmail);
    final passwordFields = find.widgetWithText(MyLoginTextField, s.hintPassword);
    expect(passwordFields, findsNWidgets(2), reason: "Deben existir dos campos de contraseña");

    // Obtener todos los campos que coinciden
    final allPasswordFields = passwordFields.evaluate().toList();

    // Seleccionar el primero como passwordField y el segundo como repeatPasswordField
    final passwordField = find.byWidget(allPasswordFields[0].widget);
    final repeatPasswordField = find.byWidget(allPasswordFields[1].widget);

    final registerButton = find.widgetWithText(MyButton, s.registerButton.toUpperCase());

    // Add expects to verify finders
    expect(nameField, findsOneWidget, reason: "No se encontró el campo de nombre con hint: '${s.hintName}'");
    expect(emailField, findsOneWidget, reason: "No se encontró el campo de email con hint: '${s.hintEmail}'");
    expect(passwordField, findsOneWidget, reason: "No se encontró el campo de contraseña con hint: '${s.hintPassword}'");

    if (name != null) await tester.enterText(nameField, name);
    if (email != null) await tester.enterText(emailField, email);
    if (password != null) await tester.enterText(passwordField, password);


    await tester.ensureVisible(registerButton); // Asegúrate de que el botón es visible
    await tester.tap(registerButton);
    await tester.pumpAndSettle();
  }

  group('Registration Tests', () {
    testWidgets('Successful registration shows confirmation message/navigates', (WidgetTester tester) async {
      await initializeAppAndNavigateToRegister(tester);

      // Genera un email único para cada test para evitar conflictos de "email ya registrado"
      final uniqueEmail = 'testuser_${DateTime.now().millisecondsSinceEpoch}@example.com';

      await performRegistration(tester,
        name: 'Test User',
        email: uniqueEmail,
        password: 'Password123!',
        repeatPassword: 'Password123!'
      );
      await tester.pumpAndSettle(const Duration(seconds: 3)); // Dar tiempo para la respuesta de Supabase

      // Verificación del estado del cubit (asumiendo RegisterSuccess)
      // Necesitas el contexto correcto para obtener el RegisterCubit
      final registerPageElement = tester.element(find.byType(RegisterPage)); // O el widget que use RegisterCubit
      final registerCubit = BlocProvider.of<RegisterCubit>(registerPageElement);
      expect(registerCubit.state, isA<RegisterSuccess>(), reason: "El estado del Cubit debería ser RegisterSuccess");

      //TODO COMPROBAR QUE SE ENVIA CORREO DE CONFIRMACIÓN?
    });

    testWidgets('Registration with already registered email shows error', (WidgetTester tester) async {
      await initializeAppAndNavigateToRegister(tester);

      const existingEmail = 'martajimpac@gmail.com'; // Un email que SABES que ya está registrado

      await performRegistration(tester,
        name: 'Another User',
        email: existingEmail,
        password: 'Password123!',
      );
      await tester.pumpAndSettle();

      final registerPageElement = tester.element(find.byType(RegisterPage));
      final registerCubit = BlocProvider.of<RegisterCubit>(registerPageElement);
      expect(registerCubit.state, isA<RegisterError>());
      final errorState = registerCubit.state as RegisterError; // Asume que RegisterError tiene 'message'
      expect(errorState.message, s.emailAlredyRegistered);

      // También verifica la UI si muestra el error
      expect(find.text(s.emailAlredyRegistered), findsOneWidget);
    });

    /*
    testWidgets('Registration with weak password shows error', (WidgetTester tester) async {
      await initializeAppAndNavigateToRegister(tester);
      final uniqueEmail = 'weakpass_${DateTime.now().millisecondsSinceEpoch}@example.com';

      await performRegistration(tester,
        name: 'Test User',
        email: uniqueEmail,
        password: '123', // Contraseña débil
        repeatPassword: '123'
      );
      await tester.pumpAndSettle();

      final registerPageElement = tester.element(find.byType(RegisterPage));
      final registerCubit = BlocProvider.of<RegisterCubit>(registerPageElement);
      expect(registerCubit.state, isA<RegisterError>());
      final errorState = registerCubit.state as RegisterError;
      expect(errorState.message, s.errorRegisterPasswordMin);

      expect(find.text(s.errorRegisterPasswordMin), findsOneWidget);
    });

    testWidgets('Registration with invalid email format shows error', (WidgetTester tester) async {
      await initializeAppAndNavigateToRegister(tester);

      await performRegistration(tester,
        name: 'Test User',
        email: 'invalidemail', // Email inválido
        password: 'Password123!',
        repeatPassword: 'Password123!',
      );
      await tester.pumpAndSettle();

      final registerPageElement = tester.element(find.byType(RegisterPage));
      final registerCubit = BlocProvider.of<RegisterCubit>(registerPageElement);
      expect(registerCubit.state, isA<RegisterError>());
      final errorState = registerCubit.state as RegisterError;
      expect(errorState.message, s.errorEmailNotValid);

      expect(find.text(s.errorEmailNotValid), findsOneWidget);
    });

    testWidgets('Empty fields show validation error', (WidgetTester tester) async {
      await initializeAppAndNavigateToRegister(tester);
      await performRegistration(tester); // Sin datos
      await tester.pumpAndSettle();

      final registerPageElement = tester.element(find.byType(RegisterPage));
      final registerCubit = BlocProvider.of<RegisterCubit>(registerPageElement);
      expect(registerCubit.state, isA<RegisterError>());
      final errorState = registerCubit.state as RegisterError;
      expect(errorState.message, s.errorEmpty); // Asumiendo que tienes un error genérico de campos vacíos para el registro

      expect(find.text(s.errorEmpty), findsOneWidget);
    });

    testWidgets('Registration with non-matching passwords shows error', (WidgetTester tester) async {
      await initializeAppAndNavigateToRegister(tester);

      final uniqueEmail = 'mismatch_${DateTime.now().millisecondsSinceEpoch}@example.com';

      await performRegistration(tester,
        name: 'Test User',
        email: uniqueEmail,
        password: 'Password123!',
        repeatPassword: 'DifferentPassword123!', // Contraseña diferente
      );
      await tester.pumpAndSettle();

      final registerPageElement = tester.element(find.byType(RegisterPage));
      final registerCubit = BlocProvider.of<RegisterCubit>(registerPageElement);
      expect(registerCubit.state, isA<RegisterError>());
      final errorState = registerCubit.state as RegisterError;
      expect(errorState.message, s.errorPasswordsDontMatch); // Asume que tienes este string en tu clase S

      // Verificación en la UI
      expect(find.text(s.errorPasswordsDontMatch), findsOneWidget);
    });*/

    //TODO TEST SUPABASE RESPUESTA INVALIDA - MOCKEAR SUPABASE
    // Test para "errorRegisterLimit" (429) - Esto SÍ requeriría mockear SupabaseAuthRepository
    // para simular que el método signUp devuelve S.of(context).errorRegisterLimit
    /*
    testWidgets('Registration limit reached shows error', (WidgetTester tester) async {
      // 1. Configura el mock (necesitarías MockSupabaseAuthRepository)
      // when(mockSupabaseAuthRepository.signUp(any, any, any, any))
      //    .thenAnswer((_) async => s.errorRegisterLimit);

      // 2. Bombea la app con el RepositoryProvider mockeado
      // await tester.pumpWidget(
      //   MultiRepositoryProvider(
      //     providers: [
      //       RepositoryProvider<SupabaseAuthRepository>.value(value: mockSupabaseAuthRepository),
      //       // ... otros repositorios si son necesarios
      //     ],
      //     child: app.MyApp(supabase: Supabase.instance),
      //   ),
      // );
      // await tester.pumpAndSettle();
      // await pumpUntil(tester, find.byType(RegisterPage)); // Navega a RegisterPage

      await initializeAppAndNavigateToRegister(tester); // NO PUEDES USAR ESTA SI NECESITAS MOCK. Debes bombear con el mock.

      final uniqueEmail = 'limit_${DateTime.now().millisecondsSinceEpoch}@example.com';
      await performRegistration(tester,
        name: 'Test User',
        email: uniqueEmail,
        password: 'Password123!',
      );
      await tester.pumpAndSettle();

      final registerPageElement = tester.element(find.byType(RegisterPage));
      final registerCubit = BlocProvider.of<RegisterCubit>(registerPageElement);
      expect(registerCubit.state, isA<RegisterError>());
      final errorState = registerCubit.state as RegisterError;
      expect(errorState.message, s.errorRegisterLimit);

      expect(find.text(s.errorRegisterLimit), findsOneWidget);
    });
    */
  });
}

