import 'package:evaluacionmaquinas/features/presentation/views/offline_page.dart';
import 'package:evaluacionmaquinas/features/presentation/views/register_page.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/theme/dimensions.dart';
import '../../../core/utils/Utils.dart';
import '../../../generated/l10n.dart';
import '../components/buttons/my_button.dart';
import '../components/dialog/my_two_buttons_dialog.dart';
import '../components/textField/my_login_textfield.dart';
import '../cubit/login_cubit.dart';
import 'forgot_password_page.dart';
import 'my_home_page.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  final FocusNode _passwordFocusNode = FocusNode();
  final supabase = Supabase.instance.client;
  String previousError = "";

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
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {},
      child: SafeArea(
        child: Scaffold(
          extendBodyBehindAppBar:
              false, // Esto permite que el contenido se dibuje detrás del AppBar
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Center(
              child: Text(
                S.of(context).loginTitle,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
              ),
            ),
            elevation: 0, // Eliminar sombra del AppBar
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          ),
          body: BlocConsumer<LoginCubit, LoginState>(
            listener: (context, state) {
              if (state is LoginSuccess) {
                _goToHomePage();
              } else if (state is LoginError) {
                final errorMessage = state.message;

                if (errorMessage == S.of(context).errorEmpty) {
                  Utils.showAdaptiveToast(
                      context: context,
                      message: errorMessage,
                      gravity: ToastGravity.BOTTOM);
                } else if (errorMessage ==
                    S.of(context).errorAuthenticationNotConfirmed) {
                  final email = _emailController.text.trim();
                  final password = _passwordController.text.trim();
                  _showErrorDialogWithResendOption(
                      errorMessage, email, password);
                } else {
                  _showErrorDialog(errorMessage);
                }
              } else if (state is ConfirmationEmailSent) {
                Utils.showMyOkDialog(
                  context,
                  S.of(context).emailResent,
                  S.of(context).emailResentDesc,
                  () {
                    Navigator.of(context).pop();
                  },
                );
              } else {}
            },
            builder: (context, state) {
              final isEmailRed = state is LoginError ? state.isEmailRed : false;
              final isPasswordRed =
                  state is LoginError ? state.isPasswordRed : false;

              return Stack(
                children: [
                  // Imagen de fondo que ocupa toda la pantalla
                  Positioned.fill(
                    child: Image.asset(
                      'assets/images/bg_login.png', // Asegúrate de que la imagen esté en esta ruta
                      fit: BoxFit
                          .cover, // Esto asegura que la imagen cubra toda la pantalla
                      semanticLabel: "",
                    ),
                  ),
                  // Contenido de la página
                  SafeArea(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(Dimensions.marginMedium),
                        child: Container(
                          padding:
                              const EdgeInsets.all(Dimensions.marginMedium),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.onPrimary,
                            borderRadius:
                                BorderRadius.circular(Dimensions.cornerRadius),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize
                                .min, // Esto asegura que el contenedor tenga solo la altura necesaria
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(S.of(context).email),
                              MyLoginTextField(
                                controller: _emailController,
                                hintText: S.of(context).hintEmail,
                                isRed: isEmailRed,
                                onSubmited: () {
                                  FocusScope.of(context)
                                      .requestFocus(_passwordFocusNode);
                                },
                              ),
                              const SizedBox(height: Dimensions.marginMedium),
                              Text(S.of(context).password),
                              MyLoginTextField(
                                controller: _passwordController,
                                hintText: S.of(context).hintPassword,
                                obscureText: true,
                                isRed: isPasswordRed,
                                focusNode: _passwordFocusNode,
                                onSubmited: () {
                                  if (state is! LoginLoading) {
                                    login();
                                  }
                                },
                              ),
                              TextButton(
                                onPressed: () async {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const ForgotPasswordPage()),
                                  );
                                },
                                child: Text(
                                  S.of(context).forgetPassword,
                                  style: TextStyle(
                                      fontSize: Dimensions.smallTextSize,
                                      decoration: TextDecoration.underline,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSecondaryContainer),
                                ),
                              ),
                              const SizedBox(height: Dimensions.marginMedium),
                              state is LoginLoading
                                  ? const Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : MyButton(
                                      adaptableWidth: false,
                                      onTap: () async {
                                        // Evitar clics múltiples si ya está cargando
                                        if (state is! LoginLoading) {
                                          login();
                                        }
                                      },
                                      text: S.of(context).loginButton,
                                    ),
                              const SizedBox(height: Dimensions.marginMedium),
                              MyButton(
                                adaptableWidth: false,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const RegisterPage()),
                                  );
                                },
                                color: Theme.of(context).colorScheme.primary,
                                text: S.of(context).registerButton,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        )
      )
    );
  }

  void _goToHomePage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MyHomePage()),
    );
  }

  void _showErrorDialogWithResendOption(
      String message, String email, String password) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MyTwoButtonsDialog(
          title: S.of(context).error,
          desc: message,
          primaryButtonText: S.of(context).resentEmail,
          onPrimaryButtonTap: () {
            Navigator.of(context).pop();
            context
                .read<LoginCubit>()
                .resendConfirmationEmail(email, password, context);
          },
          secondaryButtonText: S.of(context).close,
          onSecondaryButtonTap: () {
            Navigator.of(context).pop();
          },
          isVertical: true,
        );
      },
    );
  }

  Future<void> _showErrorDialog(String message) async {
    if (await Utils.hayConexion()) {
      Utils.showMyOkDialog(context, S.of(context).error, message, () {
        Navigator.of(context).pop();
      });
    } else {
      showNoConnectionDialog(context);
    }
  }

  void login() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    context.read<LoginCubit>().login(email, password, context);
  }

  void showNoConnectionDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return MyTwoButtonsDialog(
            title: S.of(context).error,
            desc: S.of(context).noInternetConexion,
            primaryButtonText: S.of(context).continuee,
            secondaryButtonText: S.of(context).retryTitle,
            onPrimaryButtonTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const OfflinePage()));
            },
            onSecondaryButtonTap: () {
              Navigator.of(context).pop();
              login();
            },
          );
        });
  }
}
