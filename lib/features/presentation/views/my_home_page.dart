import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:evaluacionmaquinas/features/presentation/views/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../core/utils/Constants.dart';
import '../../../generated/l10n.dart';
import 'mis_evaluaciones_page.dart';
import 'nueva_evaluacion_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late int _selectedIndex;
  DateTime? _lastPressedAt; // Última vez que se pulsó el botón de retroceso

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
    return WillPopScope(
      onWillPop: () async {
        final now = DateTime.now();
        const exitThreshold = Duration(seconds: 2);

        // Comprueba si se ha pulsado recientemente el botón
        if (_lastPressedAt == null || now.difference(_lastPressedAt!) > exitThreshold) {
          _lastPressedAt = now;

          // Muestra el Toast
          Fluttertoast.showToast(
            msg: S.of(context).pressAgainToExit,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
          );

          return false; // Evita cerrar la aplicación
        }
        SystemNavigator.pop();
        return true; // Cierra la aplicación
      },
      child: Scaffold(
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: _selectedIndex != 1
            ? CurvedNavigationBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          color: Theme.of(context).colorScheme.primaryContainer,
          animationDuration: const Duration(milliseconds: 300),
          items: [
            Icon(
              Icons.home,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              semanticLabel: S.of(context).semanticlabelHomepage,
            ),
            Icon(
              Icons.add,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              semanticLabel: S.of(context).semanticlabelNewEvaluation,
            ),
            Icon(
              Icons.person,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              semanticLabel: S.of(context).semanticlabelProfile,
            ),
          ],
          onTap: _onItemTapped,
          index: _selectedIndex,
        )
            : null,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;

      if (index != 1) {  // Verifica si el índice no es el índice del ícono de agregar
        selectedIndexHome = index;
      }
    });
  }
}
