import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:modernlogintute/theme/dimensions.dart';
import 'package:modernlogintute/views/checklist_page.dart';
import 'package:modernlogintute/views/filtros_page.dart';

import '../components/my_button.dart';
import 'detalle_evaluacion_page.dart';

import 'package:flutter/material.dart';
import 'detalle_evaluacion_page.dart';

class MisEvaluaccionesPage extends StatefulWidget {
  const MisEvaluaccionesPage({Key? key}) : super(key: key);

  @override
  _MisEvaluaccionesPageState createState() => _MisEvaluaccionesPageState();
}

class _MisEvaluaccionesPageState extends State<MisEvaluaccionesPage> {
  List<String> filterList = ["Filtro 1", "Filtro 2", "Filtro 3", "Filtro 4", "Filtro 5", "Filtro 6", "Filtro 4", "Filtro 5", "Filtro 6", "Filtro 4", "Filtro 5", "Filtro 6"];


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar:  AppBar(
          title: Text(
            'Mis evaluaciones',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          automaticallyImplyLeading: false, // Elimina la flecha de retroceso
          leading: null, // Sin botón en el lado izquierdo
          actions: null, // Sin botones en el lado derecho
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0), // Margen horizontal entre los botones
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.primaryContainer, // Color de fondo del círculo
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.filter_alt),
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      onPressed: () {
                        //GoRouter.of(context).go('/filtros');
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const FiltrosPage()),);
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.0), // Margen horizontal entre los botones
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.primaryContainer, // Color de fondo del círculo
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.sort_by_alpha),
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      onPressed: () {
                        // Acción al presionar el botón de ordenar por orden alfabético
                      },
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 50, // Ajusta la altura según lo necesites
              child: ListView(
                scrollDirection: Axis.horizontal,
                physics: const ClampingScrollPhysics(),
                shrinkWrap: true,
                children: [
                  for (int index = 0; index < filterList.length; index++)
                    Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                          margin: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: Theme.of(context).colorScheme.primaryContainer,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                filterList[index],
                                style: Theme.of(context).textTheme.labelMedium, // Color del texto del filtro
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    filterList.removeAt(index);
                                  });
                                },
                                child: Icon(
                                  Icons.close,
                                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                                  size: 20.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 3,
                itemBuilder: (BuildContext context, int index) {
                  // Aquí puedes generar datos inventados para cada tarjeta
                  String maquina = "Máquina ${index + 1}";
                  String fechaInspeccion = "Fecha de creación: 2024-02-11";
                  String fechaCaducidad = "Fecha de caducidad: 2024-12-31";

                  return GestureDetector(
                    onTap: () {
                      // Navegar a la nueva página cuando se hace clic en la tarjeta
                      //GoRouter.of(context).go('/detalle_evaluaciones');
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const DetalleEvaluaccionPage(),),);
                    },
                    child: Card(
                      margin: const EdgeInsets.all(10),
                      elevation: 0,
                      color: Theme.of(context).colorScheme.onBackground,
                      child: ListTile(
                        title: Text(
                          maquina,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                border: Border.all(color: Colors.green),
                              ),
                              padding: const EdgeInsets.all(8.0),
                              margin: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Column(
                                children: [
                                  Text(
                                    fechaInspeccion,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                border: Border.all(color: Colors.red),
                              ),
                              padding: const EdgeInsets.all(8.0),
                              margin: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Column(
                                children: [
                                  Text(
                                    fechaCaducidad,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        trailing: Container(
                          width: 50, // Ancho de la imagen
                          height: 50, // Alto de la imagen
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25), // Radio de borde para hacerlo redondeado
                            color: Colors.blue, // Color de fondo de la imagen
                          ),
                          child: Icon(
                            Icons.photo, // Aquí puedes usar tu propia imagen
                            color: Colors.white, // Color del icono (o imagen)
                          ),
                        ),
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
