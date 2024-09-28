import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; // Necesitas importar Cupertino para usar CupertinoSwitch
import 'package:flutter_bloc/flutter_bloc.dart'; // Necesitas importar flutter_bloc para usar BlocBuilder
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../components/buttons/my_button_card.dart';
import '../cubit/evaluaciones_cubit.dart';
import '../cubit/settings_cubit.dart';
import '../generated/l10n.dart';
import '../repository/repositorio_db_supabase.dart';
import '../theme/app_theme.dart';
import '../theme/dimensions.dart';
import '../views/change_password_page.dart';
import '../views/forgot_password_page.dart';
import '../views/login_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {},
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: FutureBuilder<String>(
          future: _getUserName(), // Obtener el nombre del usuario de SharedPreferences
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(); // Muestra un indicador de progreso mientras se carga el nombre
            } else {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}'); // Manejar errores si los hay
              } else {
                final userName = snapshot.data ?? S.of(context).unknownName; // Obtener el nombre del usuario del snapshot
                return Column(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: [
                        Container(
                          height: h / 4,
                          color: Theme.of(context).colorScheme.primaryContainer,
                        ),
                        Positioned(
                          bottom: -40,
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: Theme.of(context).colorScheme.onBackground,
                            backgroundImage: const AssetImage('lib/images/default_user.png'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 50),
                    Column(
                      children: [
                        Text(
                          userName,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primaryContainer,
                          ),
                        ), // Mostrar el nombre del usuario aquí
                      ],
                    ),
                    BlocBuilder<EvaluacionesCubit, EvaluacionesState>(
                      builder: (context, state) {
                        if (state is EvaluacionesLoaded) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(S.of(context).numEvaluations),
                              const SizedBox(width: Dimensions.marginSmall),
                              Text(
                                "${state.evaluaciones.length}",
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ],
                          );
                        } else {
                          return const SizedBox(height: Dimensions.marginMedium);
                        }
                      },
                    ),
                    MyButtonCard(
                      onTap: () async {
                        try {
                          await Supabase.instance.client.auth.signOut();
                          Fluttertoast.showToast(
                            msg: S.of(context).sessionClosedSuccess,
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            backgroundColor: Colors.grey,
                            textColor: Colors.white,
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const LoginPage()),
                          );
                        } catch (error) {
                          Fluttertoast.showToast(
                            msg: S.of(context).sessionCloseError,
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            backgroundColor: Colors.grey,
                            textColor: Colors.white,
                          );
                        }
                      },
                      text: S.of(context).logout,
                      icon: const Icon(Icons.logout, color: Colors.white),
                    ),
                    MyButtonCard(
                      onTap: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ChangePasswordPage()),
                        );
                      },
                      text: S.of(context).changePasswordButton,
                      icon: const Icon(Icons.lock, color: Colors.white),
                    ),
                    BlocBuilder<SettingsCubit, SettingsState>(
                      builder: (context, state) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(S.of(context).darkMode, style: Theme.of(context).textTheme.bodyMedium),
                            const SizedBox(width: Dimensions.marginSmall),
                            CupertinoSwitch(
                              activeColor: Colors.grey.shade400,
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
      ),
    );
  }

  Future<String> _getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('name') ?? ''; // Obtener el nombre del usuario guardado, o un valor predeterminado si no existe
  }
}
