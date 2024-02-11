import 'package:flutter/material.dart';
import '../components/my_button.dart';
import '../components/my_navigation_drawer.dart';

class InspeccionesPage extends StatelessWidget {
  const InspeccionesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: const MyNavigationDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text("Mis evaluaciones"),
            Expanded(
              child: ListView.builder(
                itemCount: 3,
                itemBuilder: (BuildContext context, int index) {
                  // Aquí puedes generar datos inventados para cada tarjeta
                  String maquina = "Máquina ${index + 1}";
                  String fechaInspeccion = "Fecha de creación: 2024-02-11";
                  String fechaCaducidad = "Fecha de caducidad: 2024-12-31";

                  return Card(
                    margin: const EdgeInsets.all(10),
                    child: ListTile(
                      title: Text(maquina),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(fechaInspeccion),
                          Text(fechaCaducidad),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}