
import 'package:evaluacionmaquinas/features/data/models/centro_dm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/dimensions.dart';
import '../../../core/utils/Constants.dart';
import '../../../core/utils/Utils.dart';
import '../../../generated/l10n.dart';
import '../../data/models/evaluacion_list_dm.dart';
import '../components/caducidad_indicator.dart';
import '../components/dialog/my_two_buttons_dialog.dart';
import '../components/empty_view.dart';
import '../cubit/evaluaciones_cubit.dart';
import 'detalle_evaluacion_page.dart';

import 'filtros_page.dart';

class MisEvaluaccionesPage extends StatefulWidget {
  const MisEvaluaccionesPage({super.key});

  @override
  _MisEvaluaccionesPageState createState() => _MisEvaluaccionesPageState();
}

// Añadir un estado local para controlar la visibilidad de la cruz en cada evaluación
class _MisEvaluaccionesPageState extends State<MisEvaluaccionesPage> {
  late EvaluacionesCubit _cubitEvaluaciones;

  bool _showDeleteIcons = false;




  @override
  void initState() {
    super.initState();
    _cubitEvaluaciones = BlocProvider.of<EvaluacionesCubit>(context);
    _cubitEvaluaciones.getEvaluaciones(context);
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
            _showDeleteIcons ? S.of(context).deleteEvaluations : S.of(context).myEvaluationsTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),

