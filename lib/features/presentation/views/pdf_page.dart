import 'dart:io';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../generated/l10n.dart';

class PdfPage extends StatefulWidget {
  final String filePath;

  const PdfPage({super.key, required this.filePath});

  @override
  _PdfPageState createState() => _PdfPageState();
}

class _PdfPageState extends State<PdfPage> {
  bool isReady = false;
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            SfPdfViewer.file(
              File(widget.filePath),
              onDocumentLoaded: (details) {
                setState(() {
                  isReady = true;
                });
              },
              onDocumentLoadFailed: (details) {
                setState(() {
                  errorMessage = details.error;
                });
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

            Positioned(
              top: 16.0,
              right: 16.0,
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                tooltip: S.of(context).semanticlabelClose,
                child: Icon(Icons.close, semanticLabel: S.of(context).semanticlabelClose),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
