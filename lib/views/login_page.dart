import 'package:flutter/material.dart';
import 'package:evaluacionmaquinas/components/dialog/my_two_buttons_dialog.dart';
import 'package:evaluacionmaquinas/utils/Utils.dart';
import 'package:evaluacionmaquinas/theme/dimensions.dart';
import 'package:evaluacionmaquinas/views/forgot_password_page.dart';
import 'package:evaluacionmaquinas/views/my_home_page.dart';
import 'package:evaluacionmaquinas/views/register_page.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/buttons/my_button.dart';
import '../components/textField/my_login_textfield.dart';
import '../generated/l10n.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  final supabase = Supabase.instance.client;
  bool _isEmailRed = false;
  bool _isPasswordRed = false;
  final FocusNode _campoPasswordFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _campoPasswordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,  // Esto permite que el contenido se dibuje detrás del AppBar
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            S.of(context).loginTitle,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
        ),
        elevation: 0,  // Eliminar sombra del AppBar
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Stack(
        children: [
          // Imagen de fondo que ocupa toda la pantalla
          Positioned.fill(
            child: Image.asset(
              'lib/images/bg_login.png',  // Asegúrate de que la imagen esté en esta ruta
              fit: BoxFit.cover,  // Esto asegura que la imagen cubra toda la pantalla
              semanticLabel: "",
            ),
          ),
          // Contenido de la página
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(Dimensions.marginMedium),
                child: Container(
                  padding: const EdgeInsets.all(Dimensions.marginMedium),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onPrimary,
                    borderRadius: BorderRadius.circular(Dimensions.cornerRadius),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,  // Esto asegura que el contenedor tenga solo la altura necesaria
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(S.of(context).email),
                      MyLoginTextField(
                        controller: _emailController,
                        hintText: S.of(context).hintEmail,
                        isRed: _isEmailRed,
                        onSubmited: () {
                          FocusScope.of(context).requestFocus(_campoPasswordFocus);
                        },
                      ),
                      const SizedBox(height: Dimensions.marginMedium),
                      Text(S.of(context).password),
                      MyLoginTextField(
                        controller: _passwordController,
                        hintText: S.of(context).hintPassword,
                        obscureText: true,
                        isRed: _isPasswordRed,
                        focusNode: _campoPasswordFocus,
                        onSubmited: () {
                          _login();
                        },
                      ),
                      TextButton(
                        onPressed: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ForgotPasswordPage()),
                          );
                        },
                        child: Text(
                          S.of(context).forgetPassword,
                          style: TextStyle(
                            fontSize: Dimensions.smallTextSize,
                            decoration: TextDecoration.underline,
                            color: Theme.of(context).colorScheme.onSecondaryContainer
                          ),
                        ),
                      ),
                      const SizedBox(height: Dimensions.marginMedium),
                      MyButton(
                        adaptableWidth: false,
                        onTap: () async {
                          _login();
                        },
                        text: S.of(context).loginButton,
                      ),
                      const SizedBox(height: Dimensions.marginMedium),
                      MyButton(
                        adaptableWidth: false,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const RegisterPage()),
                          );
                        },
                        color: Theme.of(context).colorScheme.primary,
                        text: S.of(context).registerButton,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _login() async {

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        if (email.isEmpty) {
          _isEmailRed = true;
        }
        if (password.isEmpty) {
          _isPasswordRed = true;
        }
      });

      Fluttertoast.showToast(
        msg: S.of(context).errorEmpty,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
      );
    } else {
      setState(() {
        _isEmailRed = false;
        _isPasswordRed = false;
      });
    }

    try {
      final authResponse = await supabase.auth.signInWithPassword(password: password, email: email);
      final user = authResponse.user;

      if (user != null && user.userMetadata != null) {
        await _saveUserPreferences(user, password);
        _navigateToHomePage();
      } else {
        _showErrorDialog(S.of(context).errorAuthentication);
      }
    } on AuthException catch (error) {
      _handleAuthError(error, email, password);
    } catch (error) {
      _showErrorDialog(S.of(context).unknownError + "$error");
    }
  }

  Future<void> _saveUserPreferences(User user, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', user.email.toString());
    await prefs.setString('password', password);
    await prefs.setString('id', user.id.toString());
    await prefs.setString('name', user.userMetadata!['username'].toString());
  }

  void _navigateToHomePage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MyHomePage()),
    );
  }

  void _handleAuthError(AuthException error, String email, String password) {
    String message;

    switch (error.message) {
      case "Invalid login credentials":
        message = S.of(context).errorAuthenticationCredentials;
        _showErrorDialog(message);
        setState(() {
          _isEmailRed = true;
          _isPasswordRed = true;
        });
        break;
      case "Email not confirmed":
        message = S.of(context).errorAuthenticationNotConfirmed;
        _showErrorDialogWithResendOption(message, email, password);
        break;
      default:
        message = S.of(context).errorAuthentication;
        _showErrorDialog(message);
        break;
    }
  }

  void _showErrorDialogWithResendOption(String message, String email, String password) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MyTwoButtonsDialog(
          title: S.of(context).error,
          desc: message,
          primaryButtonText: S.of(context).resentEmail,
          onPrimaryButtonTap: () async {
            Navigator.of(context).pop();
            await _resendConfirmationEmail(email, password);
          },
          secondaryButtonText: S.of(context).close,
          onSecondaryButtonTap: () {
            Navigator.of(context).pop();
          },
          isVertical: true,
        );
      },
    );
  }

  Future<void> _resendConfirmationEmail(String email, String password) async {
    try {
      final authResponse = await supabase.auth.signUp(password: password, email: email);
      if (authResponse.user != null) {
        Utils.showMyOkDialog(
          context,
          S.of(context).emailResent,
          S.of(context).emailResentDesc,
              () { Navigator.of(context).pop(); },
        );
      }
    } catch (error) {
      _showErrorDialog(S.of(context).errorEmailResent);
    }
  }

  void _showErrorDialog(String message) {
    Utils.showMyOkDialog(context, S.of(context).error, message, () {
      Navigator.of(context).pop();
    });
  }
}
