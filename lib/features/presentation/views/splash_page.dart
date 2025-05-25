import 'package:evaluacionmaquinas/features/presentation/cubit/auto_login_cubit.dart';
import 'package:evaluacionmaquinas/features/presentation/views/login_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Asegúrate de importar Flutter Bloc
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/utils/Utils.dart';
import '../../../generated/l10n.dart';
import '../components/dialog/my_two_buttons_dialog.dart';
import 'my_home_page.dart';
import 'offline_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AutoLoginCubit>().autologin();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AutoLoginCubit, AutoLoginState>(
      listener: (context, state) {
        if (state is AutoLoginSuccess) {
          _navigateToHomePage();
        } else if (state is AutoLoginError) {
          _loginError();
        }
      },
      child: SafeArea(
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
          )),
    );
  }

  void _navigateToHomePage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MyHomePage()),
    );
  }

  void _navigateToLoginPage() {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    });
  }

  Future<void> _loginError() async {
    if (await Utils.hayConexion()) {
      _navigateToLoginPage();
    } else {
      showNoConnectionDialog(context);
    }
  }

  void showNoConnectionDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return MyTwoButtonsDialog(
            title: S.of(context).error,
            desc: S.of(context).noInternetConexion,
            primaryButtonText: S.of(context).continuee,
            secondaryButtonText: S.of(context).retryTitle,
            onPrimaryButtonTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const OfflinePage()));
            },
            onSecondaryButtonTap: () {
              Navigator.of(context).pop();
              context.read<AutoLoginCubit>().autologin();
            },
          );
        });
  }
}
