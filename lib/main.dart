
import 'dart:async';
import 'dart:io';
import 'package:evaluacionmaquinas/cubit/detalles_evaluacion_cubit.dart';
import 'package:evaluacionmaquinas/cubit/eliminar_evaluacion_cubit.dart';
import 'package:evaluacionmaquinas/utils/Constants.dart';
import 'package:evaluacionmaquinas/views/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:evaluacionmaquinas/cubit/insertar_evaluacion_cubit.dart';
import 'package:evaluacionmaquinas/cubit/preguntas_cubit.dart';
import 'package:evaluacionmaquinas/cubit/settings_cubit.dart';
import 'package:evaluacionmaquinas/repository/repositorio_autenticacion.dart';
import 'package:evaluacionmaquinas/repository/repositorio_db_supabase.dart';
import 'package:evaluacionmaquinas/views/my_home_page.dart';
import 'cubit/centros_cubit.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'cubit/evaluaciones_cubit.dart';
import 'cubit/simple_bloc_observer.dart';
import 'generated/l10n.dart';
import 'utils/Utils.dart';
import 'package:go_router/go_router.dart';
import '../views/error_page.dart';
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

    ///Cargo los datos en la base de datos local
    //await RepositorioLocalHive.cargarDatosLocal(supabase);

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
          BlocProvider(create: (context) => EvaluacionesCubit(RepositorioDBSupabase(widget.supabase), {})),
          BlocProvider(create: (context) => DetallesEvaluacionCubit(RepositorioDBSupabase(widget.supabase))),
          BlocProvider(create: (context) => PreguntasCubit(RepositorioDBSupabase(widget.supabase))),
          BlocProvider(create: (context) => EliminarEvaluacionCubit(RepositorioDBSupabase(widget.supabase))),
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
              localizationsDelegates: const [
                  S.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
              supportedLocales: S.delegate.supportedLocales,
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


