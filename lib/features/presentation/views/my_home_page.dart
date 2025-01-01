import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:evaluacionmaquinas/features/presentation/views/profile_page.dart';
import 'package:flutter/material.dart';
import '../../../core/utils/Constants.dart';
import '../../../generated/l10n.dart';
import 'mis_evaluaciones_page.dart';
import 'nueva_evaluacion_page.dart';

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
    const NuevaEvaluacionPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: _selectedIndex != 1 // Si el índice seleccionado es 0, muestra el menú de navegación
          ? CurvedNavigationBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        color: Theme.of(context).colorScheme.primaryContainer,
        animationDuration: const Duration(milliseconds: 300),
        items: [
          Icon(
            Icons.home,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
            semanticLabel: S.of(context).semanticlabelHomepage
          ),
          Icon(
            Icons.add,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
            semanticLabel: S.of(context).semanticlabelNewEvaluation
          ),
          Icon(
            Icons.person,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
            semanticLabel: S.of(context).semanticlabelProfile
          ),
        ],
        onTap: _onItemTapped,
        index: _selectedIndex, // Aquí establecemos el índice seleccionado
      )
          : null, // Si no, no muestra el menú de navegación
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

