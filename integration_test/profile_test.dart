import 'package:evaluacionmaquinas/core/theme/app_theme.dart';
import 'package:evaluacionmaquinas/core/utils/Constants.dart';
import 'package:evaluacionmaquinas/features/data/models/evaluacion_list_dm.dart';
import 'package:evaluacionmaquinas/features/presentation/components/buttons/my_button.dart';
import 'package:evaluacionmaquinas/features/presentation/components/datePicker/custom_date_picker.dart';
import 'package:evaluacionmaquinas/features/presentation/components/textField/custom_drop_down_field.dart';
import 'package:evaluacionmaquinas/features/presentation/components/textField/my_login_textfield.dart';
import 'package:evaluacionmaquinas/features/presentation/components/textField/my_textfield.dart';
import 'package:evaluacionmaquinas/features/presentation/cubit/change_password_cubit.dart';
import 'package:evaluacionmaquinas/features/presentation/cubit/edit_profile_cubit.dart';
import 'package:evaluacionmaquinas/features/presentation/cubit/evaluaciones_cubit.dart';
import 'package:evaluacionmaquinas/features/presentation/cubit/insertar_evaluacion_cubit.dart';
import 'package:evaluacionmaquinas/features/presentation/cubit/login_cubit.dart';
import 'package:evaluacionmaquinas/features/presentation/cubit/preguntas_cubit.dart';
import 'package:evaluacionmaquinas/features/presentation/cubit/settings_cubit.dart';
import 'package:evaluacionmaquinas/features/presentation/views/login_page.dart';
import 'package:evaluacionmaquinas/features/presentation/views/my_home_page.dart';
import 'package:evaluacionmaquinas/features/presentation/views/profile_page.dart';
import 'package:evaluacionmaquinas/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:evaluacionmaquinas/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'initegration_helpers.dart';

class MockChangePasswordCubit extends Mock implements ChangePasswordCubit {}
class MockEvaluacionesCubit extends Mock implements EvaluacionesCubit {}
class FakeBuildContext extends Fake implements BuildContext {}
class MockSettingsCubit extends Mock implements SettingsCubit {}

class FakeChangePasswordState extends Fake implements ChangePasswordState {}

