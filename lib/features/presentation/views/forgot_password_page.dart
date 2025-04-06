import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/theme/dimensions.dart';
import '../../../core/utils/Utils.dart';
import '../../../generated/l10n.dart';
import '../components/buttons/my_button.dart';
import '../components/textField/my_login_textfield.dart';
import '../cubit/change_password_cubit.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  late TextEditingController _emailController;
  final supabase = Supabase.instance.client;
  late ChangePasswordCubit _cubit;
  @override
  void initState() {
    super.initState();
    _cubit = BlocProvider.of<ChangePasswordCubit>(context);
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }


  Future<void> _sendEmail() async {
    final email = _emailController.text.trim();
    _cubit.sendResetPasswordEmail(email, context);
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
      body: BlocConsumer<ChangePasswordCubit, ChangePasswordState>(
        listener: (context, state) {

          if (state is SendPasswordResetEmailSuccess) {
            // Correo enviado con éxito
            Utils.showMyOkDialog(
              context,
              S.of(context).emailSent,
              S.of(context).emailSentDesc,
                  () {
                Navigator.of(context).pop();
              },
            );
          } else if (state is SendPasswordResetEmailError) {
            final errorMessage = state.message;

            if (errorMessage == S.of(context).errorEmpty) {
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
          final isEmailRed = state is SendPasswordResetEmailError ? state.isEmailRed : false;

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
                        isRed: isEmailRed,
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
          );
        },
      ),
    );
  }
}
