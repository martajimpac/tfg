import 'package:flutter_bloc/flutter_bloc.dart';  // Asegúrate de importar Flutter Bloc
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/utils/Utils.dart';
import '../../data/shared_prefs.dart';
import '../../../generated/l10n.dart';
import '../components/dialog/my_two_buttons_dialog.dart';
import '../cubit/login_cubit.dart';
import 'login_page.dart';
import 'my_home_page.dart';
import 'offline_page.dart';


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
    // Usamos addPostFrameCallback para postergar la ejecución de autologin
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LoginCubit>().autologin(context);
    });
  }



  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        switch (state.runtimeType) {
          case LoginSuccess:
            _navigateToHomePage();
            break;

          case LoginError:

            if (state is LoginError) {
              _navigateToLoginPage();
            }
            break;

          default:
            _navigateToLoginPage();
            break;
        }
      },
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Image.asset(
              'assets/images/splash.png',
              fit: BoxFit.cover,
              semanticLabel: S.of(context).semanticlabelWelcomeScreen,
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToHomePage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MyHomePage()),
    );
  }

  void _navigateToLoginPage() {
    Future.delayed(const Duration(seconds: 3), () {
      GoRouter.of(context).go('/login');
    });
  }

  Future<void> _showErrorDialog(String message) async {
    if(await Utils.hayConexion()){
      Utils.showMyOkDialog(context, S.of(context).error, message, () {
        Navigator.of(context).pop();
      });
    }else{
      Utils.showNoConnectionDialog(context);
    }
  }

}
