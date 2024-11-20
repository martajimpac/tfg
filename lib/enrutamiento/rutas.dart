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
      path: "/details/:itemId", // Define el parámetro dinámico
      name: "details", // Corrige el nombre
      builder: (context, state) => DetalleEvaluacionPage(
        idEvaluacion: int.parse(state.pathParameters['itemId']!), // Convierte a int
      ),
    ),

    ///*******************************************************************************************/

    /// Página de inicio
    /*GoRoute(
      path: "/home",
      name: 'home',
      builder: (context, state) => const MyHomePage(),
      routes: [
        /// Página de Mis evaluaciones
        GoRoute(
          name: 'mis_evaluaciones',
          path: "mis_evaluaciones",
          builder: (context, state) => const MisEvaluaccionesPage(),
          routes: [
            GoRoute(
              name: 'filtros',
              path: "filtros",
              builder: (context, state) => const FiltrosPage(),
            ),
            GoRoute(
              name: 'detalle_evaluaciones',
              path: "detalle_evaluaciones",
              builder: (context, state) => DetalleEvaluaccionPage(idEvaluacion: idEvaluacion), //TODO REVISAR
            )
          ]
        ),
        /// Página de Nueva evaluación
        GoRoute(
          name: 'nueva_evaluacion',
          path: "nueva_evaluacion",
          builder: (context, state) => const NuevaEvaluacionPage(),
          routes: [
            GoRoute(
              name: 'checklist',
              path: "checklist",
              builder: (context, state) => const CheckListPage(),
              routes: [
                GoRoute(
                    name: 'pdf',
                    path: "pdf",
                    builder: (context, state) => const PdfPage(),
                )
              ]
            )
          ],
        ),
        /// Página de Perfil de Usuario
        GoRoute(
          name: 'perfil',
          path: "perfil",
          builder: (context, state) => const ProfilePage(),
        ),
      ],
    ),*/


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


    ///Página de formulario de registro
    /*GoRoute(
      name: 'registro',
      path: "/registro",
      builder: (context, state) =>
      const RegisterPage(),
    ),*/
  ],
);
