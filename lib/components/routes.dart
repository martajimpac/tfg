import 'package:flutter/material.dart';
import 'package:modernlogintute/views/mis_evaluaciones_page.dart';
import 'package:modernlogintute/views/nueva_evaluacion_page.dart';
import 'package:modernlogintute/views/profile_page.dart';

class Routes extends StatelessWidget {
  final int index;

  const Routes({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> myList = [
      MisEvaluaccionesPage(),
      const NuevaInspeccionPage(),
      ProfilePage(),
    ];
    return myList[index];
  }
}

