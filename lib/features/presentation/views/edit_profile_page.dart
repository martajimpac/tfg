
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/theme/dimensions.dart';
import '../../../core/utils/Utils.dart';
import '../../../generated/l10n.dart';
import '../../data/shared_prefs.dart';
import '../components/buttons/my_button.dart';
import '../components/textField/my_login_textfield.dart';
import '../cubit/edit_profile_cubit.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _userNameController;

  final supabase = Supabase.instance.client;
  late EditProfileCubit _cubit;

  @override
  void initState() {
    super.initState();
    _userNameController = TextEditingController();
    _cubit = BlocProvider.of<EditProfileCubit>(context);
    _cubit.loadUserData();
  }

  @override
  void dispose() {
    _userNameController.dispose();
    super.dispose();
  }

  Future<void> _updateUser(BuildContext context) async {
    final userName = _userNameController.text.trim();
    _cubit.editProfile(userName, context);
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.onSurface, semanticLabel: S.of(context).semanticlabelBack),
          onPressed: () {
            //FocusScope.of(context).unfocus();
            Navigator.of(context).pop();
          },
        ),
      ),
      body: BlocConsumer<EditProfileCubit, EditProfileState>(
        listener: (context, state) async {
          if (state is EditProfileSuccess) {
            await SharedPrefs.updateUserName(state.newUserName);

            // Datos del usuario modificados con éxito
            Utils.showMyOkDialog(
              context,
              S.of(context).exito,
              S.of(context).successUpdatingUser,
                  () {
                Navigator.of(context).pop(); // Navega hacia atrás
                Navigator.of(context).pop(); // Navega hacia atrás
              },
            );
          } else if (state is EditProfileError) {
            final errorMessage = state.errorMessage;

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
                state.errorMessage,
                    () {
                  Navigator.of(context).pop();
                },
              );
            }
          }

        },
        builder: (context, state) {
          final isUserNameRed = state is EditProfileError ? state.isNameRed : false;
          final userName = state is EditProfileLoaded ? state.userName : "";
          _userNameController.text = userName;

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
