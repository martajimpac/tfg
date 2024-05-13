import 'package:evaluacionmaquinas/components/my_button.dart';
import 'package:evaluacionmaquinas/cubit/evaluaciones_cubit.dart';
import 'package:evaluacionmaquinas/views/my_home_page.dart';
import 'package:flutter/material.dart';
import 'package:evaluacionmaquinas/components/textField/my_textfield.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../components/datePicker/custom_date_picker.dart';
import '../components/textField/custom_drop_down_field.dart';
import '../cubit/centros_cubit.dart';
import '../helpers/ConstantsHelper.dart';
import '../main.dart';
import '../modelos/centro_dm.dart';
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
    BlocProvider.of<CentrosCubit>(context).getCentros();
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
          'Filtros',
          style: Theme.of(context).textTheme.titleMedium,
        ),
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
                  const Text("Centro"),
                  BlocBuilder<CentrosCubit, CentrosState>(
                    builder: (context, state) {
                      if (state is CentrosLoading) {
                        return const SizedBox();
                      } else if (state is CentrosLoaded) {
                        _centros = state.centros;

                        if(_filtros[filtroCentro] != null && _filtros[filtroCentro].toString().isNotEmpty){
                          _centrosController.text = _filtros[filtroCentro] as String;
                        }

                        return CustomDropdownField(
                          controller: _centrosController,
                          hintText: "Nombre del centro",
                          items: _centros,
                          numItems: 5
                        );
                      } else if (state is CentrosError) {
                        ConstantsHelper.showMyOkDialog(context, "Error", state.errorMessage, () => null);
                        return const SizedBox();
                      } else {  return const SizedBox(); }
                    },
                  ),

                  const SizedBox(height: Dimensions.marginSmall),
                  const Text("La fecha de realización debe ser posterior a..."),
                  CustomDatePicker(
                    onDateChanged: (DateTime? newDate) {
                      _fechaRealizacion = newDate;
                    },
                    selectedDateNotifier: _fechaRealizacionNotifier,
                    hasLimitDay: false,
                  ),

                  const SizedBox(height: Dimensions.marginSmall),
                  const Text("La fecha de caducidad debe ser anterior a...."),

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
              padding: const  EdgeInsets.only(
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
                    child: const Text(
                      "Restablecer",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  MyButton(
                    onTap: () {
                      if(_fechaRealizacion != null){
                        _cubitEvaluaciones.addFilter(filtroFechaCaducidad, _fechaRealizacion);
                      }
                      if(_fechaCaducidad != null){
                        _cubitEvaluaciones.addFilter(filtroFechaRealizacion, _fechaCaducidad);
                      }
                      if(_centrosController.text.trim().isNotEmpty){
                        _cubitEvaluaciones.addFilter(filtroCentro, _centrosController.text.trim());
                      }

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MyHomePage(),
                        ),
                      );
                    },
                    text: "Buscar",
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
