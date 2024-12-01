import 'package:evaluacionmaquinas/theme/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../components/buttons/my_button.dart';
import '../components/textField/my_login_textfield.dart';
import '../generated/l10n.dart';
import '../utils/Utils.dart';
import 'login_page.dart';

/** PÁGINA PARA RESETEAR LA CONTRASEÑA
 *  Solo se puede acceder aqui mediante un deeplink
 */
class ResetPasswordPage extends StatefulWidget {
  final String email;
  final String token; // Agregar el token de restablecimiento de contraseña
  const ResetPasswordPage({super.key, required this.token, required this.email});

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  late TextEditingController _newPasswordController;
  late TextEditingController _confirmPasswordController;
  final supabase = Supabase.instance.client;
  bool _isNewPasswordRed = false;
  bool _isConfirmPasswordRed = false;

  @override
  void initState() {
    super.initState();
    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    setState(() {
      _isNewPasswordRed = newPassword.isEmpty;
      _isConfirmPasswordRed = confirmPassword.isEmpty;
    });

    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      return;
    }

    if (newPassword != confirmPassword) {
      Utils.showMyOkDialog(context, S.of(context).error, S.of(context).errorChangePasswordNoMatch, () {
        Navigator.of(context).pop();
      });
      setState(() {
        _isNewPasswordRed = true;
        _isConfirmPasswordRed = true;
      });
      return;
    }
    if (newPassword.length < 6) {
      Utils.showMyOkDialog(context, S.of(context).error, S.of(context).errorChangePasswordLength, () {
        Navigator.of(context).pop();
      });
      setState(() {
        _isNewPasswordRed = true;
        _isConfirmPasswordRed = true;
      });
      return;
    }

    try {

      await Supabase.instance.client.auth.setSession(widget.token);
      // Usamos el método resetPassword de Supabase para resetear la contraseña usando el token
      await Supabase.instance.client.auth.updateUser(
        UserAttributes(
          email: widget.email,
          password: newPassword,
        ),
      );

      // Si el restablecimiento es exitoso
      Utils.showMyOkDialog(context, S.of(context).exito, S.of(context).passwordReseted, () {
        Navigator.of(context).pop();
        //ir al login
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      });

    } catch (error) {
      Utils.showMyOkDialog(context, S.of(context).error, S.of(context).errorChangePassword + "\n$error", () {
        Navigator.of(context).pop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          S.of(context).resetPasswordTitle,
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
                  Text(S.of(context).newPassword),
                  MyLoginTextField(
                    controller: _newPasswordController,
                    hintText: S.of(context).hintPassword,
                    isRed: _isNewPasswordRed,
                  ),
                  Text(S.of(context).confirmNewPassword),
                  MyLoginTextField(
                    controller: _confirmPasswordController,
                    hintText: S.of(context).hintPassword,
                    isRed: _isConfirmPasswordRed,
                  ),
                  const SizedBox(height: 16.0),
                  MyButton(
                    adaptableWidth: false,
                    onTap: _resetPassword,
                    text: S.of(context).resetPasswordButton,
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
