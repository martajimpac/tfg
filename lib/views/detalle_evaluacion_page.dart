import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:evaluacionmaquinas/cubit/detalles_evaluacion_cubit.dart';
import 'package:evaluacionmaquinas/modelos/evaluacion_details_dm.dart';
import 'package:evaluacionmaquinas/modelos/imagen_dm.dart';
import 'package:evaluacionmaquinas/views/nueva_evaluacion_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:evaluacionmaquinas/components/my_button.dart';
import 'package:evaluacionmaquinas/components/textField/my_textfield.dart';
import 'package:evaluacionmaquinas/main.dart';
import 'package:evaluacionmaquinas/theme/dimensions.dart';
import 'package:evaluacionmaquinas/views/checklist_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:convert/convert.dart';
import 'package:intl/intl.dart';

import '../helpers/ConstantsHelper.dart';

class DetalleEvaluaccionPage extends StatefulWidget {
  final int idEvaluacion;

  const DetalleEvaluaccionPage({Key? key, required this.idEvaluacion}) : super(key: key);

  @override
  _DetalleEvaluaccionPageState createState() => _DetalleEvaluaccionPageState();
}

class _DetalleEvaluaccionPageState extends State<DetalleEvaluaccionPage> {
  late EvaluacionDetailsDataModel _evaluacion;
  late List<ImagenDataModel> _imagenes;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<DetallesEvaluacionCubit>(context).getDetallesEvaluacion(widget.idEvaluacion);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          title: Text("Detalles de la evaluación", style: Theme.of(context).textTheme.titleMedium),
        ),
        body: Padding(
          padding: const EdgeInsets.all(Dimensions.marginMedium),
            child: BlocBuilder<DetallesEvaluacionCubit, DetallesEvaluacionState>(
              builder: (context, state) {
                if(state is DetallesEvaluacionLoading){
                  return const Center(child: CircularProgressIndicator());
                } else if(state is DetallesEvaluacionLoaded){
                  _evaluacion = state.evaluacion;
                  _imagenes = state.imagenes;
                  return Column(
                    children: [
                      Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(Dimensions.cornerRadius),
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(Dimensions.marginMedium),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text("Datos evaluacion", style: Theme.of(context).textTheme.headlineMedium),
                                      ],
                                    ),
                                    const SizedBox(height: Dimensions.marginSmall),
                                    Row(
                                      children: [
                                        Icon(Icons.business, color: Theme.of(context).colorScheme.onSecondary),
                                        const SizedBox(width: 8),
                                        Text("Centro:", style: TextStyle(color: Theme.of(context).colorScheme.onSecondary)),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 32),
                                      child: Text(_evaluacion.nombreCentro),
                                    ),

                                    //TODO SHOW FECHA MODIFICACION Y poner cuantos dias quedan para que caduque aqui tambien, convertir en widget!!!

                                    const SizedBox(height: Dimensions.marginSmall),
                                    Row(
                                      children: [
                                        Icon(Icons.calendar_today, color: Theme.of(context).colorScheme.onSecondary),
                                        const SizedBox(width: 8),
                                        Text("Fecha de realización:", style: TextStyle(color: Theme.of(context).colorScheme.onSecondary)),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 32),
                                      child: Text(DateFormat(DateFormatString).format(_evaluacion.fechaRealizacion)),
                                    ),

                                    const SizedBox(height: Dimensions.marginSmall),
                                    Row(
                                      children: [
                                        Icon(Icons.calendar_today, color: Theme.of(context).colorScheme.onSecondary),
                                        const SizedBox(width: 8),
                                        Text("Fecha de caducidad:", style: TextStyle(color: Theme.of(context).colorScheme.onSecondary)),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 32),
                                      child: Text(DateFormat(DateFormatString).format(_evaluacion.fechaCaducidad)),
                                    ),

                                    /********************** DATOS MAQUINA***********************/
                                    const SizedBox(height: Dimensions.marginMedium),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text("Datos de la máquina", style: Theme.of(context).textTheme.headlineMedium),
                                      ],
                                    ),

                                    const SizedBox(height: Dimensions.marginSmall),
                                    const Text("Denominación:"),
                                    Text(_evaluacion.nombreMaquina),

                                    const SizedBox(height: Dimensions.marginSmall),
                                    const Text("Fabricante:"),
                                    Text(
                                        _evaluacion.fabricante != null && _evaluacion.fabricante!.isNotEmpty ?
                                        _evaluacion.fabricante! :
                                        "Fabricante desconocido"
                                    ),

                                    const SizedBox(height: Dimensions.marginSmall),
                                    const Text("Nº de fabricante / Nº de serie:"),
                                    Text(_evaluacion.numeroSerie),

                                    const SizedBox(height: Dimensions.marginSmall),
                                    const Row(
                                      children: [
                                        Icon(Icons.event),
                                        SizedBox(width: 8),
                                        Text("Fecha de fabricación:"),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 32),
                                      child: Text(
                                        _evaluacion.fechaFabricacion != null ?
                                        DateFormat(DateFormatString).format(_evaluacion.fechaFabricacion!) :
                                        "Fecha desconocida",
                                      ),
                                    ),

                                    const SizedBox(height: Dimensions.marginSmall),
                                    const Row(
                                      children: [
                                        Icon(Icons.event_available), // Icono de fecha de puesta en servicio
                                        SizedBox(width: 8), // Espacio entre el icono y el texto
                                        Text("Fecha de puesta en servicio:"),
                                      ],
                                    ),
                                    Text(
                                      _evaluacion.fechaPuestaServicio!= null ?
                                      DateFormat(DateFormatString).format(_evaluacion.fechaPuestaServicio!) :
                                      "Fecha desconocida",
                                    ),

                                    const SizedBox(height: Dimensions.marginSmall),

                                    SizedBox(
                                      height: 200.0,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        physics: const ClampingScrollPhysics(),
                                        itemCount: _imagenes.length, // +1 para el botón "más"
                                        itemBuilder: (BuildContext context, int index) {
                                          return Container(
                                            margin: const EdgeInsets.all(8.0),
                                            width: 200,
                                            height: 200,
                                            child: Image.memory(
                                              _imagenes[index].imagen,
                                              fit: BoxFit.cover,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: Dimensions.marginSmall),
                                  ],
                                ),
                              ),
                            ),
                          ),
                      ),
                      const SizedBox(height: Dimensions.marginMedium),
                      MyButton(
                        adaptableWidth: false,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NuevaEvaluacionPage(evaluacion: _evaluacion, imagenes: _imagenes),
                            ),
                          );
                        },
                        text: "Modificar",
                      ),
                    ],
                  );
                } else if (state is DetallesEvaluacionError) {
                  return Text("Error: ${state.errorMessage}"); // Mensaje de error
                } else {
                  return const SizedBox();
                }
              },
            ),
        )
      );
  }
}
