import 'package:evaluacionmaquinas/features/presentation/components/buttons/my_button.dart';
import 'package:evaluacionmaquinas/features/presentation/components/textField/my_login_textfield.dart';
import 'package:evaluacionmaquinas/features/presentation/cubit/login_cubit.dart';
import 'package:evaluacionmaquinas/features/presentation/views/login_page.dart';
import 'package:evaluacionmaquinas/features/presentation/views/my_home_page.dart';
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


  });

  // Preparación antes de cada test (sin tester)
  setUp(() async {
    // Clear any saved session data
    SharedPreferences.setMockInitialValues({});
  });



  group('Evaluations Tests', () {

    testWidgets('Ver lista de evaluaciones', (tester) async {
      final s = await S.load(const Locale('es'));

      await loginAndGoToHome(tester, s);

      // Resto de verificaciones...
    });


    //TODO TEST SUPABASE RESPUESTA INVALIDA - MOCKEAR SUPABASE
  });
}
