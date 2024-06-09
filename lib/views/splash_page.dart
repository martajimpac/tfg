import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:evaluacionmaquinas/views/login_page.dart'; // Asegúrate de importar GoRouter

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    // Iniciamos un temporizador para navegar a la página de inicio después de tres segundos
    Future.delayed(Duration(seconds: 3), () {
      GoRouter.of(context).go('/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.asset(
            'lib/images/splash.png',
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }
}
