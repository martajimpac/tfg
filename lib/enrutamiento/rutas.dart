part of '../main.dart';

//
///Configuración y definición de las rutas
final GoRouter _enrutador = GoRouter(

  routes: [

    /// DEEPLINKS ********************************************************************************/

    /// Página de login
    GoRoute(
        path: "/login",
        builder: (context, state) => const LoginPage(),
    ),

    /// Página de detalle de evaluación
    GoRoute(
      path: "/details", // Define el parámetro dinámico
      builder: (context, state) {
          // Obtén el parámetro de query string
          final idEvaluacion = state.uri.queryParameters['idEvaluacion'] ?? '';
          return DetalleEvaluacionPage(
              idEvaluacion: int.parse(idEvaluacion)
          );
      }
    ),

    /// Página de recuperar contraseña
    GoRoute(
      path: "/reset_password", // Define dos parámetros dinámicos
      builder: (context, state) => ResetPasswordPage()
    ),



    ///Página de error
    GoRoute(
      path: "/error",
      builder: (context, state) =>
          ErrorPage(mensajeError: state.extra as String),
    ),
  ],
);
