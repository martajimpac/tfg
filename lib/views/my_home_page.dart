import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modernlogintute/cubit/counter_cubit.dart';
import 'package:modernlogintute/theme/dimensions.dart';
import 'package:modernlogintute/views/checklist_page.dart';
import 'package:modernlogintute/views/nueva_inspeccion_page.dart';

import '../components/my_button.dart';
import '../components/my_navigation_drawer.dart';
import 'evaluaciones_page.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: const MyNavigationDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              "Bienvenido!, ¿Qué desea hacer?",
              style: TextStyle(
                fontSize: 24,
              ),
            ),
            MyButton(
              adaptableWidth: false,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const InspeccionesPage(),
                  ),
                );
              },
              text: "Ver mis evaluaciones"
            ),
            const SizedBox(height: Dimensions.marginMedium),
            MyButton(
                adaptableWidth: false,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NuevaInspeccionPage(),
                    ),
                  );
                },
                text: "Crear nueva evaluación"
            ),
          ],
        ),
      ),
    );
  }
}
