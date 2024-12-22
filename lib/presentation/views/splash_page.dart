import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/generated/l10n.dart';
import 'login_page.dart';
import 'my_home_page.dart'; // Asegúrate de importar GoRouter

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _autoLogin();
  }

  Future<void> _autoLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = prefs.getString('email') ?? '';
    String password = prefs.getString('password') ?? '';

    if (email.isNotEmpty && password.isNotEmpty) {
      _login(email, password);
    } else {
      // Navegar a la página de login si no hay credenciales guardadas
      Future.delayed(const Duration(seconds: 3), () {
        GoRouter.of(context).go('/login');
      });
    }
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
            semanticLabel: "Pantalla de bienvenida",
          ),
        ],
      ),
    );
  }

  Future<void> _login(String email, String password) async {
    try {
      final authResponse = await supabase.auth.signInWithPassword(password: password, email: email);
      final user = authResponse.user;

      if (user != null && user.userMetadata != null) {
        _navigateToHomePage();
      } else {
        if (kDebugMode) {
          print(S.of(context).errorAuthentication);
        }
        _navigateToLoginPage();
      }
    } on AuthException catch (error) {
      _handleAuthError(error);
    } catch (error) {
      if (kDebugMode) {
        print("Auto login: Error desconocido: $error");
      }
    }
  }

  void _navigateToHomePage() {
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MyHomePage()),
      );
    });
  }

  void _navigateToLoginPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  void _handleAuthError(AuthException error) {
    String message;

    switch (error.message) {
      case "Invalid login credentials":
        message = S.of(context).errorAuthenticationCredentials;
        break;
      case "Email not confirmed":
        message = S.of(context).errorAuthenticationNotConfirmed;
        break;
      default:
        message = S.of(context).errorAuthentication;
        break;
    }

    if (kDebugMode) {
      print(message);
    }
    _navigateToLoginPage();
  }
}
