import 'package:evaluacionmaquinas/core/utils/Constants.dart';
import 'package:evaluacionmaquinas/features/presentation/components/textField/my_textfield.dart';
import 'package:evaluacionmaquinas/features/presentation/cubit/insertar_evaluacion_cubit.dart';
import 'package:evaluacionmaquinas/features/presentation/cubit/preguntas_cubit.dart';
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
  Future<void> initializeAppAndNavigateHome(WidgetTester tester) async {
    await loginAndGoToHome(tester, s);

    // Espera a que las evaluaciones se carguen
    await tester.pumpAndSettle();
  }

  group('Evaluations Tests', () {
    Future<void> waitForEvaluationInserted(
      WidgetTester tester,
      InsertarEvaluacionCubit cubit, {
      Duration step = const Duration(milliseconds: 1000),
      int maxAttempts = 30,
    }) async {
      int attempts = 0;

      while (attempts < maxAttempts) {
        final currentState = cubit.state;

        if (currentState is InsertarEvaluacionInicial) {
          return; // ¡Éxito!
        } else if (currentState is InsertarEvaluacionError) {
          fail(
              "La evaluación falló con el error: ${currentState.errorMessage}");
        }

        await tester.pump(step);
        attempts++;
      }

      fail(
          "La evaluación no alcanzó un estado válido después de $maxAttempts intentos.");
    }

    Future<void> waitForEvaluacionFinished(
      WidgetTester tester,
      PreguntasCubit cubit, {
      Duration step = const Duration(milliseconds: 1000),
      int maxAttempts = 30,
    }) async {
      int attempts = 0;

      while (attempts < maxAttempts) {
        final currentState = cubit.state;

        if (currentState is PreguntasLoaded) {
          return; // ¡Éxito!
        } else if (currentState is PdfError) {
          fail(
              "La evaluación falló con el error: ${currentState.errorMessage}");
        }

        await tester.pump(step);
        attempts++;
      }

      fail(
          "El pdf no se generó correctamente después de $maxAttempts intentos.");
    }

    Future<void> scrollToDatePicker(
      WidgetTester tester,
      Key datePickerKey, {
      required Finder listViewFinder,
      int maxScrollAttempts = 10,
      double scrollOffset = -200.0,
    }) async {
      final pickerFinder = find.byKey(datePickerKey);
      int attempts = 0;

      while (!tester.any(pickerFinder) && attempts < maxScrollAttempts) {
        await tester.drag(listViewFinder, Offset(0.0, scrollOffset));
        await tester.pumpAndSettle();
        attempts++;
      }

      expect(pickerFinder, findsOneWidget,
          reason: 'No se encontró el date picker con la key $datePickerKey');

      await tester.ensureVisible(pickerFinder);
      await tester.pumpAndSettle();
    }

    Future<void> selectDateFromPicker(
      WidgetTester tester,
      Key datePickerKey,
      DateTime dateToSelect,
    ) async {
      final pickerFinder = find.byKey(datePickerKey);

      await tester.tap(pickerFinder);
      await tester.pumpAndSettle();

      // Adaptar según cómo se renderiza el selector de fecha en tu app
      await tester.tap(find.text('${dateToSelect.day}'));
      await tester.tap(find.text('ACEPTAR'));
      await tester.pumpAndSettle();
    }

    Future<void> selectCenter(
      WidgetTester tester, {
      int index = 0, // por defecto, selecciona el primero
    }) async {
      final centersField = find.byKey(arrowCentersKey);
      expect(centersField, findsOneWidget, reason: "Centers field not found");

      await tester.tap(centersField);
      await tester.pumpAndSettle();

      final listViewCenterFinder = find.byKey(listViewCentersKey);
      final items = find.descendant(
        of: listViewCenterFinder,
        matching: find.byWidgetPredicate((widget) => true),
      );

      final itemsList = items.evaluate().toList();

      // Si el índice es válido, realiza la selección
      if (index >= 0 && index < itemsList.length) {
        await tester.tap(find.byWidget(itemsList[index].widget));
        await tester.pumpAndSettle();
      } else {
        // Índice fuera de rango: no hace nada
        debugPrint('selectCenter: índice fuera de rango ($index)');
      }
    }

    Future<void> selectCenterByText(
        WidgetTester tester, {
          required String text,
        }) async {
      final centersField = find.byKey(arrowCentersKey);
      expect(centersField, findsOneWidget, reason: "Centers field not found");

      await tester.tap(centersField);
      await tester.pumpAndSettle();

      final listViewCenterFinder = find.byKey(listViewCentersKey);
      final itemFinder = find.descendant(
        of: listViewCenterFinder,
        matching: find.byWidgetPredicate(
              (widget) {
            if (widget is Text) {
              return widget.data != null && widget.data!.contains(text);
            }
            return widget.toString().contains(text); // fallback por si no es Text
          },
        ),
      );

      expect(itemFinder, findsAtLeastNWidgets(1),
          reason: "No se encontró un elemento que contenga '$text'");

      await tester.tap(itemFinder.first);
      await tester.pumpAndSettle();
    }

    Future<void> enterTextInFieldByHint({
      required WidgetTester tester,
      required String hintText,
      required String value,
    }) async {
      final field = find.widgetWithText(MyTextField, hintText);
      expect(field, findsOneWidget,
          reason: 'Field with hint "$hintText" not found');

      await tester.enterText(field, value);
    }

    Future<void> createEvaluation({
      required WidgetTester tester,
      required bool hasCenter,
      required DateTime? fechaFabricacion,
      required DateTime? fechasServicio,
      required String denomination,
      required String serialNumber,
    }) async {
      // Pulsar el botón de nueva evaluación
      final addButton = find.byKey(addButtonKey);
      expect(addButton, findsOneWidget);
      await tester.tap(addButton);
      await tester.pumpAndSettle(); // Wait for navigation

      // Rellenar los campos obligatorios

      if (hasCenter) {
        await selectCenter(tester);
      }

      await enterTextInFieldByHint(
          tester: tester, hintText: s.hintDenomination, value: denomination);
      await enterTextInFieldByHint(
          tester: tester, hintText: s.hintSerialNumber, value: serialNumber);

      // Rellenar las fechas
      final listViewFinder = find.byKey(listViewNewEvaluationKey);
      expect(listViewFinder, findsOneWidget,
          reason: "Main ListView not found on the screen.");

      await scrollToDatePicker(tester, fechaFabricacionKey,
          listViewFinder: listViewFinder);
      if (fechaFabricacion != null) {
        await selectDateFromPicker(
            tester, fechaFabricacionKey, fechaFabricacion);
      }

      await scrollToDatePicker(tester, fechaServicioKey,
          listViewFinder: listViewFinder);
      if (fechasServicio != null) {
        await selectDateFromPicker(tester, fechaServicioKey, fechasServicio);
      }

      // Guardar los cambios
      final buttonField = find.byKey(buttonFinishEvaluationKey);
      expect(buttonField, findsOneWidget, reason: "Save button not found");
      await tester.tap(buttonField);
      await tester.pumpAndSettle();
    }

    /********************************************************* TEST *****************************************************************/

    testWidgets('Filter evaluations by center', (tester) async {
      await initializeAppAndNavigateHome(tester);

      final buttonFilters = find.byKey(buttonFiltersKey);
      expect(buttonFilters, findsOneWidget, reason: "Filters button not found");
      await tester.tap(buttonFilters);
      await tester.pumpAndSettle();

      await selectCenterByText(tester, text: "Zamora");
      await tester.pumpAndSettle();

      //Aplicar filtros
      final buttonApplyFilters = find.byKey(buttonApplyFiltersKey);
      expect(buttonApplyFilters, findsOneWidget,
          reason: "Apply filters button not found");
      await tester.tap(buttonApplyFilters);
      await tester.pumpAndSettle();

      //Comprobar que solo hay un resultado
      final listView = find.byKey(listViewEvaluationsKey);
      expect(listView, findsOneWidget,
          reason: "Evaluations ListView not found");

      final evaluaciones = find.descendant(
        of: listView,
        matching: find.text('maquina prueba centro'),
      );
      expect(evaluaciones, findsOneWidget);
    });

    testWidgets('Filter evaluations by date', (tester) async {
      await initializeAppAndNavigateHome(tester);

      final buttonFilters = find.byKey(buttonFiltersKey);
      expect(buttonFilters, findsOneWidget, reason: "Filters button not found");
      await tester.tap(buttonFilters);
      await tester.pumpAndSettle();

      await selectDateFromPicker(
          tester, filtroFechaRealizacionKey, DateTime(2025, 06, 15));
      await selectDateFromPicker(
          tester, filtroFechaCaducidadKey, DateTime(2025, 06, 20));

      //Aplicar filtros
      final buttonApplyFilters = find.byKey(buttonApplyFiltersKey);
      expect(buttonApplyFilters, findsOneWidget,
          reason: "Apply filters button not found");
      await tester.tap(buttonApplyFilters);
      await tester.pumpAndSettle();

      //Comprobar que solo hay un resultado
      final listView = find.byKey(listViewEvaluationsKey);
      expect(listView, findsOneWidget,
          reason: "Evaluations ListView not found");

      final evaluaciones = find.descendant(
        of: listView,
        matching: find.text('maquina prueba fechas'),
      );
      expect(evaluaciones, findsOneWidget);
    });

    testWidgets('Filter evaluations by denomination', (tester) async {
      await initializeAppAndNavigateHome(tester);

      final buttonFilters = find.byKey(buttonFiltersKey);
      expect(buttonFilters, findsOneWidget, reason: "Filters button not found");
      await tester.tap(buttonFilters);
      await tester.pumpAndSettle();

      await enterTextInFieldByHint(
          tester: tester, hintText: s.hintDenomination, value: "denominacion");
      await tester.pumpAndSettle();

      //Aplicar filtros
      final buttonApplyFilters = find.byKey(buttonApplyFiltersKey);
      expect(buttonApplyFilters, findsOneWidget,
          reason: "Apply filters button not found");
      await tester.tap(buttonApplyFilters);
      await tester.pumpAndSettle();

      //Comprobar que solo hay un resultado
      final listView = find.byKey(listViewEvaluationsKey);
      expect(listView, findsOneWidget,
          reason: "Evaluations ListView not found");

      final evaluaciones = find.descendant(
        of: listView,
        matching: find.text('maquina prueba denominacion'),
      );
      expect(evaluaciones, findsOneWidget);
    });

    testWidgets('Create new evaluation', (tester) async {
      final s = S();

      await initializeAppAndNavigateHome(tester);

      await createEvaluation(
        tester: tester,
        hasCenter: true,
        fechaFabricacion: DateTime(2025, 10, 10),
        fechasServicio: DateTime(2025, 10, 11),
        denomination: 'Test Denomination',
        serialNumber: 'Test Serial',
      );

      final buttonDialog = find.byKey(primaryButtonKey);
      expect(buttonDialog, findsOneWidget,
          reason: "Confirm save button not found");
      await tester.tap(buttonDialog);
      await tester.pumpAndSettle();

      // Verificación del estado del cubit
      final evaluationsCubit = BlocProvider.of<InsertarEvaluacionCubit>(
          tester.element(find.byType(MaterialApp)));
      await waitForEvaluationInserted(tester, evaluationsCubit);

      //PAGINA DE CHECKLIST
      await tester.pumpAndSettle();

      // Encuentra el ListView por su key
      final listViewCheckList = find.byKey(listViewCategoriesKey);
      expect(listViewCheckList, findsOneWidget,
          reason: "Main ListView not found on the screen.");

      // Busca todos los GestureDetector hijos (los que manejan el tap en cada ítem)
      final gestureDetectors = find.descendant(
        of: listViewCheckList,
        matching: find.byType(GestureDetector),
      );

      expect(gestureDetectors, findsWidgets);

      // Evalúa el finder para obtener la lista de elementos encontrados
      final gestureDetectorsList = gestureDetectors.evaluate().toList();

      // Toma el último GestureDetector
      final lastGestureDetector = gestureDetectorsList.last;

      // Tap en el último elemento
      await tester.tap(
          find.byElementPredicate((element) => element == lastGestureDetector));
      await tester.pumpAndSettle();
      await tester.pumpAndSettle();

      final terminarButton = find.byKey(buttonFinishChecklistKey);
      expect(terminarButton, findsOneWidget, reason: "Finish button not found");
      await tester.tap(terminarButton);
      await tester.pumpAndSettle();

      await waitForEvaluacionFinished(
          tester,
          BlocProvider.of<PreguntasCubit>(
              tester.element(find.byType(MaterialApp))));

      //Comprobar que los datos de la evaluacion se han guardado correctamente
      expect(find.text('Test Denomination'), findsOneWidget);
      expect(find.text('Test Serial'), findsOneWidget);
    });

    testWidgets('Create new evaluacion fails empty center', (tester) async {
      final s = S();

      await initializeAppAndNavigateHome(tester);

      await createEvaluation(
        tester: tester,
        hasCenter: false,
        fechaFabricacion: DateTime(2025, 10, 10),
        fechasServicio: DateTime(2025, 10, 11),
        denomination: 'Test Denominatioin',
        serialNumber: 'Test Serial',
      );

      expect(find.textContaining(s.errorMandatoryFields), findsOneWidget);
    });

    testWidgets('Create new evaluacion fails empty denomination',
        (tester) async {
      final s = S();

      await initializeAppAndNavigateHome(tester);

      await createEvaluation(
        tester: tester,
        hasCenter: true,
        fechaFabricacion: DateTime(2025, 10, 10),
        fechasServicio: DateTime(2025, 10, 11),
        denomination: '',
        serialNumber: 'Test Serial',
      );

      expect(find.textContaining(s.errorMandatoryFields), findsOneWidget);
    });

    testWidgets('Create new evaluacion fails empty serial number',
        (tester) async {
      final s = S();

      await initializeAppAndNavigateHome(tester);

      await createEvaluation(
        tester: tester,
        hasCenter: true,
        fechaFabricacion: DateTime(2025, 10, 10),
        fechasServicio: DateTime(2025, 10, 11),
        denomination: 'Test Denomination',
        serialNumber: '',
      );

      expect(find.textContaining(s.errorMandatoryFields), findsOneWidget);
    });

    testWidgets(
        'Create new evaluacion fails manufacture date after comissioning date',
        (tester) async {
      final s = S();

      await initializeAppAndNavigateHome(tester);

      await createEvaluation(
        tester: tester,
        hasCenter: true,
        fechaFabricacion: DateTime(2025, 10, 12),
        fechasServicio: DateTime(2025, 10, 11),
        denomination: 'Test Denomination',
        serialNumber: 'Test Serial Number',
      );

      expect(find.textContaining(s.errorComissioningDate), findsOneWidget);
    });

    testWidgets('Delete evaluation', (tester) async {
      await initializeAppAndNavigateHome(tester);

      final listView = find.byKey(listViewEvaluationsKey);
      expect(listView, findsOneWidget,
          reason: "Evaluations ListView not found");

      // Contar evaluaciones antes
      final evaluacionesAntes = find.descendant(
        of: listView,
        matching:
            find.byType(GestureDetector), // O tu widget de item de evaluación
      );
      final totalAntes = evaluacionesAntes.evaluate().length;

      await tester.pumpAndSettle();
      // 1. Buscar el WIDGET CONTENEDOR de la evaluación por nombre.
      final evaluacionFinder =
          find.widgetWithText(GestureDetector, 'Test Denomination');
      expect(evaluacionFinder, findsWidgets,
          reason:
              "Evaluation container with text 'Test Denomination' not found");

      // Si esperas múltiples, toma el primero. Si esperas uno, cambia a findsOneWidget y quita .first
      final targetEvaluationContainer = evaluacionFinder.first;

      // 2. Long press sobre el contenedor de la evaluación encontrada
      await tester.longPress(targetEvaluationContainer);
      await tester.pumpAndSettle();

      // 3. Tocar botón de eliminar QUE ES DESCENDIENTE del contenedor específico
      final buttonDeleteInSpecificEvaluation = find.descendant(
        of: targetEvaluationContainer, // ¡Importante! Acota la búsqueda aquí
        matching: find.byKey(buttonDeleteEvaluationKey),
      );
      expect(buttonDeleteInSpecificEvaluation, findsOneWidget,
          reason:
              "Delete button for 'Test Denomination' not found after long press");

      await tester.tap(buttonDeleteInSpecificEvaluation);
      await tester.pumpAndSettle();

      //Confirmar eliminar
      final buttonConfirmDelete = find.byKey(primaryButtonKey);
      expect(buttonConfirmDelete, findsOneWidget,
          reason: "Confirm delete button not found");

      await tester.tap(buttonConfirmDelete);
      await tester.pumpAndSettle();

      // Contar evaluaciones después
      final evaluacionesDespues = find.descendant(
        of: listView,
        matching: find.byType(GestureDetector),
      );
      final totalDespues = evaluacionesDespues.evaluate().length;

      // Comprobar que haya una menos
      expect(totalDespues, totalAntes - 1);
    });
  });
}
