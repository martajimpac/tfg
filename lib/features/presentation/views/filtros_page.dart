import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/dimensions.dart';
import '../../../core/utils/Constants.dart';
import '../../../core/utils/Utils.dart';
import '../../../generated/l10n.dart';
import '../../data/models/centro_dm.dart';
import '../components/buttons/my_button.dart';
import '../components/datePicker/custom_date_picker.dart';
import '../components/textField/custom_drop_down_field.dart';
import '../components/textField/my_textfield.dart';
import '../cubit/centros_cubit.dart';
import '../cubit/evaluaciones_cubit.dart';
import 'my_home_page.dart';


class FiltrosPage extends StatefulWidget {
  const FiltrosPage({super.key});

  @override
  _FiltrosPageState createState() => _FiltrosPageState();
}

class _FiltrosPageState extends State<FiltrosPage> {
  late EvaluacionesCubit _cubitEvaluaciones;
  Map<String, dynamic> _filtros = {};


  final _fechaRealizacionNotifier = ValueNotifier<DateTime?>(null);
  final _fechaCaducidadNotifier = ValueNotifier<DateTime?>(null);
  final _centrosController = TextEditingController();
  final _denominacionController = TextEditingController();

  DateTime? _fechaRealizacion;
  DateTime? _fechaCaducidad;
  List<CentroDataModel> _centros = [];


  @override
  void initState() {
    super.initState();
    BlocProvider.of<CentrosCubit>(context).getCentros(context);
    _cubitEvaluaciones = BlocProvider.of<EvaluacionesCubit>(context);
    _filtros = _cubitEvaluaciones.filtros;

    if(_filtros[filtroFechaRealizacion] != null){
      _fechaRealizacionNotifier.value = (_filtros[filtroFechaRealizacion] as DateTime);
    }

    if(_filtros[filtroFechaCaducidad] != null){
      _fechaCaducidadNotifier.value = (_filtros[filtroFechaCaducidad] as DateTime);
    }

    if(_filtros[filtroFechaCaducidad] != null){
      _denominacionController.text = (_filtros[filtroDenominacion] as String);
    }
  }

  void _exit(BuildContext context) {
    _cubitEvaluaciones.resetFilters(context);
  }


  @override
  void dispose() {
    _fechaRealizacionNotifier.dispose();
    _fechaCaducidadNotifier.dispose();
    _centrosController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        onPopInvoked: (bool didPop){
          _exit(context);
        }, child:
    Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).filters,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            _exit(context);
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height, // Altura total de la pantalla
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(S.of(context).denomination),
                      MyTextField(
                        controller: _denominacionController,
                        hintText: S.of(context).hintDenomination,
                        onTextChanged: (text) {
                          if (text.trim() != "") {
                            _cubitEvaluaciones.addFilter(context, filtroDenominacion, text);
                          } else {
                            _cubitEvaluaciones.removeFilter(context, filtroDenominacion);  // Corregido filtroCentro por filtroDenominacion
                          }
                        },
                      ),

                      Text(S.of(context).center),
                      BlocBuilder<CentrosCubit, CentrosState>(
                        builder: (context, state) {
                          if (state is CentrosLoading) {
                            return const SizedBox(
                              height: 100,
                              child: Center(child: CircularProgressIndicator()),
                            );
                          } else if (state is CentrosLoaded) {
                            _centros = state.centros;

                            if(_filtros[filtroCentro] != null && _filtros[filtroCentro].toString().isNotEmpty){
                              _centrosController.text = (_filtros[filtroCentro] as CentroDataModel).denominacion;
                            }

                            return CustomDropdownField(
                              controller: _centrosController,
                              hintText: S.of(context).hintCenter,
                              items: _centros,
                              numItems: 5,
                              onChanged: (String? value) {
                                if (value != null && value.trim().isNotEmpty) {
                                  final centro = _centros.firstWhere((it) => it.denominacion == value.trim());
                                  _cubitEvaluaciones.addFilter(context, filtroCentro, centro);
                                } else {
                                  _cubitEvaluaciones.removeFilter(context, filtroCentro);
                                }
                              },
                            );
                          } else if (state is CentrosError) {
                            Utils.showMyOkDialog(context, S.of(context).error, state.errorMessage, () => null);
                            return const SizedBox();
                          } else {
                            return const SizedBox();
                          }
                        },
                      ),

                      const SizedBox(height: Dimensions.marginSmall),
                      Text(S.of(context).completionDateMustBeAfter),
                      CustomDatePicker(
                        onDateChanged: (DateTime? newDate) {
                          _fechaRealizacion = newDate;
                          if (newDate != null) {
                            _cubitEvaluaciones.addFilter(context, filtroFechaRealizacion, newDate);
                          } else {
                            _cubitEvaluaciones.removeFilter(context, filtroFechaRealizacion);
                          }
                        },
                        selectedDateNotifier: _fechaRealizacionNotifier,
                        hasLimitDay: false,
                      ),

                      const SizedBox(height: Dimensions.marginSmall),
                      Text(S.of(context).expirationDateMustBeBefore),

                      const SizedBox(height: Dimensions.marginSmall),
                      CustomDatePicker(
                        onDateChanged: (DateTime? newDate) {
                          _fechaCaducidad = newDate;
                          if (newDate != null) {
                            _cubitEvaluaciones.addFilter(context, filtroFechaCaducidad, newDate);
                          } else {
                            _cubitEvaluaciones.removeFilter(context, filtroFechaCaducidad);
                          }
                        },
                        selectedDateNotifier: _fechaCaducidadNotifier,
                        hasLimitDay: false,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            GestureDetector(
              onTap: () {
                setState(() {
                  _centrosController.clear();
                  _fechaRealizacion = null;
                  _fechaCaducidad = null;

                  _fechaRealizacionNotifier.value = null;
                  _fechaCaducidadNotifier.value = null;

                  _cubitEvaluaciones.clearFilters(context);
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(left: Dimensions.marginMedium),
                child: Text(
                  S.of(context).delete,
                  style: const TextStyle(
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),

            Container(
              margin: const EdgeInsets.only(top: 20), // Espacio entre el contenido y la línea gris
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                ),
              ),
            ),
            // Fila para el texto "Restablecer" y el botón de búsqueda
            Padding(
              padding: const EdgeInsets.only(
                top: Dimensions.marginSmall,   // Espacio en la parte superior
                bottom: Dimensions.marginSmall, // Espacio en la parte inferior
                left: Dimensions.marginMedium,    // Espacio a la izquierda
                right: Dimensions.marginMedium,   // Espacio a la derecha
              ),
              child: BlocBuilder<EvaluacionesCubit, EvaluacionesState>(

                builder: (context, state) {

                  final numEval = _cubitEvaluaciones.evaluacionesFiltered.length;

                  return MyButton(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MyHomePage(),
                        ),
                      );
                    },
                    text: numEval > 0
                        ? "${S.of(context).show_results} ($numEval)"
                        : S.of(context).no_results, // Si no hay resultados, muestra "No hay resultados"
                    adaptableWidth: false,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    )
    );
  }
}
