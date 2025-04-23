
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/utils/Utils.dart';
import '../../../generated/l10n.dart';
import '../components/buttons/my_button.dart';
import '../components/textField/my_login_textfield.dart';
import '../cubit/change_password_cubit.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  late TextEditingController _currentPasswordController;
  late TextEditingController _newPasswordController;
  late TextEditingController _confirmPasswordController;
  final supabase = Supabase.instance.client;
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

  Future<void> _changePassword(BuildContext context) async {
    final currentPassword = _currentPasswordController.text.trim();
    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();
    context.read<ChangePasswordCubit>().changePassword(currentPassword, newPassword, confirmPassword, context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child:
        Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              S.of(context).changePasswordTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          body: BlocConsumer<ChangePasswordCubit, ChangePasswordState>(
            listener: (context, state) {
              if (state is ChangePasswordSuccess) {
                // Contraseña cambiada con éxito
                Utils.showMyOkDialog(
                  context,
                  S.of(context).exito,
                  S.of(context).changePasswordSuccess,
                      () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
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
              final isCurrentPasswordRed = state is ChangePasswordError ? state.isCurrentPasswordRed : false;
              final isPasswordRed = state is ChangePasswordError ? state.isNewPasswordRed : false;
              final isRepeatPasswordRed = state is ChangePasswordError ? state.isConfirmPasswordRed : false;

              // Mantener los valores actuales si el estado contiene las contraseñas
              _currentPasswordController.text = state is ChangePasswordError ? state.currentPassword : _currentPasswordController.text;
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
                          Text(S.of(context).currentPassword),
                          MyLoginTextField(
                            controller: _currentPasswordController,
                            hintText: S.of(context).hintPassword,
                            isRed: isCurrentPasswordRed,
                            onSubmited: () {
                              FocusScope.of(context).requestFocus(_campoPasswordFocus);
                            },
                            obscureText: true,
                          ),
                          Text(S.of(context).newPassword),
                          MyLoginTextField(
                            controller: _newPasswordController,
                            hintText: S.of(context).hintPassword,
                            isRed: isPasswordRed,
                            focusNode: _campoPasswordFocus,
                            onSubmited: () {
                              FocusScope.of(context).requestFocus(_campoRepeatPasswordFocus);
                            },
                            obscureText: true,
                          ),
                          Text(S.of(context).confirmNewPassword),
                          MyLoginTextField(
                            controller: _confirmPasswordController,
                            hintText: S.of(context).hintPassword,
                            isRed: isRepeatPasswordRed,
                            focusNode: _campoRepeatPasswordFocus,
                            onSubmited: () {
                              _changePassword(context);
                            },
                            obscureText: true,
                          ),
                          const SizedBox(height: 16.0),
                          MyButton(
                            adaptableWidth: false,
                            onTap: () {
                              _changePassword(context);
                            },
                            text: S.of(context).changePasswordButton,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        )
    );
  }
}
