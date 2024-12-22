import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/generated/l10n.dart';
import '../../core/theme/dimensions.dart';
import '../../core/utils/Utils.dart';
import '../components/buttons/my_button.dart';
import '../components/textField/my_login_textfield.dart';

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


  Future<void> _sendEmail() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      Fluttertoast.showToast(
        msg: S.of(context).errorEmpty,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
      );
      setState(() {
        _isEmailRed = true;
      });
    } else {
      setState(() {
        _isEmailRed = false;
      });
      try {
        final authResponse = await supabase.auth.resetPasswordForEmail(_emailController.text);
        Utils.showMyOkDialog(context,
            S.of(context).emailSent,
            S.of(context).emailSentDesc,
                () {Navigator.of(context).pop();}
        );
      } on AuthException catch (error) {
        // Manejar errores de autenticación
        if (error.statusCode == "429") {
          Utils.showMyOkDialog(context, S.of(context).error, S.of(context).errorRecoverPasswordLimit, () {
            Navigator.of(context).pop();
          });
        } else { //Email rate limit exceeded
          Utils.showMyOkDialog(context, S.of(context).error, S.of(context).errorRecoverPasswordEmail, () {
            Navigator.of(context).pop();
          });
          setState(() {
            _isEmailRed = true;
          });
        }
      } catch (error) {
        Utils.showMyOkDialog(context, S.of(context).error, S.of(context).errorRecoverPassword, () {
          Navigator.of(context).pop();
        });
      }


    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          S.of(context).recoverPasswordTitle,
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
                color: Theme.of(context).colorScheme.onPrimary,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[

                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.transparent, // Fondo transparente
                        borderRadius: BorderRadius.circular(12.0), // Bordes redondeados
                        border: Border.all(color: Colors.grey), // Borde visible
                      ),
                      child: Center(
                        child: Text(
                          S.of(context).forgotPasswordDesc,
                          style: Theme.of(context).textTheme.headlineMedium,
                          softWrap: true, // Permite que el texto se ajuste a varias líneas
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: Dimensions.marginBig),

                  Text(S.of(context).email),
                  MyLoginTextField(
                    controller: _emailController,
                    hintText: S.of(context).hintEmail,
                    isRed: _isEmailRed,
                    onSubmited: _sendEmail,
                  ),
                  const SizedBox(height: 16.0),
                  MyButton(
                    adaptableWidth: false,
                    onTap: () async {
                      _sendEmail();
                    },
                    text: S.of(context).sendEmail,
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
