import 'dart:io';
import 'dart:math';

import 'package:evaluacionmaquinas/theme/dimensions.dart';
import 'package:evaluacionmaquinas/utils/Utils.dart';
import 'package:evaluacionmaquinas/utils/almacenamiento.dart';
import 'package:evaluacionmaquinas/utils/pdf.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:share_plus/share_plus.dart';

import '../components/circle_tab_indicator.dart';
import '../components/my_button.dart';
import '../components/tabs/tab_evaluacion.dart';
import '../components/tabs/tab_pdf.dart';
import '../cubit/detalles_evaluacion_cubit.dart';
import '../cubit/preguntas_cubit.dart';
import '../generated/l10n.dart';
import '../modelos/evaluacion_details_dm.dart';
import '../modelos/imagen_dm.dart';
import '../repository/repositorio_db_supabase.dart';
import '../utils/Constants.dart';
import 'nueva_evaluacion_page.dart';

class DetalleEvaluacionPage extends StatefulWidget {
  final int idEvaluacion;

  const DetalleEvaluacionPage({super.key, required this.idEvaluacion});

  @override
  _DetalleEvaluacionPageState createState() => _DetalleEvaluacionPageState();
}

class _DetalleEvaluacionPageState extends State<DetalleEvaluacionPage> {
  late EvaluacionDetailsDataModel _evaluacion;
  late List<ImagenDataModel> _imagenes;
  AccionesPdfChecklist? _accion;


  Future<void> _sharePdf() async {
    File? file = await checkIfFileExistAndReturnFile(_evaluacion.ideval);

    if (file != null) {
      PdfHelper.sharePdf(_evaluacion.ideval, file);
    } else {
      _accion = AccionesPdfChecklist.compartir;
      BlocProvider.of<DetallesEvaluacionCubit>(context).generatePdf(context, _evaluacion);
    }
  }

  Future<void> _savePdf() async {
    File? file = await checkIfFileExistAndReturnFile(_evaluacion.ideval);

    if (file != null) {
      PdfHelper.savePdf(_evaluacion.ideval);
    } else {
      _accion = AccionesPdfChecklist.guardar;
      BlocProvider.of<DetallesEvaluacionCubit>(context).generatePdf(context, _evaluacion);
    }
  }

  Future<String?> _checkIfFileExist() async { //TODO LA SOLUCION VA A SER METER LA GENERACION DEL PDF EN EL BLOC BUILDER Y RECARGAR TODO!!!
    final RepositorioDBSupabase repositorio;
    File? file = await checkIfFileExistAndReturnFile(_evaluacion.ideval);
    if(file != null){
      return file.path;
    }else{
      return null;

    }
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<DetallesEvaluacionCubit>(context).getDetallesEvaluacion(context, widget.idEvaluacion);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text("Detalles de la evaluación", style: Theme.of(context).textTheme.titleMedium),
      ),
      body: BlocBuilder<DetallesEvaluacionCubit, DetallesEvaluacionState>(
        builder: (context, state) {
          if (state is DetallesEvaluacionLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is DetallesEvaluacionLoaded) {
            _evaluacion = state.evaluacion;
            _imagenes = state.imagenes;
            return _buildView();
          } else if (state is DetallesEvaluacionError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(Dimensions.marginMedium),
                child: Text(state.errorMessage),
              ),
            );
          } else if (state is DetallesEvaluacionPdfGenerated) {
            return _buildView();
          } else if(state is DetallesEvaluacionPdfError){
            return const SizedBox();
          }else{
            return const SizedBox();
          }
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [

          FloatingActionButton(
            heroTag: "btnShare",
            onPressed: () async {
              _sharePdf();
            },
            shape: const CircleBorder(),
            backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
            foregroundColor: Theme.of(context).colorScheme.onSurface,
            child: const Icon(Icons.share),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: "btnDownload",
            onPressed: () {
              _savePdf();
            },
            shape: const CircleBorder(),
            backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
            foregroundColor: Theme.of(context).colorScheme.onSurface,
            child: const Icon(Icons.download),
          ),
          const SizedBox(height:70),
        ],
      ),
    );
  }

  Widget _buildView() {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Center(
            child: TabBar(
              indicator: CircleTabIndicator(
                color: Theme.of(context).colorScheme.primaryContainer,
                radius: 4,
              ),
              labelColor: Theme.of(context).colorScheme.primaryContainer,
              dividerColor: Colors.transparent,
              isScrollable: false,
              labelPadding: const EdgeInsets.only(left: 20, right: 20),
              tabs: [
                Tab(text: S.of(context).summary),
                Tab(text: S.of(context).pdf),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                TabEvaluacion(evaluacion: _evaluacion, imagenes: _imagenes),
                FutureBuilder<String?>(
                  future: _checkIfFileExist(),  //TODO: SI PDF NO EXISTE, USAR UN BLOCBUILDER CON PREGUNAS CUBIT
                  builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
                    if (kDebugMode) {
                      print("marta snapshot ${snapshot.connectionState}");
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (snapshot.hasData && snapshot.data != null) {
                      return TabPdf(
                        filePath: snapshot.data!,
                      );
                    } else {
                      return Container(
                        color: Theme.of(context).colorScheme.onBackground,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Aún no se ha generado el PDF en este dispositivo"),
                              const SizedBox(height: Dimensions.marginMedium),
                              MyButton(
                                adaptableWidth: true,
                                onTap: () {
                                  _accion = null;
                                  BlocProvider.of<DetallesEvaluacionCubit>(context).generatePdf(context, _evaluacion);
                                },
                                text: "Generar",
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(Dimensions.marginMedium),
            child: MyButton(
              adaptableWidth: false,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NuevaEvaluacionPage(
                      evaluacion: _evaluacion,
                      imagenes: _imagenes,
                    ),
                  ),
                );
              },
              text: S.of(context).modify,
            ),
          ),
        ],
      ),
    );
  }
}

