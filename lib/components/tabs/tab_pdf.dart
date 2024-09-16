import 'package:evaluacionmaquinas/components/my_button.dart';
import 'package:evaluacionmaquinas/theme/dimensions.dart';
import 'package:evaluacionmaquinas/utils/pdf.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'dart:async';


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
    return Stack(
      children: <Widget>[
        Container(
          color: Theme.of(context).colorScheme.onBackground,
          child: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height, // Ajusta la altura según el contenido
              child: PDFView(
                filePath: widget.filePath,
                enableSwipe: true,
                swipeHorizontal: true,
                autoSpacing: false,
                pageFling: false,
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
      ],
    );
  }
}
