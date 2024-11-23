import 'package:evaluacionmaquinas/components/dialog/my_two_buttons_dialog.dart';
import 'package:evaluacionmaquinas/utils/Utils.dart';
import 'package:evaluacionmaquinas/theme/dimensions.dart';
import 'package:evaluacionmaquinas/views/forgot_password_page.dart';
import 'package:evaluacionmaquinas/views/my_home_page.dart';
import 'package:evaluacionmaquinas/views/register_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_launcher_icons/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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
  late BuildContext _context;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _context = context;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop){

      }, child: Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            S.of(context).loginTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(Dimensions.marginMedium),
            child: Container(
              padding: const EdgeInsets.all(Dimensions.marginMedium),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onBackground,
                borderRadius: BorderRadius.circular(Dimensions.cornerRadius),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(S.of(context).email),
                  MyLoginTextField(
                    controller: _emailController,
                    hintText: S.of(context).hintEmail,
                    isRed: _isEmailRed,
                  ),
                  const SizedBox(height: Dimensions.marginMedium),
                  Text(S.of(context).password),
                  MyLoginTextField(
                    controller: _passwordController,
                    hintText: S.of(context).hintPassword,
                    obscureText: true,
                    isRed: _isPasswordRed,
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
                      style: const TextStyle(
                        fontSize: Dimensions.smallTextSize,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  const SizedBox(height: Dimensions.marginMedium),
                  MyButton(
                    adaptableWidth: false,
                    onTap: () async {
                      final email = _emailController.text.trim();
                      final password = _passwordController.text.trim();

                      _login(email, password);
                      /*Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const MyHomePage()),
                      );*/
                      if(email.isEmpty || password.isEmpty){
                        setState(() {
                          if(email.isEmpty){
                            _isEmailRed = true;
                          }
                          if(password.isEmpty){
                            _isPasswordRed = true;
                          }
                        });
                      }else{
                        _isEmailRed = false;
                        _isPasswordRed = false;

                      }
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
    )
    );
  }

  Future<void> _login(String email, String password) async {
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
      _showErrorDialog("Error desconocido: $error");
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

  /// Muestra un diálogo de error con opción de reenviar correo
  void _showErrorDialogWithResendOption(String message, String email, String password) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MyTwoButtonsDialog(
          title: S.of(context).error,
          desc: message,
          primaryButtonText: "Reenviar correo",
          onPrimaryButtonTap: () async {
            Navigator.of(context).pop();
            await _resendConfirmationEmail(email, password);
          },
          secondaryButtonText: "Cerrar",
          onSecondaryButtonTap: () {
            Navigator.of(context).pop();
          },
          isVertical: true,
        );
      },
    );
  }

  /// Función para reenviar el correo de confirmación
  Future<void> _resendConfirmationEmail(String email, String password) async {
    try {
      final authResponse = await supabase.auth.signUp(
        password: password,
        email: email,
      );
      if(authResponse.user != null){
        Utils.showMyOkDialog(context, "Correo reenviado", "El correo se ha reenviado con éxito. Revise su bandeja de entrada.", () {
          Navigator.of(context).pop();
        });
      }
      //TODO SHOW SUCESS DIALOG
    } catch (error) {
      _showErrorDialog("Ha ocurrido un error al reenviar el correo");
    }
  }

  void _showErrorDialog(String message) {
    Utils.showMyOkDialog(context, S.of(context).error, message, () {
      Navigator.of(context).pop();
    });
  }

}
