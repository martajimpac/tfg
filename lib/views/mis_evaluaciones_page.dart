import 'dart:math';

import 'package:evaluacionmaquinas/components/caducidad_indicator.dart';
import 'package:evaluacionmaquinas/components/dialog/my_ok_dialog.dart';
import 'package:evaluacionmaquinas/components/empty_view.dart';
import 'package:evaluacionmaquinas/cubit/eliminar_evaluacion_cubit.dart';
import 'package:evaluacionmaquinas/modelos/evaluacion_list_dm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:evaluacionmaquinas/cubit/insertar_evaluacion_cubit.dart';
import 'package:evaluacionmaquinas/theme/dimensions.dart';
import 'package:evaluacionmaquinas/views/checklist_page.dart';
import 'package:evaluacionmaquinas/views/filtros_page.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import '../components/dialog/my_loading_dialog.dart';
import '../components/dialog/my_two_buttons_dialog.dart';
import '../cubit/evaluaciones_cubit.dart';
import '../generated/l10n.dart';
import '../utils/Constants.dart';
import '../utils/Utils.dart';
import 'detalle_evaluacion_page.dart';

import 'package:flutter/material.dart';
import 'detalle_evaluacion_page.dart';

class MisEvaluaccionesPage extends StatefulWidget {
  const MisEvaluaccionesPage({Key? key}) : super(key: key);

  @override
  _MisEvaluaccionesPageState createState() => _MisEvaluaccionesPageState();
}

// Añadir un estado local para controlar la visibilidad de la cruz en cada evaluación
class _MisEvaluaccionesPageState extends State<MisEvaluaccionesPage> {
  late EliminarEvaluacionCubit _cubitEliminarEvaluacion;
  late EvaluacionesCubit _cubitEvaluaciones;
  late int _indexToDelete;
  late List<EvaluacionDataModel> _evaluaciones;

  bool _showDeleteIcons = false;

  bool _showMap = false;
  bool _sortedByDate = true;
  bool _sortDateDescendent = true;
  bool _sortNameDescendent = true;

  @override
  void initState() {
    super.initState();
    _cubitEvaluaciones = BlocProvider.of<EvaluacionesCubit>(context);
    _cubitEliminarEvaluacion = BlocProvider.of<EliminarEvaluacionCubit>(context);
    _cubitEvaluaciones.getEvaluaciones(context);
  }

