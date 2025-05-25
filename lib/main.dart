import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:go_router/go_router.dart';

import 'features/data/repository/repositorio_autenticacion.dart';
import 'features/data/repository/repositorio_db_supabase.dart';
import 'features/presentation/cubit/auto_login_cubit.dart';
import 'features/presentation/cubit/centros_cubit.dart';
import 'features/presentation/cubit/change_password_cubit.dart';
import 'features/presentation/cubit/detalles_evaluacion_cubit.dart';
import 'features/presentation/cubit/eliminar_evaluacion_cubit.dart';
import 'features/presentation/cubit/evaluaciones_cubit.dart';
import 'features/presentation/cubit/insertar_evaluacion_cubit.dart';
import 'features/presentation/cubit/login_cubit.dart';
import 'features/presentation/cubit/edit_profile_cubit.dart';
import 'features/presentation/cubit/preguntas_cubit.dart';
import 'features/presentation/cubit/register_cubit.dart';
import 'features/presentation/cubit/settings_cubit.dart';
import 'features/presentation/cubit/simple_bloc_observer.dart';
import 'features/presentation/views/detalle_evaluacion_page.dart';
import 'features/presentation/views/error_page.dart';
import 'features/presentation/views/login_page.dart';
import 'features/presentation/views/reset_password_page.dart';
import 'features/presentation/views/splash_page.dart';
import 'generated/l10n.dart';

part 'core/enrutamiento/rutas.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  ///Se inicializa el splash screen
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  /// Carga las variables del archivo .env
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    Logger log = Logger();
    log.e('No se ha encontrado envied: $e');
  }

  /// Se obtienen las variables de entorno del fichero .env mediante la librería envied
  Supabase supabase = await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  /// Se inicializa el bloc observer para que muestre los eventos de los blocs
  Bloc.observer = SimpleBlocObserver();

  ///Forzar modo vertical
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

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
  //Para permitir cambiar el locale de la appA
  Locale? _locale;

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  ///Método que se ejecuta al inicio de la aplicación
  void initialization(Supabase supabase) async {
    //Aquí es donde podemos poner los recursos necesarios para nuestra aplicación mientras se muestra la pantalla de inicio.
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
            create: (context) => SupabaseAuthRepository(widget.supabase)),
        RepositoryProvider(
            create: (context) => RepositorioDBSupabase(widget.supabase)),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) =>
                  AutoLoginCubit(context.read<SupabaseAuthRepository>())),
          BlocProvider(
              create: (context) =>
                  LoginCubit(context.read<SupabaseAuthRepository>())),
          BlocProvider(
              create: (context) =>
                  RegisterCubit(context.read<SupabaseAuthRepository>())),
          BlocProvider(
              create: (context) =>
                  ChangePasswordCubit(context.read<SupabaseAuthRepository>())),
          BlocProvider(
              create: (context) =>
                  EditProfileCubit(context.read<SupabaseAuthRepository>())),
          BlocProvider(
              create: (context) =>
                  CentrosCubit(context.read<RepositorioDBSupabase>())),
          BlocProvider(
              create: (context) =>
                  PreguntasCubit(context.read<RepositorioDBSupabase>())),
          BlocProvider(create: (context) => SettingsCubit()),
          BlocProvider(
              create: (context) => InsertarEvaluacionCubit(
                  context.read<RepositorioDBSupabase>())),
          BlocProvider(
              create: (context) =>
                  EvaluacionesCubit(context.read<RepositorioDBSupabase>())),
          BlocProvider(
              create: (context) => DetallesEvaluacionCubit(
                  context.read<RepositorioDBSupabase>())),
          BlocProvider(
              create: (context) => EliminarEvaluacionCubit(
                  context.read<RepositorioDBSupabase>())),
        ],
        child: Builder(
          builder: (context) {
            final settingsCubit = context.watch<SettingsCubit>();
            return MaterialApp.router(
              locale: _locale,
              debugShowCheckedModeBanner: false,
              theme: settingsCubit.state.theme,
              localizationsDelegates: const [
                S.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: S.delegate.supportedLocales,
              title: 'Evaluaciones',
              routerConfig: _enrutador,
            );
          },
        ),
      ),
    );
  }
}