void main() {

  IntegrationTestWidgetsFlutterBinding.ensureInitialized();


  late S s;
  late SupabaseClient supabaseClient;
  late MockChangePasswordCubit mockChangePasswordCubit;
  late MockEvaluacionesCubit mockEvaluacionesCubit;
  late MockSettingsCubit mockSettingsCubit;
  late ChangePasswordState currentChangePasswordCubitState;

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


  Future<void> initializeMocks() async{
    registerFallbackValue(FakeBuildContext());
    registerFallbackValue(ChangePasswordInitial(false, false));
    registerFallbackValue(FakeBuildContext());

    // Inicializa los mocks
    mockChangePasswordCubit = MockChangePasswordCubit();
    mockEvaluacionesCubit = MockEvaluacionesCubit();
    mockSettingsCubit = MockSettingsCubit();

    // Establece el estado inicial para la variable
    currentChangePasswordCubitState = ChangePasswordInitial(false, false);

    // Configura mockEvaluacionesCubit
    when(() => mockEvaluacionesCubit.evaluaciones).thenReturn(<EvaluacionDataModel>[]);
    when(() => mockEvaluacionesCubit.state).thenReturn(EvaluacionesLoading()); // O el estado inicial que necesites
    when(() => mockEvaluacionesCubit.stream).thenAnswer((_) => Stream<EvaluacionesState>.empty());

    // Configura mockChangePasswordCubit
    when(() => mockChangePasswordCubit.state).thenAnswer((_) {
      print("DEBUG: mockChangePasswordCubit.state accessed, returning: $currentChangePasswordCubitState");
      return currentChangePasswordCubitState;
    });

    when(() => mockChangePasswordCubit.changePassword(any(), any(), any(), any()))
        .thenAnswer((Invocation invocation) async {
      print("DEBUG: mockChangePasswordCubit.changePassword called in mock");
      // Actualiza la variable de estado
      currentChangePasswordCubitState = ChangePasswordSuccess();
      print("DEBUG: currentChangePasswordCubitState updated to: $currentChangePasswordCubitState");
    });
    when(() => mockChangePasswordCubit.stream).thenAnswer((_) => Stream<ChangePasswordState>.empty());
    when(() => mockChangePasswordCubit.emit(any<ChangePasswordState>()))
        .thenReturn(null);


    // Configura mockSettingsCubit
    when(() => mockSettingsCubit.state).thenReturn(SettingsState(theme: MyAppTheme.lightTheme));
    when(() => mockSettingsCubit.stream).thenAnswer((_) => Stream<SettingsState>.empty());
  }


  // Función para inicializar la app y navegar a RegisterPage
  Future<void> initializeAppAndNavigateProfile(WidgetTester tester) async {
    await loginAndGoToHome(tester, s);
    await tester.pumpAndSettle();
  }

  group('Evaluations Tests', () {


    Future<void> enterTextInFieldByHint({
      required WidgetTester tester,
      required String hintText,
      required String value,
    }) async {
      final field = find.widgetWithText(MyLoginTextField, hintText);
      expect(field, findsOneWidget, reason: 'Field with hint "$hintText" not found');

      await tester.enterText(field, value);
    }

    Future<void> enterTextInField({
      required WidgetTester tester,
      required Key key,
      required String value,
    }) async {
      final fieldFinder = find.byKey(key);
      expect(fieldFinder, findsOneWidget, reason: 'Campo con key $key no encontrado');
      await tester.enterText(fieldFinder, value);
      await tester.pumpAndSettle();
    }


    Future<void> editProfile({
      required WidgetTester tester,
      required String name,
      required S s,
    }) async {
      // Pulsar el botón de editar perfil
      final editButton = find.byKey(buttonEditProfileKey);
      expect(editButton, findsOneWidget);
      await tester.tap(editButton);
      await tester.pumpAndSettle();

      // Introducir datos
      await enterTextInFieldByHint(tester: tester, hintText: s.hintName, value: name);
      await tester.pumpAndSettle();

      // Guardar
      final saveButton = find.byKey(buttonSaveProfileKey);
      expect(saveButton, findsOneWidget, reason: "Save button not found");
      await tester.tap(saveButton);
      await tester.pumpAndSettle();
    }


    Future<void> scrollToChangePasswordButton(
        WidgetTester tester, {
          required Finder scrollableFinder,
          int maxScrollAttempts = 10,
          double scrollOffset = -200.0,
        }) async {
      final buttonFinder = find.byKey(buttonChangePasswordPageKey);
      int attempts = 0;

      while (!tester.any(buttonFinder) && attempts < maxScrollAttempts) {
        await tester.drag(scrollableFinder, Offset(0.0, scrollOffset));
        await tester.pumpAndSettle();
        attempts++;
      }

      expect(
        buttonFinder,
        findsOneWidget,
        reason: 'No se encontró el botón de cambio de contraseña con la key $buttonChangePasswordPageKey',
      );

      await tester.ensureVisible(buttonFinder);
      await tester.pumpAndSettle();
    }


    
    Future<void> modifyPassword({
      required WidgetTester tester,
      required String currentPassword,
      required String newPassword,
      required String repeatPassword,
    }) async {
      // Pulsar el botón de modificar contraseña
      final editButton = find.byKey(buttonChangePasswordKey);
      expect(editButton, findsOneWidget);
      await tester.tap(editButton);
      await tester.pumpAndSettle();

      // Introduce la contraseña actual
      await enterTextInField(tester: tester, key: fieldCurrentPasswordKey, value: currentPassword);

      // Introduce la nueva contraseña
      await enterTextInField(tester: tester, key: fieldNewPasswordKey, value: newPassword);

      // Confirma la nueva contraseña
      await enterTextInField(tester: tester, key: fieldRepeatPasswordKey, value: repeatPassword);

      // Pulsa el botón de cambiar contraseña
      final button = find.byKey(buttonChangePasswordPageKey);
      await scrollToChangePasswordButton(
        tester,
        scrollableFinder: find.byType(SingleChildScrollView),
      );
      await tester.pumpAndSettle(); // Espera a que el scroll termine y la UI se asiente

      expect(button, findsOneWidget, reason: 'Change password button not found');
      await tester.tap(button);
      await tester.pumpAndSettle();


    }


    Future<void> waitForChangePasswordError(
        WidgetTester tester,
        ChangePasswordCubit cubit, {
          required String expectedMessage,
          Duration step = const Duration(milliseconds: 1000),
          int maxAttempts = 30,
        }) async {
      int attempts = 0;

      while (attempts < maxAttempts) {
        final currentState = cubit.state;

        if (currentState is ChangePasswordError) {
          // Validamos que el estado sea el esperado
          expect(currentState, isA<ChangePasswordError>());

          // Validamos el mensaje exacto
          if (currentState.message != expectedMessage) {
            fail("Se encontró un error pero con mensaje inesperado: '${currentState.message}'");
          }

          return; // ¡Éxito!
        } else if (currentState is ChangePasswordSuccess) {
          fail("Se obtuvo éxito al cambiar la contraseña cuando se esperaba un error.");
        }

        await tester.pump(step);
        attempts++;
      }

      fail("No se alcanzó un estado de error después de $maxAttempts intentos.");
    }




    /********************************************************* TEST *****************************************************************/

    testWidgets('Modify profile', (tester) async {
      final s = S();

      await initializeAppAndNavigateProfile(tester);

      //navigate to profile
      // Pulsar el botón de perfil
      final profileButton = find.byKey(buttonProfileKey);
      expect(profileButton, findsWidgets);
      await tester.tap(profileButton.first);
      await tester.pumpAndSettle(); // Wait for navigation

      await editProfile(tester: tester, name: "nombre nuevo", s: s);

      // Confirmación final
      final buttonField = find.byKey(okButtonKey);
      expect(buttonField, findsOneWidget, reason: "Ok button not found");
      await tester.tap(buttonField);
      await tester.pumpAndSettle();

      // Verificación cubit
      final editProfileCubit = BlocProvider.of<EditProfileCubit>(tester.element(find.byType(MaterialApp)));
      expect(editProfileCubit.state, isA<EditProfileSuccess>());

      // Verificar que el nombre aparece
      expect(find.text("nombre nuevo"), findsOneWidget, reason: "Updated name not found on screen");
    });

    testWidgets('Modify profile fails with empty fields', (tester) async {
      final s = S();

      await initializeAppAndNavigateProfile(tester);

      await editProfile(tester: tester, name: "", s: s);

      final editProfileCubit = BlocProvider.of<EditProfileCubit>(tester.element(find.byType(MaterialApp)));
      expect(editProfileCubit.state, isA<EditProfileError>()); // Asegúrate de que este estado sea correcto
      final errorState = editProfileCubit.state as EditProfileError;
      expect(errorState.errorCode, errorEmpty);
    });


    testWidgets('Modify password fails with empty fields', (tester) async {
      final s = S();
      await initializeAppAndNavigateProfile(tester);
      await modifyPassword(tester: tester, currentPassword: "", newPassword: "", repeatPassword: "");

      // Verifica que el estado del cubit sea de error
      final changePasswordCubit = BlocProvider.of<ChangePasswordCubit>(
        tester.element(find.byType(MaterialApp)),
      );
      expect(changePasswordCubit.state, isA<ChangePasswordError>());
      final errorState = changePasswordCubit.state as ChangePasswordError;
      expect(errorState.message, s.errorEmpty);
    });

    testWidgets('Modify password fails with incorrect current password', (tester) async {
      final s = S();
      await initializeAppAndNavigateProfile(tester);
      await modifyPassword(
          tester: tester,
          currentPassword: "123456789",
          newPassword: "123456",
          repeatPassword: "123456"
      );

      // Verifica que el estado del cubit sea de error
      final changePasswordCubit = BlocProvider.of<ChangePasswordCubit>(
        tester.element(find.byType(MaterialApp)),
      );

      await waitForChangePasswordError(
        tester,
        changePasswordCubit,
        expectedMessage: s.errorChangePasswordIncorrect,
      );

    });

    testWidgets('Modify password fails with different passwords', (tester) async {
      final s = S();
      await initializeAppAndNavigateProfile(tester);
      await modifyPassword(
          tester: tester,
          currentPassword: "123456",
          newPassword: "1234567",
          repeatPassword: "12345678"
      );

      // Verifica que el estado del cubit sea de error
      final changePasswordCubit = BlocProvider.of<ChangePasswordCubit>(
        tester.element(find.byType(MaterialApp)),
      );
      expect(changePasswordCubit.state, isA<ChangePasswordError>());
      final errorState = changePasswordCubit.state as ChangePasswordError;
      expect(errorState.message, s.errorChangePasswordNoMatch);
    });


    testWidgets('Modify password fails with password too short', (tester) async {
      final s = S();
      await initializeAppAndNavigateProfile(tester);
      await modifyPassword(
          tester: tester,
          currentPassword: "123456",
          newPassword: "12345",
          repeatPassword: "12345"
      );

      // Verifica que el estado del cubit sea de error
      final changePasswordCubit = BlocProvider.of<ChangePasswordCubit>(
        tester.element(find.byType(MaterialApp)),
      );
      expect(changePasswordCubit.state, isA<ChangePasswordError>());
      final errorState = changePasswordCubit.state as ChangePasswordError;
      expect(errorState.message, s.errorChangePasswordLength);
    });

    testWidgets('Modify password fails with same password as current', (tester) async {
      final s = S();
      await initializeAppAndNavigateProfile(tester);
      await modifyPassword(
          tester: tester,
          currentPassword: "123456",
          newPassword: "123456",
          repeatPassword: "123456"
      );

      //esperar unos segundos
      await tester.pump(const Duration(seconds: 3));

      // Verifica que el estado del cubit sea de error
      final changePasswordCubit = BlocProvider.of<ChangePasswordCubit>(
        tester.element(find.byType(MaterialApp)),
      );
      expect(changePasswordCubit.state, isA<ChangePasswordError>());
      final errorState = changePasswordCubit.state as ChangePasswordError;
      expect(errorState.message, s.errorChangePasswordNoChange);
    });

    testWidgets('Modify password success', (tester) async {

      final s = S();

      await initializeAppAndNavigateProfile(tester);

      await initializeMocks();

      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<ChangePasswordCubit>.value(value: mockChangePasswordCubit),
            BlocProvider<EvaluacionesCubit>.value(value: mockEvaluacionesCubit),
            BlocProvider<SettingsCubit>.value(value: mockSettingsCubit),
          ],
          child: MaterialApp(
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            home: ProfilePage(), // Ahora ProfilePage encontrará SettingsCubit
          ),
        ),
      );
      await tester.pumpAndSettle();


      // Ahora llamar la función que modifica la contraseña
      await modifyPassword(
        tester: tester,
        currentPassword: "123456",
        newPassword: "1234567",
        repeatPassword: "1234567",
      );

      //esperar
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 8));

      // Obtener el cubit del contexto de ProfilePage:
      final changePasswordCubit = BlocProvider.of<ChangePasswordCubit>(
        tester.element(find.byType(MaterialApp)),
      );

      expect(changePasswordCubit.state, isA<ChangePasswordSuccess>());
    });

  });
}
