import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:evaluacionmaquinas/cubit/evaluaciones_cubit.dart';
import 'package:evaluacionmaquinas/views/my_home_page.dart';
import 'package:evaluacionmaquinas/components/textField/my_textfield.dart';
import '../components/buttons/my_button.dart';
import '../components/datePicker/custom_date_picker.dart';
import '../components/textField/custom_drop_down_field.dart';
import '../cubit/centros_cubit.dart';
import '../generated/l10n.dart';
import '../modelos/centro_dm.dart';
import '../utils/Constants.dart';
import '../utils/Utils.dart';
import '../theme/dimensions.dart';

class FiltrosPage extends StatefulWidget {
  const FiltrosPage({Key? key}) : super(key: key);

  @override
  _FiltrosPageState createState() => _FiltrosPageState();
}

class _FiltrosPageState extends State<FiltrosPage> {
  late EvaluacionesCubit _cubitEvaluaciones;
  Map<String, dynamic> _filtros = {};

  final _fechaRealizacionNotifier = ValueNotifier<DateTime?>(null);
  final _fechaCaducidadNotifier = ValueNotifier<DateTime?>(null);
  final _centrosController = TextEditingController();

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
      _fechaCaducidadNotifier.value = (_filtros[filtroFechaRealizacion] as DateTime);
    }

    if(_filtros[filtroFechaCaducidad] != null){
      _fechaCaducidadNotifier.value = (_filtros[filtroFechaCaducidad] as DateTime);
    }
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).filters,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        centerTitle: true,
      ),
      body: Container(
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
                              _centrosController.text = _filtros[filtroCentro] as String;
                            }

                            return CustomDropdownField(
                                controller: _centrosController,
                                hintText: S.of(context).hintCenter,
                                items: _centros,
                                numItems: 5
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
                        },
                        selectedDateNotifier: _fechaCaducidadNotifier,
                        hasLimitDay: false,
                      ),
                    ],
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _centrosController.clear();
                        _fechaRealizacion = null;
                        _fechaCaducidad = null;

                        _fechaRealizacionNotifier.value = null;
                        _fechaCaducidadNotifier.value = null;
                      });
                    },
                    child: Text(
                      S.of(context).reset,
                      style: const TextStyle(
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  MyButton(
                    onTap: () {
                      if(_fechaRealizacion != null){
                        _cubitEvaluaciones.addFilter(context, filtroFechaCaducidad, _fechaRealizacion);
                      }else{
                        _cubitEvaluaciones.removeFilter(context, filtroFechaCaducidad);
                      }
                      if(_fechaCaducidad != null){
                        _cubitEvaluaciones.addFilter(context, filtroFechaRealizacion, _fechaCaducidad);
                      }else{
                        _cubitEvaluaciones.removeFilter(context, filtroFechaRealizacion);
                      }
                      if(_centrosController.text.trim().isNotEmpty){
                        _cubitEvaluaciones.addFilter(context, filtroCentro, _centrosController.text.trim());
                      }else{
                        _cubitEvaluaciones.removeFilter(context, filtroCentro);
                      }

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MyHomePage(),
                        ),
                      );
                    },
                    text: S.of(context).search,
                    adaptableWidth: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
