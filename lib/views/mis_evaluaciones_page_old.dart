import 'package:evaluacionmaquinas/components/dialog/my_ok_dialog.dart';
import 'package:evaluacionmaquinas/components/dialog/my_two_buttons_dialog.dart';
import 'package:evaluacionmaquinas/cubit/eliminar_evaluacion_cubit.dart';
import 'package:evaluacionmaquinas/helpers/ConstantsHelper.dart';
import 'package:evaluacionmaquinas/modelos/evaluacion_list_dm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:evaluacionmaquinas/cubit/insertar_evaluacion_cubit.dart';
import 'package:evaluacionmaquinas/theme/dimensions.dart';
import 'package:evaluacionmaquinas/views/checklist_page.dart';
import 'package:evaluacionmaquinas/views/filtros_page.dart';
import '../components/dialog/my_loading_dialog.dart';
import '../cubit/evaluaciones_cubit.dart';
import 'detalle_evaluacion_page.dart';

import 'package:flutter/material.dart';
import 'detalle_evaluacion_page.dart';

class MisEvaluaccionesOldPage extends StatefulWidget {
  const MisEvaluaccionesOldPage({Key? key}) : super(key: key);

  @override
  _MisEvaluaccionesOldPageState createState() => _MisEvaluaccionesOldPageState();
}

class _MisEvaluaccionesOldPageState extends State<MisEvaluaccionesOldPage> {

  @override
  void initState() {
    super.initState();
    _cubitEvaluacion =   BlocProvider.of<EvaluacionesCubit>(context);
    _cubitEvaluacion.getEvaluaciones();
  }
  late EvaluacionesCubit _cubitEvaluacion;

  late int _indexToDelete;
  late List<ListEvaluacionDataModel> _evaluaciones;
  List<String> filterList = ["Filtro 1", "Filtro 2", "Filtro 3", "Filtro 4", "Filtro 5", "Filtro 6", "Filtro 4", "Filtro 5", "Filtro 6", "Filtro 4", "Filtro 5", "Filtro 6"];


  void _eliminarEvaluacion(int idEvaluacion) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MyTwoButtonsDialog(
          title: "¿Está seguro de que desea eliminar la evaluación?",
          desc: "Una vez eliminada, no podrá recuperar los datos",
          primaryButtonText: "Confirmar",
          secondaryButtonText: "Cancelar",
          onPrimaryButtonTap: (){
            _cubitEvaluacion.eliminarEvaluacion(idEvaluacion);
            Navigator.of(context).pop();
          },
          onSecondaryButtonTap: (){
            Navigator.of(context).pop();
          },
        );
      },

    );

  }

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
              child: BlocConsumer<EvaluacionesCubit, EvaluacionesState>(
                builder: (context, state) {
                  if (state is EvaluacionesLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is EvaluacionesLoaded) {
                    _evaluaciones = state.evaluaciones;
                    return ListView.builder(
                      itemCount: state.evaluaciones.length,
                      itemBuilder: (BuildContext context, int index) {
                        final evaluacion = _evaluaciones[index];
                        return Dismissible(
                          key: UniqueKey(), // Se necesita una clave única para cada elemento Dismissible
                          onDismissed: (direction) {
                            // Remover el elemento de la lista cuando se desliza
                            setState(() {
                              _indexToDelete = index;
                              _eliminarEvaluacion(evaluacion.ideval);
                            });
                          },
                          background: Container(
                            color: Colors.red, // Color de fondo cuando se desliza
                            child: Icon(Icons.delete, color: Colors.white),
                            alignment: Alignment.centerRight,
                            padding: EdgeInsets.only(right: 20.0),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const DetalleEvaluaccionPage()),
                              );
                            },
                            child: Card(
                              margin: const EdgeInsets.all(10),
                              elevation: 0,
                              color: Theme.of(context).colorScheme.onBackground,
                              child: ListTile(
                                title: Text(
                                  evaluacion.nombreMaquina,
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
                                            'Fecha de realización: ${evaluacion.fechaRealizacion.toString()}',
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
                                            'Fecha de caducidad: ${evaluacion.fechaCaducidad.toString()}',
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: ClipRRect(
                                  borderRadius: BorderRadius.circular(Dimensions.cornerRadius),
                                  child: evaluacion.imagen != null
                                      ? Image.memory(
                                    evaluacion.imagen!,
                                    width: 50, // Ajusta el tamaño de la imagen según sea necesario
                                    height: 50,
                                  )
                                      : const SizedBox(), // O cualquier otro widget que desees mostrar cuando no haya imagen
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else{
                    return const SizedBox();
                  }
                }, listener: (BuildContext context, EvaluacionesState state) {
                  if(state is EliminarEvaluacionCompletada){
                    _evaluaciones.removeAt(_indexToDelete);
                  }else if (state is EvaluacionesError) {
                    ConstantsHelper.showMyOkDialog(context, "Error", state.errorMessage, () {
                      Navigator.of(context).pop();
                    });
                  } else if(state is EvaluacionEliminada){
                    ConstantsHelper.showMyOkDialog(context, "¡Evaluación eliminada!", "La evaluación se ha eliminado correctamente.", () {
                      Navigator.of(context).pop();
                    });
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
