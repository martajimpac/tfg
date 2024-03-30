import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modernlogintute/helpers/ConstantsHelper.dart';
import 'package:modernlogintute/views/checklist_page.dart';
import 'package:modernlogintute/views/mis_evaluaciones_page.dart';
import 'package:modernlogintute/views/nueva_evaluacion_page.dart';
import 'package:modernlogintute/views/profile_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = selectedIndexHome;
  }

  static final List<Widget> _widgetOptions = <Widget>[
    const MisEvaluaccionesPage(),
    const NuevaInspeccionPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {

    bool _canPop = false; // Variable para controlar el valor de canPop

    return PopScope(
      canPop: _canPop,
      onPopInvoked: (_) async {

        //TODO HACER QUE AL DAR A ACEPTAR SALGA DE LA APP
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Confirmación'),
              content: Text('¿Estás seguro de que quieres salir?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false); // Cancela la operación de retroceso
                  },
                  child: Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () {
                    _canPop = true;
                    SystemNavigator.pop(); // Confirma la operación de retroceso
                  },
                  child: Text('Aceptar'),
                ),
              ],
            );
          },
        );

      },
      child: Scaffold(
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: _selectedIndex != 1 // Si el índice seleccionado es 0, muestra el menú de navegación
            ? CurvedNavigationBar(
          backgroundColor: Theme.of(context).colorScheme.background,
          color: Theme.of(context).colorScheme.primaryContainer,
          animationDuration: const Duration(milliseconds: 300),
          items: [
            Icon(
              Icons.home,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
            Icon(
              Icons.add,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
            Icon(
              Icons.person,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ],
          onTap: _onItemTapped,
          index: _selectedIndex, // Aquí establecemos el índice seleccionado
        )
            : null, // Si no, no muestra el menú de navegación
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;

      if (index != 1) { // Verifica si el índice no es el índice del ícono de agregar
        selectedIndexHome = index;
      }
    });
  }
}

