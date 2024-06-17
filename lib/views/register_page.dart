import 'package:evaluacionmaquinas/components/my_button.dart';
import 'package:evaluacionmaquinas/theme/dimensions.dart';
import 'package:evaluacionmaquinas/views/my_home_page.dart';
//import 'package:evaluacionmaquinas/views/register_page.dart';
import 'package:flutter/material.dart';
import 'package:evaluacionmaquinas/components/textField/my_textfield.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../components/textField/my_login_textfield.dart';
import '../utils/ConstantsHelper.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _repeatPasswordController;

  final supabase = Supabase.instance.client;
  bool _isEmailRed = false;
  bool _isPasswordRed = false;
  bool _isRepeatPasswordRed = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _repeatPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    _repeatPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true, // Centra el título
        title: Text(
          'Registro',
          style: Theme.of(context).textTheme.titleMedium,
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
                    color: Theme.of(context).colorScheme.onBackground,
                    borderRadius: BorderRadius.circular(Dimensions.cornerRadius),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text("Nombre"),
                      MyLoginTextField(
                        controller: _nameController,
                        hintText: "nombre",
                      ),
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
                      const Text("Repite la contraseña"),
                      MyLoginTextField(
                        controller: _repeatPasswordController,
                        hintText: "*************",
                        obscureText: true,
                        isRed: _isRepeatPasswordRed,
                      ),
                      const SizedBox(height: Dimensions.marginMedium),
                      MyButton(
                        adaptableWidth: false,
                        onTap: () async {
                          // Aquí puedes manejar la lógica de inicio de sesión
                          final email = _emailController.text.trim();
                          final password = _passwordController.text.trim();
                          final repeatPassword = _repeatPasswordController.text.trim();
                          if(email.isEmpty || password.isEmpty || repeatPassword.isEmpty){
                            setState(() {
                              if(email.isEmpty){
                                _isEmailRed = true;
                              }
                              if(password.isEmpty){
                                _isPasswordRed = true;
                              }
                              if(repeatPassword.isEmpty){
                                _isRepeatPasswordRed = true;
                              }
                            });
                          }else if(password != repeatPassword){
                            setState(() {
                              _isRepeatPasswordRed = true;
                              _isPasswordRed = true;
                              _isEmailRed = false;
                            });

                            Fluttertoast.showToast(
                              msg: "Las contraseñas no coinciden",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.grey,
                              textColor: Colors.white,
                            );
                          }else{
                            _isEmailRed = false;
                            _isPasswordRed = false;
                            _isRepeatPasswordRed = false;
                              try {
                                final authResponse = await supabase.auth.signUp(password: password, email: email, data: {'username': _nameController.text});

                                final user = authResponse.user;
                                if (user != null && user.userMetadata != null) {
                                  SharedPreferences prefs = await SharedPreferences.getInstance();
                                  prefs.setString('email', user.email.toString());
                                  prefs.setString('id', user.id.toString());
                                  prefs.setString('name',  user.userMetadata!['username'].toString());

                                  // Autenticación exitosa, navega a la siguiente página
                                  ConstantsHelper.showMyOkDialog(context, "¡Registrado!", "Usuario registrado con éxito", () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const MyHomePage()),
                                    );
                                  });

                                } else {
                                  ConstantsHelper.showMyOkDialog(context, "Error", "Ha habido un error en el registro", () {Navigator.of(context).pop();});
                                }
                              } on AuthException catch (error) {
                                if (error.statusCode == "429") {
                                  ConstantsHelper.showMyOkDialog(context, "Error", "Se ha excedido el límite de intentos de registro con este correo electrónico", () {
                                    Navigator.of(context).pop();
                                  });
                                } else {
                                  ConstantsHelper.showMyOkDialog(context, "Error", "Ha habido un error en el registro ${error.statusCode}", () {Navigator.of(context).pop();});
                                }
                              }catch (error){
                                ConstantsHelper.showMyOkDialog(context, "Error", "Ha habido un error en el registro", () {Navigator.of(context).pop();});
                              }
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
