import 'dart:io';

import 'package:evaluacionmaquinas/features/presentation/cubit/preguntas_cubit.dart';
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
import 'my_home_page.dart';



class TerminarPage extends StatefulWidget {

  final EvaluacionDetailsDataModel evaluacion;
  final List<ImagenDataModel> imagenes;
  final String pathFichero;
  const TerminarPage({super.key, required this.pathFichero,  required this.evaluacion, required this.imagenes });

  @override
  _TerminarPageState createState() => _TerminarPageState();
}

class _TerminarPageState extends State<TerminarPage> {

  Future<void> _sharePdf() async {
    File? file = await checkIfFileExistAndReturnFile(widget.evaluacion.ideval);

    // Verifica si el archivo existe
    if (file != null) {
      PdfHelper.sharePdf(widget.evaluacion.ideval, widget.evaluacion.nombreMaquina, file);
    } else {
      Utils.showMyOkDialog(context, S.of(context).error, S.of(context).errorSharingPdf, () => null);
    }
  }

  Future<void> _savePdf() async {
    PdfHelper.savePdf(widget.evaluacion.ideval, widget.evaluacion.nombreMaquina);
  }

  void _onQRPressed() {
    setState(() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return MyQrDialog(
            qrData: QRPage + widget.evaluacion.ideval.toString(),
            nombreMaquina: widget.evaluacion.nombreMaquina,
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {


    return DefaultTabController(
      length: 2,
      child: SafeArea(
          child:
          Scaffold(
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white, semanticLabel: S.of(context).semanticlabelBack),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              title: Text(
                S.of(context).evaluationFinished,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: Dimensions.titleTextSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            body: Column(
              children: [
                Center(
                  child: TabBar(
                    indicator: CircleTabIndicator(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      radius: 4,
                    ),
                    labelColor: Theme.of(context).colorScheme.primaryContainer,
                    dividerColor: Colors.transparent,
                    isScrollable: false, // Hace que los tabs estén centrados
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
                      TabEvaluacion(evaluacion: widget.evaluacion, imagenes: widget.imagenes),
                      TabPdf(
                        filePath: widget.pathFichero,
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(Dimensions.marginMedium),
                  child: MyButton(
                    adaptableWidth: false,
                    onTap: () {

                      //Limpiar los datos del cubit de preguntas
                      final preguntasCubit = context.read<PreguntasCubit>();
                      preguntasCubit.clearCache();

                      Navigator.push(
                        context,
                        MaterialPageRoute(

                          builder: (context) => const MyHomePage(),
                        ),
                      );
                    },
                    text: S.of(context).finish,
                  ),
                ),
              ],
            ),
            floatingActionButton: FloatingButtons(
              onSharePressed: () async {
                _sharePdf();
              },
              onDownloadPressed: () {
                _savePdf();
              },
              onQRPressed: () {
                _onQRPressed();
              },
            ),
          )
      ),
    );
  }
}
