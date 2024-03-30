import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; // Necesitas importar Cupertino para usar CupertinoSwitch
import 'package:flutter_bloc/flutter_bloc.dart'; // Necesitas importar flutter_bloc para usar BlocBuilder
import '../components/square_tile.dart';
import '../cubit/settings_cubit.dart';
import '../cubit/settings_state.dart';
import '../theme/app_theme.dart'; // Asumiendo que tienes un archivo settings_cubit.dart

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Container(
                height: h / 3,
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
              /*Image.asset(
                'lib/images/google.png',
                height: h / 3,
              ),*/
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
          const SizedBox(height: 50),
          const Column(
            children: [
              Text("name"),
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
      ),
    );
  }
}