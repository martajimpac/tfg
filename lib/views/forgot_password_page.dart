import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../components/textField/my_login_textfield.dart';
import '../components/my_button.dart';
import '../utils/ConstantsHelper.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  late TextEditingController _emailController;
  final supabase = Supabase.instance.client;
  bool _isEmailRed = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Recuperar contraseña',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onBackground,
                borderRadius: BorderRadius.circular(12.0),
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
                  const SizedBox(height: 16.0),
                  MyButton(
                    adaptableWidth: false,
                    onTap: () async {
                      final email = _emailController.text.trim();
                      if (email.isEmpty) {
                        setState(() {
                          _isEmailRed = true;
                        });
                      } else {
                        _isEmailRed = false;
                        try {
                          final authResponse = await supabase.auth.resetPasswordForEmail(_emailController.text);
                        } on AuthException catch (error) {
                          // Manejar errores de autenticación
                          if (error.statusCode == "429") {
                            ConstantsHelper.showMyOkDialog(context, "Error", "Se ha excedido el límite de intentos con este correo electrónico.", () {
                              Navigator.of(context).pop();
                            });
                          } else { //"Email rate limit exceeded"
                            ConstantsHelper.showMyOkDialog(context, "Error", "Ha ocurrido un error.\nComprueba que el correo sea correcto.", () {
                              Navigator.of(context).pop();
                            });
                          }
                        } catch (error) {
                          ConstantsHelper.showMyOkDialog(context, "Error", "Ha ocurrido un error.\nComprueba que el correo sea correcto.", () {
                            Navigator.of(context).pop();
                          });
                        }
                      }
                    },
                    text: 'Enviar correo electrónico',
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
