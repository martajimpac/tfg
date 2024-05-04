import 'package:evaluacionmaquinas/components/my_button.dart';
import 'package:evaluacionmaquinas/theme/dimensions.dart';
import 'package:evaluacionmaquinas/views/my_home_page.dart';
import 'package:evaluacionmaquinas/views/register_page.dart';
//import 'package:evaluacionmaquinas/views/register_page.dart';
import 'package:flutter/material.dart';
import 'package:evaluacionmaquinas/components/my_textfield.dart';

import '../components/my_login_textfield.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

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
      //backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            'Inicio de sesión',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      ),
      body: Container(
        /*decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("lib/images/default_pdf.png"),
            fit: BoxFit.cover,
          ),
        ),*/
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.marginMedium),
          child: Container(
            padding: const EdgeInsets.all(Dimensions.marginMedium),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onPrimaryContainer, // Establece el fondo blanco
              borderRadius: BorderRadius.circular(Dimensions.cornerRadius), // Establece bordes redondeados
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
                const SizedBox(height: Dimensions.marginMedium),
                const Text(
                    "¿Olvidaste la constraseña?",
                    style: TextStyle(fontSize: Dimensions.smallTextSize,decoration: TextDecoration.underline)
                ),
                const SizedBox(height: Dimensions.marginMedium),
                MyButton(
                  adaptableWidth: false,
                  onTap: () {
                    // Aquí puedes manejar la lógica de inicio de sesión
                    final email = _emailController.text;
                    final password = _passwordController.text;
                    // Aquí puedes usar las variables email y password para iniciar sesión

                    Navigator.push(context, MaterialPageRoute(builder: (context) => const MyHomePage()),);
                  },
                  text:'Iniciar sesión',
                ),
                MyButton(
                  adaptableWidth: false,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterPage()),);
                  },
                  text:'Registrarse',
                ),
              ],
            ),
          )
        ),
      ),
    );
  }
}
