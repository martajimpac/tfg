import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; // Necesitas importar Cupertino para usar CupertinoSwitch
import 'package:flutter_bloc/flutter_bloc.dart'; // Necesitas importar flutter_bloc para usar BlocBuilder
import 'package:shared_preferences/shared_preferences.dart';
import '../cubit/settings_cubit.dart';
import '../theme/app_theme.dart'; // Asumiendo que tienes un archivo settings_cubit.dart

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    return PopScope(
        canPop: false,
        onPopInvoked: (bool didPop){

      }, child:
      Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: FutureBuilder<String>(
          future: _getUserName(), // Obtener el nombre del usuario de SharedPreferences
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator(); // Muestra un indicador de progreso mientras se carga el nombre
            } else {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}'); // Manejar errores si los hay
              } else {
                final userName = snapshot.data ?? 'Nombre predeterminado'; // Obtener el nombre del usuario del snapshot
                return Column(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: [
                        Container(
                          height: h / 3,
                          color: Theme.of(context).colorScheme.primaryContainer,
                        ),
                        Positioned(
                          bottom: -40,
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: Theme.of(context).colorScheme.onBackground,
                            backgroundImage: const AssetImage('lib/images/default_user.png'),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 50),
                    Column(
                      children: [
                        Text(userName), // Mostrar el nombre del usuario aquí
                      ],
                    ),
                    BlocBuilder<SettingsCubit, SettingsState>(
                      builder: (context, state) {
                        return ListTile(
                          title: const Text('Modo oscuro'),
                          trailing: CupertinoSwitch(
                            activeColor: Colors.grey.shade400,
                            value: state.theme == MyAppTheme.darkTheme, // Corrección aquí
                            onChanged: (value) {
                              context.read<SettingsCubit>().toggleTheme();
                              // switchChanged(value); // No está definido switchChanged, ¿es necesario aquí?
                            },
                          ),
                        );
                      },
                    )
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
