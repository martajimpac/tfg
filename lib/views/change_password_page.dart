import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../components/buttons/my_button.dart';
import '../components/textField/my_login_textfield.dart';
import '../generated/l10n.dart';
import '../utils/Utils.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  late TextEditingController _currentPasswordController;
  late TextEditingController _newPasswordController;
  late TextEditingController _confirmPasswordController;
  final supabase = Supabase.instance.client;
  bool _isCurrentPasswordRed = false;
  bool _isNewPasswordRed = false;
  bool _isConfirmPasswordRed = false;
  final FocusNode _campoPasswordFocus = FocusNode();
  final FocusNode _campoRepeatPasswordFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _currentPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _campoPasswordFocus.dispose();
    _campoRepeatPasswordFocus.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    final currentPassword = _currentPasswordController.text.trim();
    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    setState(() {
      _isCurrentPasswordRed = currentPassword.isEmpty;
      _isNewPasswordRed = newPassword.isEmpty;
      _isConfirmPasswordRed = confirmPassword.isEmpty;
    });

    if (currentPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      Fluttertoast.showToast(
        msg: S.of(context).errorEmpty,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
      );

      return;
    }

    if (newPassword != confirmPassword) {
      Utils.showMyOkDialog(context, S.of(context).error, S.of(context).errorChangePasswordNoMatch, () {
        Navigator.of(context).pop();
      });
      setState(() {
        _isCurrentPasswordRed = false;
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
        _isCurrentPasswordRed = false;
        _isNewPasswordRed = true;
        _isConfirmPasswordRed = true;
      });
      return;
    }

    try {
      // Autenticar al usuario con la contraseña actual
      await supabase.auth.signInWithPassword(
        email: supabase.auth.currentUser!.email!,
        password: currentPassword,
      );
      setState(() {
        _isConfirmPasswordRed = false;
      });


    } catch (error) {
      Utils.showMyOkDialog(context, S.of(context).error, S.of(context).errorChangePasswordIncorrect, () {
        Navigator.of(context).pop();
      });
      setState(() {
        _isCurrentPasswordRed = true;
      });
      return;
    }

    try {
      // Si la autenticación es exitosa, cambiar la contraseña
      await supabase.auth.updateUser(
        UserAttributes(password: newPassword),
      );

      Utils.showMyOkDialog(context, S.of(context).exito, S.of(context).changePasswordSuccess, () {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      });

    } on AuthException catch (error) {
      Utils.showMyOkDialog(context, S.of(context).error, S.of(context).errorChangePasswordNoChange, () {
        Navigator.of(context).pop();
      });
    } catch (error) {
      Utils.showMyOkDialog(context, S.of(context).error, S.of(context).errorChangePassword, () {
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
          S.of(context).changePasswordTitle,
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
                  Text(S.of(context).currentPassword),
                  MyLoginTextField(
                    controller: _currentPasswordController,
                    hintText: S.of(context).hintPassword,
                    isRed: _isCurrentPasswordRed,
                    onSubmited: () {
                      FocusScope.of(context).requestFocus(_campoPasswordFocus);
                    },
                  ),
                  Text(S.of(context).newPassword),
                  MyLoginTextField(
                    controller: _newPasswordController,
                    hintText: S.of(context).hintPassword,
                    isRed: _isNewPasswordRed,
                    focusNode: _campoPasswordFocus,
                    onSubmited: () {
                      FocusScope.of(context).requestFocus(_campoRepeatPasswordFocus);
                    },
                  ),
                  Text(S.of(context).confirmNewPassword),
                  MyLoginTextField(
                    controller: _confirmPasswordController,
                    hintText: S.of(context).hintPassword,
                    isRed: _isConfirmPasswordRed,
                    focusNode: _campoRepeatPasswordFocus,
                    onSubmited: _changePassword
                  ),
                  const SizedBox(height: 16.0),
                  MyButton(
                    adaptableWidth: false,
                    onTap: _changePassword,
                    text: S.of(context).changePasswordButton,
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
