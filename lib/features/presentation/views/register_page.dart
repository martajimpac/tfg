
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/theme/dimensions.dart';
import '../../../core/utils/Utils.dart';
import '../../../generated/l10n.dart';
import '../components/buttons/my_button.dart';
import '../components/textField/my_login_textfield.dart';
import '../cubit/register_cubit.dart';
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
      extendBodyBehindAppBar: false,  // Esto permite que el contenido se dibuje detrás del AppBar
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          S.of(context).registerTitle,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white, semanticLabel: S.of(context).semanticlabelBack),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        elevation: 0,  // Eliminar sombra del AppBar
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: BlocConsumer<RegisterCubit, RegisterState>(
        listener: (context, state) {
          switch (state.runtimeType) {
            case RegisterSuccess:

              // Autenticación exitosa, navega a la siguiente página
              Utils.showMyOkDialog(context, S.of(context).registerSuccessTitle, S.of(context).registerSuccessDesc, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              });
              break;

            case RegisterError:

              if (state is RegisterError) {
                final errorMessage = state.message;
                if (errorMessage == S.of(context).errorEmpty || errorMessage == S.of(context).errorPasswordsDontMatch) {
                  Fluttertoast.showToast(
                    msg: errorMessage,
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.grey,
                    textColor: Colors.white,
                  );
                } else {
                  Utils.showMyOkDialog(context, S.of(context).error, (state as RegisterError).message, () {
                    Navigator.of(context).pop();
                  });
                }
              }
              break;

            default: break;
          }
        },
        builder: (context, state) {
          final isEmailRed = state is RegisterError ? state.isEmailRed : false;
          final isPasswordRed = state is RegisterError ? state.isPasswordRed : false;
          final isRepeatPasswordRed = state is RegisterError ? state.isRepeatPasswordRed : false;

          return SingleChildScrollView(
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
                        const SizedBox(height: Dimensions.marginMedium),
                        Text(S.of(context).email),
                        MyLoginTextField(
                          controller: _emailController,
                          hintText: S.of(context).hintEmail,
                          isRed: isEmailRed,
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
                          isRed: isPasswordRed,
                          focusNode: _campoPasswordFocus,
                          onSubmited: () {
                            FocusScope.of(context).requestFocus(_campoRepeatPasswordFocus);
                          },
                        ),
                        const SizedBox(height: Dimensions.marginMedium),
                        Text(S.of(context).repeatPassword),
                        MyLoginTextField(
                          controller: _repeatPasswordController,
                          hintText: S.of(context).hintPassword,
                          obscureText: true,
                          focusNode: _campoRepeatPasswordFocus,
                          isRed: isRepeatPasswordRed,
                          onSubmited: () {
                            _register(context);
                          },
                        ),
                        const SizedBox(height: Dimensions.marginMedium),
                        state is RegisterLoading
                            ? const Center(
                          child: CircularProgressIndicator(),
                        )
                        : MyButton(
                          adaptableWidth: false,
                          onTap: () async {
                            _register(context);
                          },
                          text:S.of(context).registerAndLoginButton,
                        ),
                      ],
                    ),
                  )
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _register(BuildContext context) async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final repeatPassword = _repeatPasswordController.text.trim();
    final name = _nameController.text.trim();

    context.read<RegisterCubit>().register(name, email, password, repeatPassword, context);

    return;
  }


}
