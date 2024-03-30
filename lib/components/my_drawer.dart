import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modernlogintute/cubit/settings_cubit.dart';
import 'package:modernlogintute/cubit/settings_state.dart';
import 'package:modernlogintute/theme/app_theme.dart';
import 'package:modernlogintute/views/checklist_page.dart';
import 'package:modernlogintute/views/login_page.dart';
import 'package:modernlogintute/views/my_home_page.dart';
import 'package:modernlogintute/views/nueva_evaluacion_page.dart';

class MyNavigationDrawer extends StatefulWidget {
  const MyNavigationDrawer({Key? key}) : super(key: key);

  @override
  State<MyNavigationDrawer> createState() => _MyNavigationDrawerState();
}

class _MyNavigationDrawerState extends State<MyNavigationDrawer> {

  void switchChanged(bool value) {
    setState(() {
      !value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text("Tu Nombre",
                  style: TextStyle(
                    color: Theme.of(context).appBarTheme.iconTheme?.color, // Establece el color del texto a negro
                  ),
                ),
                accountEmail: const Text("tucorreo@example.com"),
                currentAccountPicture: const CircleAvatar(
                  backgroundImage: AssetImage("lib/images/default_user.png"),
                ),
                decoration: BoxDecoration(
                    color: Theme.of(context).drawerTheme.backgroundColor
                ),
              ),
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Mis evaluaciones'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const NuevaInspeccionPage()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.add),
                title: const Text('Nueva evaluación'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NuevaInspeccionPage()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Cerrar sesion'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
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
                        switchChanged(value);
                      },
                    ),
                  );
                },
              )
            ]
        )
    );
  }
}