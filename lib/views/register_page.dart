import 'package:evaluacionmaquinas/components/my_button.dart';
import 'package:evaluacionmaquinas/theme/dimensions.dart';
import 'package:evaluacionmaquinas/views/my_home_page.dart';
//import 'package:evaluacionmaquinas/views/register_page.dart';
import 'package:flutter/material.dart';
import 'package:evaluacionmaquinas/components/textField/my_textfield.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../components/textField/my_login_textfield.dart';
import '../helpers/ConstantsHelper.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late TextEditingController _emailController;
  late TextEditingController _nameCotroller;
  late TextEditingController _passwordController;
  late TextEditingController _repeatPasswordController;
  bool _passwordsMatch = true;
  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _repeatPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _nameCotroller.dispose();
    _passwordController.dispose();
    _repeatPasswordController.dispose();
    super.dispose();
  }

  void _checkPasswordsMatch() {
    setState(() {
      _passwordsMatch = _passwordController.text == _repeatPasswordController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.black,
      appBar: AppBar(
        title: Center(
          child: Text(
            'Registro',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      ),
      body:  SingleChildScrollView(
          child: Center(
            child:
            Padding(
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
                      const Text("Nombre"),
                      MyLoginTextField(
                        controller: _nameCotroller,
                        hintText: "nombre",
                      ),
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
                      const Text("Repite la contraseña"),
                      MyLoginTextField(
                        controller: _repeatPasswordController,
                        hintText: "*************",
                        obscureText: true,
                      ),
                      const SizedBox(height: Dimensions.marginMedium),
                      MyButton(
                        adaptableWidth: false,
                        onTap: () async {
                          // Aquí puedes manejar la lógica de inicio de sesión
                          final email = _emailController.text;
                          final password = _passwordController.text;
                          try {
                            final authResponse = await supabase.auth.signUp(password: password, email: email, data: {'username': _nameCotroller.text});

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
                              ConstantsHelper.showMyOkDialog(context, "Error", "Ha habido un error en la autenticación", () {Navigator.of(context).pop();});
                            }
                          } catch (error) {
                            // Manejar otros errores
                            print('Error al iniciar sesión: $error');
                          }
                        },
                        text:'Registrarse e iniciar sesión',
                      ),
                    ],
                  ),
                )
            ),
          ),
      ),
    );
  }
}