  @override
  void dispose() {
    //_cubitEvaluaciones.close(); //TODO ESTO DA PROBLEMAS SI VAS A OTRA PAGINA ANTES DE QUE SE HAYA TERMINADO DE CARGAR
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop){
        setState(() {
          _showDeleteIcons = false;
        });
      }, child: SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            _showDeleteIcons ? '' : S.of(context).myEvaluationsTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          actions: [
          Visibility(
              visible: _showDeleteIcons,
              child: IconButton(
              icon: const Icon(Icons.close), // Icono de cruz
              onPressed: () {
                setState(() {
                  _showDeleteIcons = false;
                });
              },
            ),
          )
        ],
          automaticallyImplyLeading: false,
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Resto del código permanece igual
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Para alinear los contenedores a los extremos
              children: [
                const SizedBox(width: Dimensions.marginSmall),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).colorScheme.primaryContainer,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.filter_alt),
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const FiltrosPage()),);
                    },
                  ),
                ),
                /*Container( TODO VER SI PONGO LO DEL MAPA
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).colorScheme.primaryContainer,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.map),
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    onPressed: () {
                      setState(() {
                        _showMap =!_showMap;
                      });
                    },
                  ),
                ),*/
                const Spacer(), // Para separar los contenedores de la izquierda y de la derecha
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: (!_sortedByDate) ? Theme.of(context).colorScheme.secondaryContainer : Theme.of(context).colorScheme.primaryContainer,
                  ),
                  child: IconButton(
                    icon: (_sortNameDescendent)
                        ? Image.asset('lib/images/ic_sort_down.png', height: Dimensions.iconSize, width: Dimensions.iconSize)
                        : Image.asset('lib/images/ic_sort_up.png', height: Dimensions.iconSize, width: Dimensions.iconSize),
                    color: Theme.of(context).colorScheme.onPrimaryContainer, //TODO CAMBIAR COLOR??
                    onPressed: () {
                        setState(() {

                        });

                        Fluttertoast.showToast(
                          msg: _sortNameDescendent
                              ? S.of(context).evaluationsSortedNameDescendant
                              : S.of(context).evaluationsSortedName ,
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          backgroundColor: Colors.grey,
                          textColor: Colors.white,
                        );
                        //si ya estabamos ordenando por nombre ordenar al reves
                        if(!_sortedByDate){
                          _sortNameDescendent = !_sortNameDescendent;
                        }
                        _sortedByDate = false;
                    },
                  ),
                ),
                const SizedBox(width: Dimensions.marginSmall),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: (_sortedByDate) ? Theme.of(context).colorScheme.secondaryContainer : Theme.of(context).colorScheme.primaryContainer,
                  ),
                  child: IconButton(
                    icon: (_sortDateDescendent)
                        ? Image.asset('lib/images/ic_calendar_down.png', height: 27, width: 27)
                        : Image.asset('lib/images/ic_calendar_up.png', height: 27, width: 27),
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    onPressed: () {

                      setState(() {

                      });

                      Fluttertoast.showToast(
                        msg: _sortDateDescendent
                            ? S.of(context).evaluationsSortedDateDescendant
                            : S.of(context).evaluationsSortedDate,
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        backgroundColor: Colors.grey,
                        textColor: Colors.white,
                      );

                      //si ya estabamos ordenando por fecha ordenar al reves
                      if(_sortedByDate){
                        _sortDateDescendent = !_sortDateDescendent;
                      }
                      _sortedByDate = true;
                    },
                  ),
                ),
                const SizedBox(width: Dimensions.marginSmall),
              ],
            ),

            /****************** FILTROS **************************************************************************/
            SizedBox(
              height: _cubitEvaluaciones.filtros.entries.isEmpty ? 0 : 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                physics: const ClampingScrollPhysics(),
                shrinkWrap: true,
                children: [
                  for (final filtro in _cubitEvaluaciones.filtros.entries)
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
                                (filtro.key == filtroFechaRealizacion || filtro.key == filtroFechaCaducidad)
                                    ? "${filtro.key}: ${DateFormat(DateFormatString).format(filtro.value)}"
                                    : "${filtro.key}: ${filtro.value}",
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                              const SizedBox(width: Dimensions.marginSmall),
                              GestureDetector(
                                onTap: () {
                                  _cubitEvaluaciones.removeFilter(context, filtro.key);
                                  _cubitEvaluaciones.filtros.remove(filtro.key);
                                  setState(() {});
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

            /****************** FIN FILTROS **************************************************************************/
            /****************** EVALUACIONES **************************************************************************/
            _buildLista(),
            ///_showMap ? _buildMap() : ,

            /****************** FIN EVALUACIONES **************************************************************************/
            BlocListener<EliminarEvaluacionCubit, EliminarEvaluacionState>(
                listener: (context, state) {
                  if(state is EliminarEvaluacionCompletada){
                    Navigator.of(context).pop();
                    //Navigator.of(context).pop();
                    Utils.showMyOkDialog(context, S.of(context).evaluationDeleted,  S.of(context).evaluationDeletedDesc, () {
                      Navigator.of(context).pop();
                    });
                    setState(() {
                      _evaluaciones.removeAt(_indexToDelete);
                    });
                  }else if (state is EliminarEvaluacionLoading) {
                    Utils.showLoadingDialog(context, text: S.of(context).deletingEvaluation);
                  } else if (state is EliminarEvaluacionError) {
                    Navigator.of(context).pop();
                    Utils.showMyOkDialog(context, S.of(context).error, state.errorMessage, () {
                      Navigator.of(context).pop();
                    });
                  }
                },child: const SizedBox()
            )
          ],
        ),
      ),
    ),
    );
  }

  void _eliminarEvaluacion(int idEvaluacion, int idMaquina) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MyTwoButtonsDialog(
          title: S.of(context).deleteEvaluationsTitle,
          desc: S.of(context).deleteEvaluationsDesc,
          primaryButtonText: S.of(context).delete,
          secondaryButtonText: S.of(context).cancel,
          onPrimaryButtonTap: () {
            Navigator.of(context).pop();
            _cubitEliminarEvaluacion.eliminarEvaluacion(context, idEvaluacion, idMaquina);
          },
          onSecondaryButtonTap: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
  }


  Widget _buildMap() {
    return Expanded(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: FlutterMap(
              options: const MapOptions(
                minZoom: 5,
                maxZoom: 25,
                initialCenter: LatLng(51.5, -0.09),
                initialZoom: 18.0,
              ),
              mapController: MapController(),
              children: [],
            ),
          ),
        )
    );
  }

  Widget _buildLista() {

    return Expanded(
      child: BlocBuilder<EvaluacionesCubit, EvaluacionesState>(
        builder: (context, state) {
          if (state is EvaluacionesLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is EvaluacionesLoaded) {
            _evaluaciones = state.evaluaciones;

            //ordenar
            if(_sortedByDate){
              _evaluaciones.sort((a, b) => a.fechaRealizacion.compareTo(b.fechaRealizacion));
              if(!_sortDateDescendent){
                _evaluaciones = _evaluaciones.reversed.toList();
              }
            }else{
              _evaluaciones.sort((a, b) => a.nombreMaquina.compareTo(b.nombreMaquina));
              if(!_sortNameDescendent){
                _evaluaciones = _evaluaciones.reversed.toList();
              }
            }

            if (_evaluaciones.isEmpty) {
              return const Center(
                child: EmptyView(
                  showRetryButton: false,
                ),
              );
            } else{
              return GestureDetector(
                // Detecta un clic largo en la lista
                onLongPress: () {
                  setState(() {
                    _showDeleteIcons = true;
                  });
                },
                child: ListView.builder(
                  itemCount: state.evaluaciones.length,
                  itemBuilder: (BuildContext context, int index) {
                    final evaluacion = _evaluaciones[index];
                    return GestureDetector(
                      onTap: () {
                        if(!_showDeleteIcons){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetalleEvaluacionPage(idEvaluacion: _evaluaciones[index].ideval),
                            ),
                          );
                        }
                      },
                      child: Stack(
                        children: [
                          Card(
                              margin: const EdgeInsets.all(Dimensions.marginSmall),
                              elevation: 0,
                              color: Theme.of(context).colorScheme.onBackground,
                              child: Padding(
                                padding: const EdgeInsets.all(Dimensions.marginSmall),
                                child: Column(
                                  children: [
                                    Text(
                                      evaluacion.nombreMaquina,
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(evaluacion.centro, style: TextStyle( color: Theme.of(context).colorScheme.onSecondary)),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(DateFormat(DateFormatString).format(evaluacion.fechaRealizacion), style: TextStyle(color:  Theme.of(context).colorScheme.onSecondary)),
                                        const Text(" - "),
                                        Text(DateFormat(DateFormatString).format(evaluacion.fechaCaducidad), style: const TextStyle(color: Colors.red)),
                                      ],
                                    ),
                                    const SizedBox(height: Dimensions.marginSmall),
                                    CaducidadIndicator(fechaCaducidad: evaluacion.fechaCaducidad)
                                  ],
                                ),
                              )
                          ),
                          Positioned.fill(
                            child: Container(
                              color: _showDeleteIcons? Theme.of(context).colorScheme.background.withOpacity(0.5) : Colors.transparent,
                            ),
                          ),
                          Positioned(
                            top: 10,
                            right: 10,
                            child: _showDeleteIcons // Mostrar la cruz según la visibilidad de la lista
                                ? IconButton(
                              icon: Image.asset(
                                'lib/images/ic_close.png',
                                height: 40, // Ajusta el tamaño de la imagen según sea necesario
                                width: 40,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                _indexToDelete = index;
                                _eliminarEvaluacion(evaluacion.ideval, evaluacion.idMaquina);
                              },
                            )
                                : const SizedBox(),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            }
          } else if (state is EvaluacionesError) {
            return Center(
              child: EmptyView(
                customText: state.errorMessage,
                onRetry: () {
                  _cubitEvaluaciones.getEvaluaciones(context);
                },
                showRetryButton: false,
              ),
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }

}



