import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/dimensions.dart';
import '../../../core/utils/Utils.dart';
import '../../data/shared_prefs.dart';
import '../../../generated/l10n.dart';
import '../components/buttons/my_button_card.dart';
import '../components/dialog/my_two_buttons_dialog.dart';
import '../cubit/evaluaciones_cubit.dart';
import '../cubit/settings_cubit.dart';
import 'change_password_page.dart';
import 'edit_profile_page.dart';
import 'login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late EvaluacionesCubit _cubitEvaluaciones;

  @override
  void initState() {
    super.initState();
    _cubitEvaluaciones = BlocProvider.of<EvaluacionesCubit>(context);
  }

  Future<void> _signOutUser() async {
    try {
      await SharedPrefs.deleteUserData();
      await Supabase.instance.client.auth.signOut();

      if (!mounted) return; // Verifica si el widget sigue montado

      Utils.showAdaptiveToast(
          context: context, message: S.of(context).sessionClosedSuccess);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } catch (error) {
      if (!mounted) return; // Verifica nuevamente si el widget sigue montado

      Utils.showAdaptiveToast(
          context: context, message: S.of(context).sessionCloseError);
    }
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: FutureBuilder<String>(
        future: SharedPrefs.getUserName(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              final userName = snapshot.data ?? S.of(context).unknownName;
              return Column(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        height: h / 4,
                        child: Image.asset(
                          'assets/images/bg_profile.png',
                          fit: BoxFit.fitHeight,
                          semanticLabel:
                              S.of(context).semanticlabelProfilePicture,
                        ),
                      ),
                      Positioned(
                        bottom: -40,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor:
                              Theme.of(context).colorScheme.onPrimary,
                          backgroundImage: const AssetImage(
                              'assets/images/default_user.png'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                  Text(
                    userName,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primaryContainer,
                    ),
                  ),
                  BlocBuilder<EvaluacionesCubit, EvaluacionesState>(
                    builder: (context, state) {
                      final numEval = _cubitEvaluaciones.evaluaciones.length;

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(S.of(context).numEvaluations),
                          const SizedBox(width: Dimensions.marginSmall),
                          Text(
                            "$numEval",
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      );
                    },
                  ),
                  MyButtonCard(
                    onTap: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ChangePasswordPage()),
                      );
                    },
                    text: S.of(context).changePasswordButton,
                    icon: Icon(Icons.lock,
                        color: Colors.white,
                        semanticLabel:
                            S.of(context).semanticlabelChangePassword),
                  ),
                  MyButtonCard(
                    onTap: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const EditProfilePage()),
                      ).then((_) {
                        // Volver a cargar el nombre de usuario
                        setState(() {});
                      });
                    },
                    text: S.of(context).editProfile,
                    icon: Icon(Icons.person_outline,
                        color: Colors.white,
                        semanticLabel: S.of(context).editProfile),
                  ),
                  MyButtonCard(
                    onTap: () async {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return MyTwoButtonsDialog(
                            title: S.of(context).logout,
                            desc: S.of(context).logoutConfirmation,
                            primaryButtonText: S.of(context).close,
                            secondaryButtonText: S.of(context).cancel,
                            onPrimaryButtonTap: () async {
                              Navigator.of(context).pop();
                              await _signOutUser();
                            },
                            onSecondaryButtonTap: () {
                              Navigator.of(context).pop();
                            },
                          );
                        },
                      );
                    },
                    text: S.of(context).logout,
                    icon: Icon(Icons.logout,
                        color: Colors.white,
                        semanticLabel: S.of(context).semanticlabelLogout),
                    iconContainerColor: Colors.red,
                  ),
                  const SizedBox(height: Dimensions.marginBig),
                  BlocBuilder<SettingsCubit, SettingsState>(
                    builder: (context, state) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(S.of(context).darkMode,
                              style: Theme.of(context).textTheme.bodyMedium),
                          const SizedBox(width: Dimensions.marginSmall),
                          CupertinoSwitch(
                            activeTrackColor: Colors.grey.shade400,
                            value: state.theme == MyAppTheme.darkTheme,
                            onChanged: (value) {
                              context.read<SettingsCubit>().toggleTheme();
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ],
              );
            }
          }
        },
      ),
    );
  }
}
