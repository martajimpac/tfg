import 'package:flutter/material.dart';
import 'package:modernlogintute/views/cuestionario.dart';
import 'package:modernlogintute/views/my_home_page.dart';

class MyNavigationDrawer extends StatelessWidget {
  const MyNavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Mi Aplicación',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            title: const Text('Página Principal'),
            onTap: () {
              Navigator.pop(context); // Cerrar el drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MyHomePage(title: "hola")),
              );
            },
          ),
          ListTile(
            title: const Text('Segunda Página'),
            onTap: () {
              Navigator.pop(context); // Cerrar el drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Cuestionario()),
              );
            },
          ),
        ],
      ),
    );
  }
}