import 'package:evaluacionmaquinas/components/my_button.dart';
import 'package:evaluacionmaquinas/helpers/ConstantsHelper.dart';
import 'package:evaluacionmaquinas/theme/dimensions.dart';
import 'package:evaluacionmaquinas/views/my_home_page.dart';
import 'package:evaluacionmaquinas/views/register_page.dart';
import 'package:flutter/foundation.dart';
//import 'package:evaluacionmaquinas/views/register_page.dart';
import 'package:flutter/material.dart';
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                borderRadius: BorderRadius.circular(Dimensions.cornerRadius),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text("Correo electrónico"),
                  MyLoginTextField(
                    controller: _emailController,
                    hintText: "usuario@gmail.com",
                  ),
                  const SizedBox(height: Dimensions.marginMedium),
                  const Text("Contraseña"),
                  MyLoginTextField(
                    controller: _passwordController,
                    hintText: "*************",
                    obscureText: true,
                  ),
                  TextButton(
                    onPressed: () async {
                      try {
                        final authResponse = await supabase.auth.resetPasswordForEmail(_emailController.text);
                      } on AuthException catch (error) {
                        // Manejar errores de autenticación
                        if (error.statusCode == "400") {
                          ConstantsHelper.showMyOkDialog(context, "Error", error.message, () {
                            Navigator.of(context).pop();
                          });
                        } else {
                          ConstantsHelper.showMyOkDialog(context, "Error", error.message, () {
                            Navigator.of(context).pop();
                          });
                        }
                      } catch (error) {
                        // Manejar otros tipos de errores
                        ConstantsHelper.showMyOkDialog(context, "Error", error.toString(), () {
                          Navigator.of(context).pop();
                        });
                      }
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
                      final email = _emailController.text;
                      final password = _passwordController.text;
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const MyHomePage()),
                      );

                      /*try {
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
                          ConstantsHelper.showMyOkDialog(context, "Error", "Usuario no verificado. Comprueba el correo", () {
                            Navigator.of(context).pop();
                          });
                        } else {
                          // Otros errores de autenticación
                          if (kDebugMode) {
                            print('Error al iniciar sesión: $error');
                          }
                        }
                      } catch (error) {
                        // Manejar otros tipos de errores
                        if (kDebugMode) {
                          print('Error al iniciar sesión: $error');
                        }
                      }*/

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
    );
  }
}
