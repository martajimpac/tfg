import 'dart:io';
import 'package:evaluacionmaquinas/modelos/categoria_pregunta_dm.dart';
import 'package:evaluacionmaquinas/modelos/evaluacion_details_dm.dart';
import 'package:evaluacionmaquinas/modelos/evaluacion_list_dm.dart';
import 'package:evaluacionmaquinas/modelos/pregunta_dm.dart';
import 'package:evaluacionmaquinas/repository/repositorio_db_supabase.dart';
import 'package:evaluacionmaquinas/utils/Utils.dart';
import 'package:file_picker/file_picker.dart';

import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import '../modelos/opcion_respuesta_dm.dart';
import '../repository/repositorio_db.dart';
import 'Constants.dart';
import 'almacenamiento.dart'  as almacenamiento;




///Clase que se encarga de generar las diferentes ficheros con los datos de la inspección inicial

class PdfHelper {

  static Future<String?> generarInformePDF(
      EvaluacionDetailsDataModel evaluacion,
      List<PreguntaDataModel> preguntas,
      List<OpcionRespuestaDataModel> respuestas,
      List<CategoriaPreguntaDataModel> categorias
      ) async
  {

    final log = Logger();

    late final String? pathFicheroAlmacenado;

    log.i('MARTA Se va a generar el informe pdf de la evaluacion ${evaluacion.ideval}');

    try {
      final imagenLogo = MemoryImage(
          (await rootBundle.load('lib/images/gob.jpg'))
              .buffer
              .asUint8List());

      final pdf = pw.Document();

      pdf.addPage(pw.MultiPage(
        maxPages: 100,
        pageFormat: PdfPageFormat.a4,
        header: (pw.Context context) =>
            _buildCabeceraPaginaChecklist(context, imagenLogo),
        build: (pw.Context context) =>
            _buildCuerpoPaginaChecklist(context, preguntas, respuestas, categorias, evaluacion), // Content
        // Center
        footer: (context) => _buildPiePaginaChecklist(context),
      )); // Page*/

      log.e('MARTA HEMOS GENERADO EL PDF SIN ERRORES');

      final bitsPDF = await pdf.save();

      // Guardar el archivo en el almacenamiento interno

      final pathFicheroAlmacenado = await almacenamiento.getNameFicheroAlmacenamientoLocal(evaluacion.ideval);
      final file = File(pathFicheroAlmacenado);
      await file.writeAsBytes(bitsPDF);

      return pathFicheroAlmacenado;
    } catch (e) {
      log.e('MARTA Error al generar el informe PDF: $e');
      return null;
    }
  }

  ///move pdf from internal to external storage
  static savePdf(int idEval) async {

    String internalPath = await almacenamiento.getNameFicheroAlmacenamientoLocal(idEval);
    String fileName = almacenamiento.dameNombrePorDefectoFichero(idEval, TiposFicheros.pdf);
    await almacenamiento.almacenaEnDestinoElegido(internalPath, fileName);
  }

  //share pdf from internal extorage
  static sharePdf(int idEval, File file) async {
    XFile xFile = XFile(file.path);
    // Comparte el archivo usando share_plus
    await Share.shareXFiles([xFile], text: '');
  }

  ///Método que construye el cuerpo de página del informe
  ///Modificable controla si los campos del pdf son editables/modiifcables por el
  ///usuario o no

  ///Método que devuelve una celda de la cabecera de la tabla

  static Widget _dameCeldaCabeceraTabla(
      String texto,
      double tamanoFuenteCabecera,
      TextAlign alineadoTexto,
      double? padding,
      int maxLines) {
    return Padding(
        padding: EdgeInsets.all(padding ?? 5),
        child: pw.Text(
          texto,
          style: pw.TextStyle(
              fontSize: tamanoFuenteCabecera, fontWeight: pw.FontWeight.bold),
          textAlign: alineadoTexto,
          maxLines: maxLines,
        ));
  }


  ///Método que genera el pdf de un chequeo que siga un modelo que no sea el de chequeo inicial de la actividad preventiva de minisdef

  static Widget _buildCabeceraPaginaChecklist(
      Context context, MemoryImage imagenLogo) {
    return pw.Table(children: [
      pw.TableRow(children: [
        pw.Image(imagenLogo, width: 100, height: 100),
        pw.SizedBox(width: 20),
        pw.Column(
          children: [
            pw.Align(
              alignment: pw.Alignment.centerRight, // Alineación hacia el final (derecha)
              child: pw.Text(
                'LISTA DE COMPROBACIÓN DE SEGURIDAD EN EQUIPOS DE TRABAJO Y EN SU UTILIZACIÓN RD 1215/97',
                style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
              ),
            ),
          ],
        ),
      ]),
      pw.TableRow(children: [
        pw.SizedBox(height: 20),
      ]),
    ]);
  }


