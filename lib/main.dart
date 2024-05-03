
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:evaluacionmaquinas/cubit/insertar_evaluacion_cubit.dart';
import 'package:evaluacionmaquinas/cubit/preguntas_cubit.dart';
import 'package:evaluacionmaquinas/cubit/settings_cubit.dart';
import 'package:evaluacionmaquinas/repository/repositorio_autenticacion.dart';
import 'package:evaluacionmaquinas/repository/repositorio_db_supabase.dart';
import 'package:evaluacionmaquinas/views/checklist_page.dart';
import 'package:evaluacionmaquinas/views/detalle_evaluacion_page.dart';
import 'package:evaluacionmaquinas/views/filtros_page.dart';
import 'package:evaluacionmaquinas/views/login_page.dart';
import 'package:evaluacionmaquinas/views/my_home_page.dart';
import 'package:evaluacionmaquinas/views/nueva_evaluacion_page.dart';
import 'package:evaluacionmaquinas/views/pdf_page.dart';
import 'package:evaluacionmaquinas/views/terminar_page.dart';
import 'cubit/categorias_cubit.dart';
import 'cubit/centros_cubit.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'cubit/evaluaciones_cubit.dart';
import 'cubit/simple_bloc_observer.dart';
import 'env/env.dart';
import 'helpers/ConstantsHelper.dart';
import 'package:go_router/go_router.dart';

import '../views/error_page.dart';
import '../views/mis_evaluaciones_page.dart';
import '../views/my_home_page.dart';
import '../views/nueva_evaluacion_page_old.dart';
import '../views/profile_page.dart';
import '../views/register_page.dart';
import '../views/splash_page.dart';

part 'enrutamiento/rutas.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  ///Se inicializa el splash screen
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  /// Inicializo HIVE para el almacenamiento local de datos
  //await RepositorioLocalHive.inicializarHive();

  /// Se obtienen las variables de entorno del fichero .env mediante la librería envied

  Supabase supabase = await Supabase.initialize(
    url: 'https://mhxryaquargzfumndwgq.supabase.co',
    anonKey:
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1oeHJ5YXF1YXJnemZ1bW5kd2dxIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTk2NTc0NjgsImV4cCI6MjAxNTIzMzQ2OH0.zuNF8ECVgZPasigxX0cxT1bph-NueCGaJA9kDTPmdZ8',
  );
/*  Supabase supabase;

  switch (entornoVersion) {
    case EntornoVersion.produccion:
      supabase = await Supabase.initialize(
          url: Env.urlSupaPro, anonKey: Env.keySupaPro, debug: false);
      break;
    case EntornoVersion.desarrollo:
      supabase = await Supabase.initialize(
          url: Env.urlSupa, anonKey: Env.keySupa, debug: true);
      break;
  // Por defecto genero versión para desarrollo
    default:
      supabase = await Supabase.initialize(
          url: Env.urlSupa, anonKey: Env.keySupa, debug: true);
  }*/

  /// Se inicializa el bloc observer para que muestre los eventos de los blocs
  Bloc.observer = SimpleBlocObserver();

  runApp(MyApp(supabase: supabase));
}


class MyApp extends StatefulWidget {
  const MyApp({required this.supabase, super.key});
  final Supabase supabase;

  @override
  State<MyApp> createState() => _MyAppState();

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }
}

class _MyAppState extends State<MyApp> {
  //Para permitir cambiar el locale de la app
  Locale? _locale;

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  ///Método que se ejecuta al inicio de la aplicación
  void initialization(Supabase supabase) async {
    //Aquí es donde podemos poner los recursos necesarios para nuestra aplicación mientras se muestra la pantalla de inicio.
    // Elimine el siguiente ejemplo porque retrasar la experiencia del usuario es una mala práctica de diseño.
    //Como ejemplo añado un delay de un segundo para que se muestre el splash screen
    //var logger = Logger(filter: FiltroLogs());
    //logger.d('Inicializando...');

    await Future.delayed(const Duration(seconds: 1));

    ///Cargo los datos en la base de datos local
    //await RepositorioLocalHive.cargarDatosLocal(supabase);

    // logger.d('¡Inicialización Completada!');
    FlutterNativeSplash.remove();
  }

  @override
  void initState() {
    super.initState();
    //Por defecto el locale es el castellano
    _locale = const Locale('es', 'ES');
    initialization(widget.supabase);
  }


  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => SupabaseAuthRepository(widget.supabase),
        ),
        RepositoryProvider(
          create: (context) => RepositorioDBSupabase(widget.supabase),
        ),
        /*RepositoryProvider(
        create: (context) => RepositorioLocalHive(),
      ),*/
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => CentrosCubit(RepositorioDBSupabase(widget.supabase))),
          BlocProvider(create: (context) => PreguntasCubit(RepositorioDBSupabase(widget.supabase))),
          BlocProvider(create: (context) => SettingsCubit()),
          BlocProvider(create: (context) => InsertarEvaluacionCubit(RepositorioDBSupabase(widget.supabase))),
          BlocProvider(create: (context) => EvaluacionesCubit(RepositorioDBSupabase(widget.supabase))),
          BlocProvider(create: (context) => PreguntasCubit(RepositorioDBSupabase(widget.supabase))),
        ],
        child: Builder(
          builder: (context) {
            final settingsCubit = context.watch<SettingsCubit>();
            return MaterialApp.router(
              locale: _locale,
              // Se muestra el banner de debug en la esquina superior derecha en desarrollo
              debugShowCheckedModeBanner: entornoVersion ==
                  EntornoVersion.desarrollo,
              theme: settingsCubit.state.theme,
              /*localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],*/
              supportedLocales: const [
                Locale('en', 'EN'), // English
                Locale('es', 'ES'), // Spanish
                Locale('eu', 'EU'), // Euskera
                Locale('ga', 'GA'), // Gallego
                Locale('ca', 'CA'), // Catalán
              ],
              localizationsDelegates: const [
                // Añade aquí los delegados de localización necesarios
                DefaultMaterialLocalizations.delegate,
                DefaultWidgetsLocalizations.delegate,
                //AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              title: 'Evaluaciones',
              // theme: state.theme
              routerConfig: _enrutador,
            );
          },
        ),
      ),
    );
  }
}


