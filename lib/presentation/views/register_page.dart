
import 'dart:math';


import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/generated/l10n.dart';
import '../../core/theme/dimensions.dart';
import '../../core/utils/Utils.dart';
import '../components/buttons/my_button.dart';
import '../components/textField/my_login_textfield.dart';
import 'login_page.dart';


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


  final FocusNode _campoEmailFocus = FocusNode();
  final FocusNode _campoPasswordFocus = FocusNode();
  final FocusNode _campoRepeatPasswordFocus = FocusNode();

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
    _campoEmailFocus.dispose();
    _campoPasswordFocus.dispose();
    _campoRepeatPasswordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true, // Centra el título
        title: Text(
          S.of(context).registerTitle,
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
                    color: Theme.of(context).colorScheme.onPrimary,
                    borderRadius: BorderRadius.circular(Dimensions.cornerRadius),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(S.of(context).name),
                      MyLoginTextField(
                        controller: _nameController,
                        hintText: S.of(context).hintName,
                        onSubmited: () {
                          FocusScope.of(context).requestFocus(_campoEmailFocus);
                        },
                      ),
                      Text(S.of(context).email),
                      const SizedBox(height: Dimensions.marginMedium),
                      MyLoginTextField(
                        controller: _emailController,
                        hintText: S.of(context).hintEmail,
                        isRed: _isEmailRed,
                        focusNode: _campoEmailFocus,
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
                          FocusScope.of(context).requestFocus(_campoRepeatPasswordFocus);
                        },
                      ),
                      Text(S.of(context).repeatPassword),
                      const SizedBox(height: Dimensions.marginMedium),
                      MyLoginTextField(
                        controller: _repeatPasswordController,
                        hintText: S.of(context).hintPassword,
                        obscureText: true,
                        focusNode: _campoRepeatPasswordFocus,
                        isRed: _isRepeatPasswordRed,
                        onSubmited: () {
                          _register();
                        },
                      ),
                      const SizedBox(height: Dimensions.marginMedium),
                      MyButton(
                        adaptableWidth: false,
                        onTap: () async {
                          _register();
                        },
                        text:S.of(context).registerAndLoginButton,
                      ),
                    ],
                  ),
                )
            ),
          ),
      ),
    );
  }

  Future<void> _register() async {

    // Aquí puedes manejar la lógica de inicio de sesión
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final repeatPassword = _repeatPasswordController.text.trim();
    final name = _nameController.text.trim();
    if (email.isEmpty || password.isEmpty || repeatPassword.isEmpty) {

      Fluttertoast.showToast(
        msg: S.of(context).errorEmpty,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
      );
      setState(() {
        if (email.isEmpty) {
          _isEmailRed = true;
        }
        if (password.isEmpty) {
          _isPasswordRed = true;
        }
        if (repeatPassword.isEmpty) {
          _isRepeatPasswordRed = true;
        }
      });
    } else if (password != repeatPassword) {
      setState(() {
        _isRepeatPasswordRed = true;
        _isPasswordRed = true;
        _isEmailRed = false;
      });

      Fluttertoast.showToast(
        msg: S.of(context).errorPasswordsDontMatch,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
      );
    } else {
      setState(() {
        _isEmailRed = false;
        _isPasswordRed = false;
        _isRepeatPasswordRed = false;
      });

      try {
        // Proceder con el registro
        final authResponse = await supabase.auth.signUp(
          password: password,
          email: email,
          data: {'username': name},
        );

        // Verificar si el usuario existe, pero no tiene identidades (usuario "falso")
        if (authResponse.user != null &&
            authResponse.user!.identities != null &&
            authResponse.user!.identities!.isEmpty)
        {
          Utils.showMyOkDialog(context, S.of(context).error, S.of(context).emailAlredyRegistered, () {
            Navigator.of(context).pop();
          });
        }else{

          //si el usuario no existe procedemos a crear la cuenta
          print("MARTA ${authResponse.user.hashCode}");
          final user = authResponse.user;
          if (user != null && user.userMetadata != null) {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString('email', user.email.toString());
            await prefs.setString('password', password);
            prefs.setString('id', user.id.toString());
            prefs.setString('name', user.userMetadata!['username'].toString());

            // Autenticación exitosa, navega a la siguiente página
            Utils.showMyOkDialog(context, S.of(context).registerSuccessTitle, S.of(context).registerSuccessDesc, () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            });
          } else {
            Utils.showMyOkDialog(context, S.of(context).error, S.of(context).errorRegister, () {
              Navigator.of(context).pop();
            });
          }

        }


      } on AuthException catch (error) {
        if (error.statusCode == "429") {
          Utils.showMyOkDialog(context, S.of(context).error, S.of(context).errorRegisterLimit, () {
            Navigator.of(context).pop();
          });
        } else if (error.statusCode == "422") {
          Utils.showMyOkDialog(context, S.of(context).error,"$error ${S.of(context).errorRegisterPasswordMin}" , () {
            Navigator.of(context).pop();
          });
        } else if (error.statusCode == "400") {
          Utils.showMyOkDialog(context, S.of(context).error, "$error ${S.of(context).errorEmailNotValid}", () {
            Navigator.of(context).pop();
          });
          setState(() {
            _isEmailRed = true;
          });
        }else {
          Utils.showMyOkDialog(context, S.of(context).error,"$error ${S.of(context).errorRegister}" , () {
            Navigator.of(context).pop();
          });
        }
      } catch (error) {
        Utils.showMyOkDialog(context, S.of(context).error, "$error", () {
          Navigator.of(context).pop();
        });
      }
    }
  }

}