  static List<Widget> _buildCuerpoPaginaChecklist(
      Context context,
      List<PreguntaDataModel> preguntas,
      List<OpcionRespuestaDataModel> respuestas,
      List<CategoriaPreguntaDataModel> categorias,
      EvaluacionDetailsDataModel evaluacion
      )
  {
    TextAlign alineadoTexto = TextAlign.left;

    double? tamanoFuenteCuerpo = 9;
    double paddingCelda = 5;

    return [
      pw.SizedBox(height: 20),

      // Invocar la función para construir la tabla de la evaluación
      ..._dameTabla(evaluacion, tamanoFuenteCuerpo),

      pw.SizedBox(height: 20), // Espacio entre la tabla y el resto del contenido

      // Aquí se construyen las filas del checklist
      pw.Table(children: [
        ..._dameFilasItemChecklist(preguntas, respuestas, categorias, tamanoFuenteCuerpo, alineadoTexto, paddingCelda),
      ]),
    ];
  }


  static List<pw.Widget> _dameTabla(EvaluacionDetailsDataModel evaluacion, double tamanoFuenteCuerpo) {
    return [
      pw.Table(
        border: pw.TableBorder.all(width: 1, color: PdfColors.black),
        children: [
          pw.TableRow(children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(5),
              child: pw.Text("Centro:", style: pw.TextStyle(fontSize: tamanoFuenteCuerpo)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(5),
              child: pw.Text(evaluacion.nombreCentro, style: pw.TextStyle(fontSize: tamanoFuenteCuerpo)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(5),
              child: pw.Text("Fecha:", style: pw.TextStyle(fontSize: tamanoFuenteCuerpo)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(5),
              child: pw.Text(evaluacion.fechaRealizacion.toString(), style: pw.TextStyle(fontSize: tamanoFuenteCuerpo)),
            ),
          ]),
          pw.TableRow(children: [ //TODO QUIERO MODIFICAR ESTA TABLE ROW PARA QUE NO TENGA COLUMNAS, ES DECIR UNIR TODAS LAS COLUMNAS EN UNA EN ESTA FILA
            pw.Padding(
              padding: const pw.EdgeInsets.all(5),
              child: pw.Text("IDENTIFICACIÓN DEL EQUIPO DE TRABAJO/MÁQUINA:", style: pw.TextStyle(fontSize: tamanoFuenteCuerpo, fontWeight: pw.FontWeight.bold), textAlign: pw.TextAlign.center),
            ),
          ], decoration: const pw.BoxDecoration(color: PdfColors.grey300),),
          pw.TableRow(children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(5),
              child: pw.Text("Denominación:", style: pw.TextStyle(fontSize: tamanoFuenteCuerpo)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(5),
              child: pw.Text(evaluacion.nombreMaquina, style: pw.TextStyle(fontSize: tamanoFuenteCuerpo)),
            ),
          ]),
          pw.TableRow(children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(5),
              child: pw.Text("Fabricante:", style: pw.TextStyle(fontSize: tamanoFuenteCuerpo)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(5),
              child: pw.Text(evaluacion.fabricante ?? 'N/A', style: pw.TextStyle(fontSize: tamanoFuenteCuerpo)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(5),
              child: pw.Text("Nº de Fabricación/Nº de serie:", style: pw.TextStyle(fontSize: tamanoFuenteCuerpo)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(5),
              child: pw.Text(evaluacion.numeroSerie, style: pw.TextStyle(fontSize: tamanoFuenteCuerpo)),
            ),
          ]),
          pw.TableRow(children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(5),
              child: pw.Text("Fecha de Fabricación:", style: pw.TextStyle(fontSize: tamanoFuenteCuerpo)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(5),
              child: pw.Text(
                evaluacion.fechaFabricacion != null
                    ? DateFormat(DateFormatString).format(evaluacion.fechaFabricacion!)
                    : 'N/A', // Texto a mostrar si es null
                style: pw.TextStyle(fontSize: tamanoFuenteCuerpo),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(5),
              child: pw.Text("Fecha de puesta en servicio:", style: pw.TextStyle(fontSize: tamanoFuenteCuerpo)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(5),
              child: pw.Text(
                evaluacion.fechaPuestaServicio != null
                    ? DateFormat(DateFormatString).format(evaluacion.fechaPuestaServicio!)
                    : 'N/A', // Texto a mostrar si es null
                style: pw.TextStyle(fontSize: tamanoFuenteCuerpo),
              ),
            ),
          ]),
        ],
      ),
    ];
  }

  static Widget _buildPiePaginaChecklist(Context context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text('Página ${context.pageNumber}/${context.pagesCount}'),
        ],
      ),
    );
  }

  static List<pw.TableRow> _dameFilasItemChecklist(
      List<PreguntaDataModel> preguntas,
      List<OpcionRespuestaDataModel> respuestas,
      List<CategoriaPreguntaDataModel> categorias,
      double tamanoFuenteCuerpo,
      TextAlign alineadoTexto,
      double paddingCelda,
      ) {
    List<pw.TableRow> celdasItem = [];

    // Agrupar las preguntas por idCategoria
    Map<int?, List<PreguntaDataModel>> preguntasPorCategoria = {};
    for (var pregunta in preguntas) {
      if (preguntasPorCategoria.containsKey(pregunta.idCategoria)) {
        preguntasPorCategoria[pregunta.idCategoria]!.add(pregunta);
      } else {
        preguntasPorCategoria[pregunta.idCategoria] = [pregunta];
      }
    }

    //AÑADIR TITULO CHECKLIST
    celdasItem.add(pw.TableRow(children: [
      pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 10),
        child: pw.Text(
          "REQUISITOS MÍNIMOS DE SEGURIDAD",
          style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
          textAlign: pw.TextAlign.left,
        ),
      ),
    ]));

    // Ordenar las categorías por su id
    categorias.sort((a, b) => a.idcat.compareTo(b.idcat));

    // Recorrer las categorías y agregar las filas correspondientes
    for (var categoria in categorias) {
      // Añadir título de la categoría
      celdasItem.add(pw.TableRow(children: [
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(vertical: 10),
          child: pw.Text(
            categoria.categoria,
            style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
            textAlign: pw.TextAlign.left,
          ),
        ),
      ]));

      // Obtener preguntas de la categoría actual
      var preguntasDeLaCategoria = preguntasPorCategoria[categoria.idcat] ?? [];

      // Añadir las filas de cada pregunta
      for (var pregunta in preguntasDeLaCategoria) {
        celdasItem.add(pw.TableRow(children: [
          pw.SizedBox(height: 20),
        ]));

        celdasItem.add(pw.TableRow(children: [
          pw.Table(
            border: pw.TableBorder.symmetric(
              inside: BorderSide.none,
              outside: const BorderSide(
                width: 1,
                style: BorderStyle.solid,
                color: PdfColor(1, 1, 1),
              ),
            ),
            children: [
              pw.TableRow(
                decoration: pw.BoxDecoration(color: PdfColor.fromHex('EEE2BC')),
                children: [
                  _dameCeldaCabeceraTabla(
                    pregunta.pregunta,
                    11,
                    alineadoTexto,
                    paddingCelda,
                    3,
                  ),
                ],
              ),
              // Espacio en blanco antes de la primera respuesta
              pw.TableRow(children: [pw.SizedBox(height: 10)]),

              // Opciones de respuesta
              for (var respuesta in respuestas)
                pw.TableRow(children: [
                  pw.Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.fromLTRB(10, 2, 10, 2),
                        child: pw.Text(
                          respuesta.opcion,
                          style: const pw.TextStyle(fontSize: 11),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.fromLTRB(20, 2, 10, 2),
                        child: pw.Checkbox(
                          activeColor: PdfColors.black,
                          checkColor: PdfColors.white,
                          width: 10,
                          height: 10,
                          name: '${pregunta.idpregunta}${respuesta.idopcion}',
                          value: (pregunta.idRespuestaSeleccionada == respuesta.idopcion),
                        ),
                      ),
                    ],
                  ),
                ]),
            ],
          ),
        ]));

        // Añadir espacio después de las opciones
        celdasItem.add(pw.TableRow(children: [pw.SizedBox(height: 16)]));

        // Mostrar observaciones si la pregunta las tiene TODO ESTO NO VA
        if (pregunta.tieneObservaciones && pregunta.observaciones != null && pregunta.observaciones!.isNotEmpty) {
          celdasItem.add(pw.TableRow(children: [
            pw.Table(
              border: const pw.TableBorder(
                verticalInside: BorderSide.none,
                horizontalInside: BorderSide.none,
              ),
              columnWidths: {
                0: const FlexColumnWidth(2),
                1: const FlexColumnWidth(7),
              },
              children: [
                pw.TableRow(children: [
                  _dameCeldaCabeceraTabla(
                    'Observaciones:',
                    10,
                    alineadoTexto,
                    5,
                    5,
                  ),
                  _dameCeldaEditableTabla(
                    '${pregunta.idCategoria}-${pregunta.idpregunta}',
                    pregunta.observaciones ?? '',
                    10,
                    alineadoTexto,
                    5,
                  ),
                ]),
              ],
            ),
          ]));
        }
      }
    }

    return celdasItem;
  }


  static Widget _dameCeldaEditableTabla(
      String idTextField,
      String texto,
      double tamanoFuente,
      TextAlign alineadoTexto,
      double? padding,
      {int? maxLong = 200, double altura = 30, double anchura = 110}
      ) {
    return Padding(
      padding: EdgeInsets.all(padding ?? 5),
      child: pw.TextField(
          name: idTextField,
          value: texto,
          maxLength: maxLong,
          height: altura,
          width: anchura,
          textStyle: pw.TextStyle(fontSize: tamanoFuente)),
    );
  }

}
