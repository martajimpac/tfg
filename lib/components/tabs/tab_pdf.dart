
import 'package:evaluacionmaquinas/theme/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'dart:async';

import '../../views/pdf_page.dart';

class TabPdf extends StatefulWidget {
  final String filePath;

  const TabPdf({
    super.key,
    required this.filePath,
  });

  @override
  _TabPdfState createState() => _TabPdfState();
}

class _TabPdfState extends State<TabPdf> {
  final Completer<PDFViewController> _controller = Completer<PDFViewController>();
  int pages = 0;
  bool isReady = false;
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Dimensions.marginMedium),
      child: Stack(
        children: <Widget>[
          // Container para el PDFView con bordes redondeados
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onBackground,
              borderRadius: BorderRadius.circular(Dimensions.cornerRadius), // Ajusta el radio según tus necesidades
            ),
            clipBehavior: Clip.hardEdge, // Asegura que el contenido se recorte en los bordes redondeados
            child: PDFView(
              filePath: widget.filePath,
              enableSwipe: true,
              swipeHorizontal: false,
              autoSpacing: true,
              pageFling: true,
              onRender: (_pages) {
                setState(() {
                  pages = _pages!;
                  isReady = true;
                });
              },
              onError: (error) {
                setState(() {
                  errorMessage = error.toString();
                });
                print(errorMessage);
              },
              onPageError: (page, error) {
                setState(() {
                  errorMessage = '$page: ${error.toString()}';
                });
                print(errorMessage);
              },
              onViewCreated: (PDFViewController pdfViewController) {
                _controller.complete(pdfViewController);
              },
              onPageChanged: (int? page, int? total) {
                print('page change: $page/$total');
              },
            ),
          ),
          if (errorMessage.isNotEmpty)
            Container(
              color: Theme.of(context).colorScheme.onBackground,
              child: const Center(
                child: Text("Ha ocurrido un error al cargar el PDF"),
              ),
            ),
          if (!isReady && errorMessage.isEmpty)
            const Center(child: CircularProgressIndicator()),

          // Botón flotante para ampliar el PDF
          Positioned(
            top: Dimensions.marginSmall,
            right: Dimensions.marginSmall,
            child: FloatingActionButton(
              onPressed: () {
                // Navegar a la página de ampliación del PDF
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PdfPage(filePath: widget.filePath),
                  ),
                );
              },
              tooltip: 'Ampliar PDF',
              child: const Icon(Icons.zoom_in),
            ),
          ),
        ],
      ),
    );
  }
}
