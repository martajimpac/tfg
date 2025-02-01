import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/dimensions.dart';
import '../../../core/utils/Constants.dart';
import '../../../core/utils/Utils.dart';
import '../../../core/utils/almacenamiento.dart ';
import '../../../core/utils/pdf.dart';
import '../../../generated/l10n.dart';
import '../../data/models/evaluacion_details_dm.dart';
import '../../data/models/imagen_dm.dart';
import '../components/buttons/floating_buttons.dart';
import '../components/buttons/my_button.dart';
import '../components/circle_tab_indicator.dart';
import '../components/dialog/my_qr_dialog.dart';
import '../components/tabs/tab_evaluacion.dart';
import '../components/tabs/tab_pdf.dart';
import '../cubit/detalles_evaluacion_cubit.dart';
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
  bool _generatingPdf = false;
  bool _isEvaluationLoaded = false;

  Future<void> _sharePdf() async {
    if(_isEvaluationLoaded){
      File? file = await checkIfFileExistAndReturnFile(_evaluacion.ideval);

      if (file != null) {
        PdfHelper.sharePdf(_evaluacion.ideval, _evaluacion.nombreMaquina, file);
      } else {
        _showFileNotGeneratedDialog();
      }
    }
  }

  Future<void> _savePdf() async {
    if(_isEvaluationLoaded){
      File? file = await checkIfFileExistAndReturnFile(_evaluacion.ideval);

      if (file != null) {
        PdfHelper.savePdf(_evaluacion.ideval, _evaluacion.nombreMaquina);
      } else {
        _showFileNotGeneratedDialog();
      }
    }
  }

  void _showFileNotGeneratedDialog() {
    Utils.showMyOkDialog(
      context,
      S.of(context).error,
      S.of(context).notGenerated,
          () {
        Navigator.of(context).pop();
        BlocProvider.of<DetallesEvaluacionCubit>(context).generatePdf(context, _evaluacion);
      },
      buttonText: S.of(context).generate,
    );
  }

  Future<String?> _checkIfFileExist() async {
    File? file = await checkIfFileExistAndReturnFile(_evaluacion.ideval);
    if(file != null){
      return file.path;
    }else{
      return null;

    }
  }

  void _onQRPressed() {
    if(_isEvaluationLoaded){
      setState(() {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return MyQrDialog(
              qrData: QRPage + _evaluacion.ideval.toString(),
              nombreMaquina: _evaluacion.nombreMaquina,
            );
          },
        );
      });
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
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(S.of(context).evaluationsDetailsTitle, style: Theme.of(context).textTheme.titleMedium),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(child:
            BlocBuilder<DetallesEvaluacionCubit, DetallesEvaluacionState>(
              builder: (context, state) {
                if (state is DetallesEvaluacionLoading) {
                  _isEvaluationLoaded = false;
                  return Center(
                    child: Padding(
                        padding: const EdgeInsets.all(Dimensions.marginMedium),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (_generatingPdf) ...[
                              Text(S.of(context).generatingPdf),
                              const SizedBox(height: Dimensions.marginMedium),
                            ],
                            const CircularProgressIndicator(),
                          ],
                        )
                    ),
                  );
                } else if (state is DetallesEvaluacionLoaded) {
                  _isEvaluationLoaded = true;
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
                  _isEvaluationLoaded = true;
                  return _buildView();
                } else if(state is DetallesEvaluacionPdfError){

                  return const SizedBox();
                }else{
                  return const SizedBox();
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton:  FloatingButtons(
        onQRPressed: _onQRPressed,
        onSharePressed: _sharePdf,
        onDownloadPressed: _savePdf,
      )
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
              physics: const NeverScrollableScrollPhysics(),
              children: [
                TabEvaluacion(evaluacion: _evaluacion, imagenes: _imagenes),
                FutureBuilder<String?>(
                  future: _checkIfFileExist(),
                  builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Text('${S.of(context).error}: ${snapshot.error}');
                    } else if (snapshot.hasData && snapshot.data != null) {
                      return TabPdf(
                        filePath: snapshot.data!,
                      );
                    } else {
                      return Container(
                        color: Theme.of(context).colorScheme.surface,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Text(
                                    S.of(context).notGenerated,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              const SizedBox(height: Dimensions.marginMedium),
                              MyButton(
                                adaptableWidth: true,
                                onTap: () {
                                  _generatingPdf = true;
                                  BlocProvider.of<DetallesEvaluacionCubit>(context).generatePdf(context, _evaluacion);
                                },
                                text: S.of(context).generate,
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
            padding: const EdgeInsets.fromLTRB(Dimensions.marginMedium, 0, Dimensions.marginMedium, Dimensions.marginMedium),
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

