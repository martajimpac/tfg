import 'dart:io';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../../core/theme/dimensions.dart';
import '../../../../generated/l10n.dart';
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
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  String errorMessage = '';
  bool isReady = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Dimensions.marginMedium),
      child: Stack(
        children: <Widget>[
          // Contenedor para el PDFView con bordes redondeados
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onPrimary,
              borderRadius: BorderRadius.circular(Dimensions.cornerRadius),
            ),
            clipBehavior: Clip.hardEdge,
            child: SfPdfViewer.file(
              File(widget.filePath),
              key: _pdfViewerKey,
              onDocumentLoaded: (PdfDocumentLoadedDetails details) {
                setState(() {
                  isReady = true;
                });
              },
              onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
                setState(() {
                  errorMessage = details.error;
                });
                print(errorMessage);
              },
            ),
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

          // Botón flotante para ampliar el PDF
          Positioned(
            top: Dimensions.marginSmall,
            right: Dimensions.marginSmall,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PdfPage(filePath: widget.filePath),
                  ),
                );
              },
              tooltip: S.of(context).semanticlabelExpand,
              child: Icon(Icons.zoom_in, semanticLabel: S.of(context).semanticlabelExpand),
            ),
          ),
        ],
      ),
    );
  }
}
