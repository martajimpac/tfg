
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/utils/Utils.dart';
import '../../../generated/l10n.dart';
import '../components/buttons/my_button.dart';
import '../components/textField/my_login_textfield.dart';
import '../cubit/change_password_cubit.dart';
import 'login_page.dart';

/// PÁGINA PARA RESETEAR LA CONTRASEÑA
///  Solo se puede acceder aqui mediante un deeplink
class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  late TextEditingController _newPasswordController;
  late TextEditingController _confirmPasswordController;
  final supabase = Supabase.instance.client;
  final FocusNode _campoRepeatPasswordFocus = FocusNode();
  late ChangePasswordCubit _cubit;

  @override
  void initState() {
    super.initState();
    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _cubit = BlocProvider.of<ChangePasswordCubit>(context);
  }

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _campoRepeatPasswordFocus.dispose();
    super.dispose();
  }

  Future<void> _resetPassword(context) async {

    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    _cubit.resetPassword(newPassword, confirmPassword, context);
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
      body: BlocConsumer<ChangePasswordCubit, ChangePasswordState>(
        listener: (context, state) {
          if (state is ChangePasswordSuccess) {
            // Si el restablecimiento es exitoso
            Utils.showMyOkDialog(
              context,
              S.of(context).exito,
              S.of(context).passwordReseted,
                  () {
                Navigator.of(context).pop();
                // Ir al login
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
            );
          } else if (state is ChangePasswordError) {
            final errorMessage = state.message;

            if (errorMessage == S.of(context).errorEmpty ||
                errorMessage == S.of(context).errorPasswordsDontMatch) {
              Utils.showAdaptiveToast(
                  context: context,
                  message: errorMessage,
                  gravity: ToastGravity.BOTTOM
              );
            } else {
              Utils.showMyOkDialog(
                context,
                S.of(context).error,
                state.message,
                    () {
                  Navigator.of(context).pop();
                },
              );
            }
          }

        },
        builder: (context, state) {
          final isNewPasswordRed = state is ChangePasswordError ? state.isNewPasswordRed : false;
          final isConfirmPasswordRed = state is ChangePasswordError ? state.isConfirmPasswordRed : false;

          // Mantener los valores actuales si el estado contiene las contraseñas
          _newPasswordController.text = state is ChangePasswordError ? state.newPassword : _newPasswordController.text;
          _confirmPasswordController.text = state is ChangePasswordError ? state.repeatPassword : _confirmPasswordController.text;

          return SingleChildScrollView(
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
                      Text(S.of(context).newPassword),
                      MyLoginTextField(
                        controller: _newPasswordController,
                        hintText: S.of(context).hintPassword,
                        isRed: isNewPasswordRed,
                        onSubmited: () {
                          FocusScope.of(context).requestFocus(_campoRepeatPasswordFocus);
                        },
                        obscureText: true,
                      ),
                      Text(S.of(context).confirmNewPassword),
                      MyLoginTextField(
                        controller: _confirmPasswordController,
                        hintText: S.of(context).hintPassword,
                        isRed: isConfirmPasswordRed,
                        focusNode: _campoRepeatPasswordFocus,
                        onSubmited: () {
                          _resetPassword(context);
                        },
                        obscureText: true,
                      ),
                      const SizedBox(height: 16.0),
                      MyButton(
                        adaptableWidth: false,
                        onTap: () {
                          _resetPassword(context);
                        },
                        text: S.of(context).resetPasswordButton,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
