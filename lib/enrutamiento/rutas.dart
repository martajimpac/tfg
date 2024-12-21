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


    /// DEEPLINKS ********************************************************************************/

    /// Página de login
    GoRoute(
      path: "/login",
      builder: (context, state) => const LoginPage(),
    ),

    /// Página de detalle de evaluación
    GoRoute(
      path: '/details',
      builder: (context, state) {
        // Extraer el parámetro 'id' desde los query parameters
        final idEvaluacion = state.uri.queryParameters['id'];

        // Validar si el parámetro 'id' es nulo o no es un número
        if (idEvaluacion == null || int.tryParse(idEvaluacion) == null) {
          return const ErrorPage(
            mensajeError: "ID no válido. Verifica el enlace.",
          );
        }

        // Si es válido, navegar a la página de detalles
        return DetalleEvaluacionPage(
          idEvaluacion: int.parse(idEvaluacion), // Seguro convertirlo a entero
        );
      },
    ),

    /// Página de recuperar contraseña
    GoRoute(
        path: "/reset_password", // Define dos parámetros dinámicos
        builder: (context, state) => ResetPasswordPage()
    ),

  ],
);
