import 'package:evaluacionmaquinas/components/my_button.dart';
import 'package:evaluacionmaquinas/helpers/ConstantsHelper.dart';
import 'package:evaluacionmaquinas/theme/dimensions.dart';
import 'package:evaluacionmaquinas/views/forgot_password_page.dart';
import 'package:evaluacionmaquinas/views/my_home_page.dart';
import 'package:evaluacionmaquinas/views/register_page.dart';
import 'package:flutter/foundation.dart';
//import 'package:evaluacionmaquinas/views/register_page.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../components/textField/my_login_textfield.dart';

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
            'Inicio de sesión',
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
                  const Text("Correo electrónico"),
                  MyLoginTextField(
                    controller: _emailController,
                    hintText: "usuario@gmail.com",
                    isRed: _isEmailRed,
                  ),
                  const SizedBox(height: Dimensions.marginMedium),
                  const Text("Contraseña"),
                  MyLoginTextField(
                    controller: _passwordController,
                    hintText: "*************",
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


                    child: const Text(
                      "¿Olvidaste la contraseña?",
                      style: TextStyle(
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
                        try {
                          final authResponse = await supabase.auth.signInWithPassword(password: password, email: email);

                          final user = authResponse.user;
                          if (user != null && user.userMetadata != null) {
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            prefs.setString('email', user.email.toString());
                            prefs.setString('id', user.id.toString());
                            prefs.setString('name',  user.userMetadata!['username'].toString());
                            // Autenticación exitosa, navega a la siguiente página
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const MyHomePage()),
                            );
                          } else {
                            ConstantsHelper.showMyOkDialog(context, "Error", "Ha habido un error en la autenticación", () {
                              Navigator.of(context).pop();
                            });
                          }
                        } on AuthException catch (error) {
                          // Manejar errores de autenticación
                          if (error.statusCode == "400") {
                            if (error.message == "Invalid login credentials") {
                              // Credenciales de inicio de sesión inválidas
                              ConstantsHelper.showMyOkDialog(context, "Error", "Credenciales de inicio de sesión inválidas", () {
                                Navigator.of(context).pop();
                              });
                            } else if (error.message == "Email not confirmed") {
                              // Correo electrónico no confirmado
                              ConstantsHelper.showMyOkDialog(context, "Error", "Correo electrónico no confirmado", () {
                                Navigator.of(context).pop();
                              });
                            } else {
                              // Otro error de autenticación
                              ConstantsHelper.showMyOkDialog(context, "Error", "Error de autenticación", () {
                                Navigator.of(context).pop();
                              });
                            }
                          } else {
                            // Otro error de autenticación
                            ConstantsHelper.showMyOkDialog(context, "Error", "Error de autenticación", () {
                              Navigator.of(context).pop();
                            });
                          }
                        } catch (error) {
                          // Otro error de autenticación
                          ConstantsHelper.showMyOkDialog(context, "Error", "Error de autenticación", () {
                            Navigator.of(context).pop();
                          });
                        }
                      }
                    },
                    text: 'Iniciar sesión',
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
                    text: 'Registrarse',
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
}
