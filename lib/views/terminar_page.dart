import 'dart:io';

import 'package:evaluacionmaquinas/utils/Utils.dart';
import 'package:evaluacionmaquinas/utils/almacenamiento.dart';
import 'package:evaluacionmaquinas/utils/pdf.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:evaluacionmaquinas/components/my_button.dart';
import 'package:evaluacionmaquinas/views/my_home_page.dart';
import 'package:evaluacionmaquinas/components/circle_tab_indicator.dart';
import 'package:evaluacionmaquinas/theme/dimensions.dart';

import '../components/tabs/tab_evaluacion.dart';
import '../components/tabs/tab_pdf.dart';
import '../generated/l10n.dart';
import '../modelos/evaluacion_details_dm.dart';
import '../modelos/imagen_dm.dart'; // Importa el archivo generado

class TerminarPage extends StatefulWidget {

  final EvaluacionDetailsDataModel evaluacion;
  final List<ImagenDataModel> imagenes;
  final String pathFichero;
  const TerminarPage({super.key, required this.pathFichero,  required this.evaluacion, required this.imagenes });

  @override
  _TerminarPageState createState() => _TerminarPageState();
}

class _TerminarPageState extends State<TerminarPage> {
  final PageController _pageController = PageController(initialPage: 0);

  //TODO ESTA PAGINA NECESITA DETALLES EVALUACION Y PREGUNTAS

  @override
  Widget build(BuildContext context) {
 
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
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
                  color: Theme.of(context).colorScheme.onPrimary,
                  radius: 4,
                ),
                labelColor: Theme.of(context).colorScheme.onPrimary,
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
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: "btnShare",
              onPressed: () async {
                File? file = await checkIfFileExistAndReturnFile(widget.evaluacion.ideval);

                // Verifica si el archivo existe
                if (file != null) {
                  PdfHelper.sharePdf(widget.evaluacion.ideval, file);
                } else {
                  Utils.showMyOkDialog(context, "Error", "Se ha producido un error al compartir el pdf", () => null);
                }
              },
              shape: const CircleBorder(),
              child: const Icon(Icons.share),
            ),
            const SizedBox(height: 10), // Espacio entre botones
            FloatingActionButton(
              heroTag: "btnDownload",
              onPressed: () {
                PdfHelper.savePdf(widget.evaluacion.ideval);
              },
              shape: const CircleBorder(),
              child: const Icon(Icons.download),
            ),
          ],
        ),
      ),
    );
  }
}