          actions: [
          Visibility(
              visible: _showDeleteIcons,
              child: IconButton(
              icon: Icon(Icons.close, semanticLabel: S.of(context).semanticlabelClose), // Icono de cruz
              onPressed: () {
                setState(() {
                  _showDeleteIcons = false;
                });
              },
            ),
          )
        ],
          automaticallyImplyLeading: false,
            centerTitle: true
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        body:  BlocConsumer<EvaluacionesCubit, EvaluacionesState>(
            listener: (context, state) {
              if(state is EvaluacionesDeleteSuccess){
                _closeLoadingDialog(context);
                _showDeleteSuccessDialog(context);
                setState(() {
                  if(_cubitEvaluaciones.evaluacionesFiltered.isEmpty){
                    _showDeleteIcons = false;
                  }
                });
              }else if (state is EvaluacionesDeleteLoading) {
                _showLoadingDialog(context, myText: S.of(context).deletingEvaluation);
              } else if (state is EvaluacionesDeleteError) {
                _closeLoadingDialog(context);
                Utils.showMyOkDialog(context, S.of(context).error, state.errorMessage, () {
                  Navigator.of(context).pop();
                });
              }
            },

          builder: (context, state) {

            List<EvaluacionDataModel> evaluaciones = _cubitEvaluaciones.evaluacionesFiltered;
            final filtros = _cubitEvaluaciones.filtros;

            return Column(
              children: [
                _buildSortingAndFilterRow(context, _cubitEvaluaciones.sortedByDate, _cubitEvaluaciones.sortDateDescendent, _cubitEvaluaciones.sortNameDescendent),
                _buildFiltrosList(context, filtros),

                // Mostrar el estado de carga si es necesario
                if (state is EvaluacionesLoading)
                  Expanded(
                    child: const Center(child: CircularProgressIndicator()),
                  )

                // Mostrar el error si hay un fallo
                else if (state is EvaluacionesError)
                  Expanded(
                    child: Center(
                      child: EmptyView(
                        customText: state.errorMessage,
                        onRetry: () {
                          _cubitEvaluaciones.getEvaluaciones(context);
                        },
                        showRetryButton: false,
                      ),
                    ),
                  )

                // Mostrar la lista de evaluaciones
                else
                  _buildEvaluationsList(context, evaluaciones),
              ],
            );
          },
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
            _cubitEvaluaciones.eliminarEvaluacion(context, idEvaluacion, idMaquina);
          },
          onSecondaryButtonTap: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
  }



  Widget _buildSortingAndFilterRow(BuildContext context, bool sortedByDate, bool sortDateDescendent, bool sortNameDescendent) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(width: Dimensions.marginSmall),
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).colorScheme.primaryContainer,
          ),
          child: IconButton(
            icon: Icon(Icons.filter_alt, semanticLabel: S.of(context).semanticlabelFilters),
            color: Theme.of(context).colorScheme.onPrimaryContainer,
            onPressed: () {
              _cubitEvaluaciones.saveCurrentFilters();
              Navigator.push(context, MaterialPageRoute(builder: (context) => const FiltrosPage()));
            },
          ),
        ),
        const Spacer(),
        // Botón de ordenación por nombre
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: (!sortedByDate) ? Theme.of(context).colorScheme.secondaryContainer : Theme.of(context).colorScheme.primaryContainer,
          ),
          child: IconButton(
             icon:  (sortNameDescendent)
              ? Image.asset('assets/icons/ic_sort_down.png', height: Dimensions.iconSize, width: Dimensions.iconSize, semanticLabel: S.of(context).semanticlabelSortAlphabeticallyDesc)
              : Image.asset('assets/icons/ic_sort_up.png', height: Dimensions.iconSize, width: Dimensions.iconSize, semanticLabel: S.of(context).semanticlabelSortAlphabeticallyAsc),
            color: Theme.of(context).colorScheme.onPrimaryContainer,
            onPressed: () {
                Fluttertoast.showToast(
                  msg: sortNameDescendent
                    ? S.of(context).evaluationsSortedName
                    : S.of(context).evaluationsSortedNameDescendant,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  backgroundColor: Colors.grey,
                  textColor: Colors.white,
                );
               _cubitEvaluaciones.updateSorting(context, false);
            },
          ),
        ),
        const SizedBox(width: Dimensions.marginSmall),
        // Botón de ordenación por fecha
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: (sortedByDate) ? Theme.of(context).colorScheme.secondaryContainer : Theme.of(context).colorScheme.primaryContainer,
          ),
          child: IconButton(
            icon: (sortDateDescendent)
                ? Image.asset('assets/icons/ic_calendar_down.png', height: 27, width: 27, semanticLabel: S.of(context).semanticlabelSortByCreationDateDesc)
                : Image.asset('assets/icons/ic_calendar_up.png', height: 27, width: 27, semanticLabel: S.of(context).semanticlabelSortByCreationDateAsc),
            color: Theme.of(context).colorScheme.onPrimaryContainer,
            onPressed: () {
              Fluttertoast.showToast(
                msg: sortDateDescendent
                  ? S.of(context).evaluationsSortedDate
                  : S.of(context).evaluationsSortedDateDescendant,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                backgroundColor: Colors.grey,
                textColor: Colors.white,
              );
              _cubitEvaluaciones.updateSorting(context, true);
            }
          ),
        ),
        const SizedBox(width: Dimensions.marginSmall),
      ],
    );
  }





  Widget _buildFiltrosList(BuildContext context, Map<String, dynamic> filtros) {
    return SizedBox(
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
                            : "${filtro.key}: ${(filtro.value as CentroDataModel).denominacion}",
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      const SizedBox(width: Dimensions.marginSmall),
                      GestureDetector(
                        onTap: () {
                          _cubitEvaluaciones.removeFilter(context, filtro.key);
                        },
                        child: Icon(
                          Icons.close,
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                          size: 20.0,
                          semanticLabel: S.of(context).semanticlabelClose,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }


  Widget _buildEvaluationsList(BuildContext context, List<EvaluacionDataModel> evaluaciones) {

    if (evaluaciones.isEmpty) {
      return Expanded(
          child:const Center(
            child: EmptyView(
              showRetryButton: false,
            ),
          ),
      );
    } else{
      return Expanded(
        child:

        GestureDetector(
          // Detecta un clic largo en la lista
          onLongPress: () {
            setState(() {
              _showDeleteIcons = true;
            });
          },
          child: ListView.builder(
            itemCount: evaluaciones.length,
            itemBuilder: (BuildContext context, int index) {
              final evaluacion = evaluaciones[index];
              return GestureDetector(
                onTap: () {
                  if(!_showDeleteIcons){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetalleEvaluacionPage(idEvaluacion: evaluaciones[index].ideval),
                      ),
                    );
                  }
                },
                child: Stack(
                  children: [
                    Card(
                        margin: const EdgeInsets.all(Dimensions.marginSmall),
                        elevation: 0,
                        color: Theme.of(context).colorScheme.onPrimary,
                        child: Padding(
                          padding: const EdgeInsets.all(Dimensions.marginSmall),
                          child: Column(
                            children: [
                              Text(
                                evaluacion.nombreMaquina,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Divider(
                                color: Theme.of(context).colorScheme.surface,
                                thickness: 1,
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
                                  Text(DateFormat(DateFormatString).format(evaluacion.fechaCaducidad), style: TextStyle(color:  Theme.of(context).colorScheme.onSecondary)),
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
                        color: _showDeleteIcons? Theme.of(context).colorScheme.surface.withOpacity(0.5) : Colors.transparent,
                      ),
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: _showDeleteIcons // Mostrar la cruz según la visibilidad de la lista
                          ? IconButton(
                        icon: Image.asset(
                          'assets/icons/ic_close_transparent.png',
                          height: 40, // Ajusta el tamaño de la imagen según sea necesario
                          width: 40,
                          color: Colors.red,
                          semanticLabel: S.of(context).semanticlabelDelete,
                        ),
                        onPressed: () {
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
        ),

      );
    }
  }


  static bool isDialogOpen = false;

  static bool isDeletedDialogOpen = false;

  static void _showDeleteSuccessDialog(BuildContext context) {
    if (!isDeletedDialogOpen) {
      isDeletedDialogOpen = true;
      Utils.showMyOkDialog(context, S.of(context).evaluationDeleted,  S.of(context).evaluationDeletedDesc, () {
        Navigator.of(context).pop();
        isDeletedDialogOpen = false;
      });
    }
  }

  static void _showLoadingDialog(BuildContext context, {String myText = ""}) {
    if (!isDialogOpen) {
      isDialogOpen = true;
      Utils.showLoadingDialog(context, text: myText);
    }
  }

  static void _closeLoadingDialog(BuildContext context){
    if (isDialogOpen) {
      Navigator.of(context).pop();
      isDialogOpen = false;
    }
  }

}



