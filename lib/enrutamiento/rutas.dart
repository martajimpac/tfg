part of '../main.dart';

//
///Configuración y definición de las rutas
final GoRouter _enrutador = GoRouter(
  debugLogDiagnostics: false,
  initialLocation: '/',
  //Página a mostrar si no se encuentra la ruta u otro error en el enrutamiento
  errorBuilder: (context, state) => ErrorPage(
    mensajeError: state.error.toString(),
  ),
  routes: [

    /// DEEPLINKS ********************************************************************************/

    /// Página de login
    GoRoute(
        path: "/login",
        name: 'login',
        builder: (context, state) => const LoginPage(),
    ),

    /// Página de detalle de evaluación
    GoRoute(
      path: "/details/:idEvaluacion", // Define el parámetro dinámico
      name: "details",
      builder: (context, state) => DetalleEvaluacionPage(
        idEvaluacion: int.parse(state.pathParameters['idEvaluacion']!), // Convierte a int
      ),
    ),

    /// Página de recuperar contraseña
    GoRoute(
      path: "/reset_password/:token/:email", // Define dos parámetros dinámicos
      name: "reset_password",
      builder: (context, state) => ResetPasswordPage(
        token: state.pathParameters['token']!,
        email: state.pathParameters['email']!,
      )
    ),


    ///*******************************************************************************************/

    /// Página de splash
    GoRoute(
      path: "/",
      name: 'splash',
      builder: (context, state) => const SplashPage(),
    ),


    ///Página de error
    GoRoute(
      path: "/error",
      builder: (context, state) =>
          ErrorPage(mensajeError: state.extra as String),
    ),
  ],
);
