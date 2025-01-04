import 'dart:math';

import 'package:evaluacionmaquinas/features/presentation/cubit/eliminar_evaluacion_cubit.dart';
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
import '../cubit/edit_profile_cubit.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  late TextEditingController _userNameController;

  final supabase = Supabase.instance.client;


  @override
  void initState() {
    super.initState();
    _userNameController = TextEditingController();
  }

  @override
  void dispose() {
    _userNameController.dispose();


    super.dispose();
  }

  Future<void> _updateUser(BuildContext context) async {
    final userName = _userNameController.text.trim();
    context.read<EditProfileCubit>().editProfile(userName, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          S.of(context).editProfile,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      body: BlocConsumer<EditProfileCubit, EditProfileState>(
        listener: (context, state) {
          switch (state.runtimeType) {
            case EditProfileSuccess:

              //Datos del usuario modificados con éxito
              Utils.showMyOkDialog(context, S.of(context).exito, S.of(context).successUpdatingUser, () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              });
              break;

            case EditProfileError:

              if (state is EditProfileError) {
                final errorMessage = state.errorMessage;
                if (errorMessage == S.of(context).errorEmpty) {
                  Fluttertoast.showToast(
                    msg: errorMessage,
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.grey,
                    textColor: Colors.white,
                  );
                } else {
                  Utils.showMyOkDialog(context, S.of(context).error, state.errorMessage, () {
                    Navigator.of(context).pop();
                  });
                }
              }
              break;

            default: break;
          }
        },
        builder: (context, state) {
          final isUserNameRed = state is EditProfileError ? state.isNameRed : false;

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
                      Text(S.of(context).name),
                      MyLoginTextField(
                        controller: _userNameController,
                        hintText: S.of(context).hintName,
                        isRed: isUserNameRed,
                        onSubmited: () {
                          _updateUser(context);
                        },
                      ),
                      SizedBox(height: Dimensions.marginMedium),
                      MyButton(
                        adaptableWidth: false,
                        onTap: () {
                          _updateUser(context);
                        },
                        text: S.of(context).modify,
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
