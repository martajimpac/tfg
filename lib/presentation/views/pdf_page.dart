import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'dart:async';

import '../../core/generated/l10n.dart';

class PdfPage extends StatefulWidget {
  final String filePath;

  const PdfPage({super.key, required this.filePath});

  @override
  _PdfPageState createState() => _PdfPageState();
}

class _PdfPageState extends State<PdfPage> {
  final Completer<PDFViewController> _controller = Completer<PDFViewController>();
  int pages = 0;
  bool isReady = false;
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            PDFView(
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
            if (errorMessage.isNotEmpty)
              Container(
                color: Theme.of(context).colorScheme.onPrimary,
                child: Center(
                  child: Text(S.of(context).errorChargingPdf),
                ),
              ),
            if (!isReady && errorMessage.isEmpty)
              const Center(child: CircularProgressIndicator()),

            // Botón flotante para cerrar el PDF
            Positioned(
              top: 16.0,
              right: 16.0,
              child: FloatingActionButton(
                onPressed: () {
                  // Navegar a la página de ampliación del PDF
                  Navigator.of(context).pop();
                },
                tooltip: 'Cerrar PDF',
                child: const Icon(Icons.close, semanticLabel: "Cerrar"),
              ),
            ),
          ],
        ),
      )
    );
  }
}
