import 'dart:io';
import 'package:evaluacionmaquinas/features/presentation/views/pdf_page.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/dimensions.dart';
import '../../../generated/l10n.dart';
import '../../../core/utils/almacenamiento.dart' as almacenamiento;

class OfflinePage extends StatefulWidget {
  const OfflinePage({super.key});

  @override
  _OfflinePageState createState() => _OfflinePageState();
}

class _OfflinePageState extends State<OfflinePage> {
  List<File> _pdfFiles = [];

  @override
  void initState() {
    super.initState();
    _loadPdfFiles(); // Cargar los PDFs al iniciar
  }

  Future<void> _loadPdfFiles() async {
    final pdfFiles = await almacenamiento.getPdfFiles();
    setState(() {
      _pdfFiles = pdfFiles;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child:
        Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              S.of(context).pdf,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          body: _pdfFiles.isEmpty
              ? Center(
            child: Text(
              S.of(context).noPdfAvaliable, // Mensaje cuando no hay archivos
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          )
              : ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: _pdfFiles.length,
            itemBuilder: (BuildContext context, int index) {
              final pdf = _pdfFiles[index];
              return Card(
                margin: const EdgeInsets.all(Dimensions.marginSmall),
                elevation: 2,
                color: Theme.of(context).colorScheme.onPrimary,
                child: ListTile(
                  leading: Icon(
                    Icons.picture_as_pdf,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  title: Text(
                    "evaluacion $index",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () {
                    // Navegar a la página de ampliación del PDF
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PdfPage(filePath: pdf.path),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        )
    );
  }
}
