import 'dart:ffi';
import 'dart:io';
import 'package:evaluacionmaquinas/modelos/categoria_pregunta_dm.dart';
import 'package:evaluacionmaquinas/modelos/evaluacion_details_dm.dart';
import 'package:evaluacionmaquinas/modelos/evaluacion_list_dm.dart';
import 'package:evaluacionmaquinas/modelos/pregunta_dm.dart';
import 'package:evaluacionmaquinas/repository/repositorio_db_supabase.dart';
import 'package:evaluacionmaquinas/theme/dimensions.dart';
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

  static const double tamanoFuente = 9;
  static const double tamanoFuenteCabera = 11;
  static const double padding = 5;
  static PdfColor yellowColor = PdfColor.fromHex('EEE2BC');

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
  static Future<void> savePdf(int idEval, String nombreMaquina) async {

    // Obtén la ruta del archivo en el almacenamiento interno
    String internalPath = await almacenamiento.getNameFicheroAlmacenamientoLocal(idEval);

    // Asigna un nuevo nombre al archivo PDF para seguridad
    String newFileName = getNamePdf(nombreMaquina);

    // Almacena el archivo con el nuevo nombre en el destino elegido
    await almacenamiento.almacenaEnDestinoElegido(internalPath, newFileName);
  }

  ///share pdf from internal extorage
  static Future<void> sharePdf(int idEval, String nombreMaquina, File file) async {
    // Obtén el directorio temporal
    final directory = await getTemporaryDirectory();

    // Crea una nueva ruta con el nombre modificado
    final newFilePath = '${directory.path}/${getNamePdf(nombreMaquina)}.pdf';

    // Copia el archivo a la nueva ubicación con el nuevo nombre
    final newFile = await file.copy(newFilePath);

    // Crea el XFile a partir del nuevo archivo
    XFile xFile = XFile(newFile.path);

    // Comparte el archivo usando share_plus
    await Share.shareXFiles([xFile], text: '');
  }

  ///Funcion para obtener el nombre del pdf a partir del nombre de la máquina
  static String getNamePdf(String nombreMaquina) {
    // Reemplaza los espacios por guiones bajos
    String nombreConGuionesBajos = nombreMaquina.replaceAll(' ', '_');

    // Trunca el nombre si es necesario
    String truncatedNombreMaquina = nombreConGuionesBajos.length > 10
        ? nombreConGuionesBajos.substring(0, 10)
        : nombreConGuionesBajos;

    return truncatedNombreMaquina;
  }


  ///Método que genera la cabecera del pdf
  static Widget _buildCabeceraPaginaChecklist(
      Context context, MemoryImage imagenLogo) {
    return pw.Table(children: [
      pw.TableRow(children: [
        pw.Image(imagenLogo, width: 100, height: 100),
        pw.SizedBox(width: 20),
        pw.Column(
          children: [
            pw.Align(
              alignment: pw.AlignmentDirectional.centerEnd, // Alineación hacia el final (derecha)
              child: Text(
                'LISTA DE COMPROBACIÓN DE SEGURIDAD EN EQUIPOS DE TRABAJO Y EN SU UTILIZACIÓN RD 1215/97',
                style: TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
                textAlign: TextAlign.end
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

    return [
      //pw.SizedBox(height: 20),

      // Invocar la función para construir la tabla de la evaluación
      // Invocar la función para construir la tabla de la evaluación
      ..._dameTablaDatos(evaluacion, preguntas, respuestas),



      // Aquí se construyen las filas del checklist
      ..._dameTablaPreguntas(preguntas, respuestas, categorias),
    ];
  }

  /******************************** GENERAR TABLA *******************************************************/

  static List<pw.Widget> _dameTablaDatos(EvaluacionDetailsDataModel evaluacion, List<PreguntaDataModel> preguntas, List<OpcionRespuestaDataModel> respuestas) {
    // Agrupar las preguntas por idCategoria
    List<PreguntaDataModel> preguntasIdentificacion = [];
    for (var pregunta in preguntas) {
      if (pregunta.idCategoria == 1) {
        preguntasIdentificacion.add(pregunta);
      }
    }

    return [
      pw.Table(
        columnWidths: {
          0: const pw.FlexColumnWidth(4),
          1: const pw.FlexColumnWidth(2),
        },
        border: pw.TableBorder.all(width: 1, color: PdfColors.black),
        children: [
          pw.TableRow(children: [
            _buildTableCellWithValue("Centro:", evaluacion.nombreCentro),
            _buildTableCellWithValue("Fecha:", DateFormat(DateFormatString).format(evaluacion.fechaRealizacion)),
          ]),
        ],
      ),


      pw.Table(
        border: pw.TableBorder.all(width: 1, color: PdfColors.black),
        children: [
          pw.TableRow(
            children: [
              _buildTableCellTitle("IDENTIFICACIÓN DEL EQUIPO DE TRABAJO/MÁQUINA:", TextAlign.center) //TODO CATEGORIA 1
            ],
            decoration: pw.BoxDecoration(color: yellowColor),
          ),
        ],
      ),


      pw.Table(
        columnWidths: {
          0: const pw.FlexColumnWidth(1),
          1: const pw.FlexColumnWidth(1),
        },
        border: pw.TableBorder.all(width: 1, color: PdfColors.black),
        children: [
          pw.TableRow(children: [
            _buildTableCellWithValue("Denominación:", evaluacion.nombreMaquina),
          ]),
          pw.TableRow(children: [
            _buildTableCellWithValue("Fabricante:", evaluacion.fabricante ?? 'N/A'),
            _buildTableCellWithValue("Nº de Fabricación/Nº de serie:", evaluacion.numeroSerie),
          ]),
          pw.TableRow(children: [
            _buildTableCellWithValue(
                "Fecha de Fabricación:",
                evaluacion.fechaFabricacion != null
                    ? DateFormat(DateFormatString).format(evaluacion.fechaFabricacion!)
                    : 'N/A'
            ),
            _buildTableCellWithValue(
                "Fecha de puesta en servicio:",
                evaluacion.fechaPuestaServicio != null
                    ? DateFormat(DateFormatString).format(evaluacion.fechaPuestaServicio!)
                    : 'N/A'
            ),
          ]),


          ...preguntasIdentificacion.map((pregunta) => pw.TableRow(
              children: [
                _buildTableCellQuestion(respuestas, pregunta),
                _buildTableCellWithValue(
                    "Observaciones:",
                    pregunta.observaciones ?? ""
                ),
              ]
          )),


        ],
      ),
    ];
  }

  static pw.Widget _buildTableCellTitle(String label, TextAlign textAlign) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(padding),

      child: pw.Text(
        label,
        style: pw.TextStyle(fontSize: tamanoFuenteCabera, fontWeight: pw.FontWeight.bold),
        textAlign: textAlign,
      ),
    );
  }

  static pw.Widget _buildTableCell(String label, TextAlign textAlign) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(padding),

      child: pw.Text(
        label,
        style: pw.TextStyle(fontSize: tamanoFuente, fontWeight: pw.FontWeight.normal),
        textAlign: textAlign,
      ),
    );
  }

  static pw.Widget _buildTableCellWithValue(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(padding),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start, // Alinea el contenido en la parte superior
        children: [
          // Usamos un Column para mantener el label en la parte superior
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start, // Alinea el texto del label a la izquierda
            children: [
              pw.Text(
                label,
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: tamanoFuente),
              ),
            ],
          ),
          // Espaciado entre el label y el value
          pw.SizedBox(width: Dimensions.marginMedium),
          // El texto del value ocupará el espacio restante
          pw.Expanded(
            child: pw.Text(
              value,
              style: const pw.TextStyle(fontSize: tamanoFuente),
              softWrap: true,  // Permite que el texto se ajuste si es muy largo.
              textAlign: pw.TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }



  static pw.Widget _buildTableCellQuestion(List<OpcionRespuestaDataModel> respuestas, PreguntaDataModel pregunta) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(padding),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
              pregunta.pregunta,
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: tamanoFuente),
              textAlign: pw.TextAlign.start,
          ),
          _buildAnswersRow(respuestas, pregunta)
        ],
      ),
    );
  }

  static pw.Widget _buildAnswersRow(List<OpcionRespuestaDataModel> respuestas, PreguntaDataModel pregunta) {
    return pw.Padding(
        padding: const pw.EdgeInsets.all(padding),
        child:       pw.Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              for (var respuesta in respuestas)
                pw.Row(
                    children: [
                      pw.Text(
                        respuesta.opcion,
                        style: const pw.TextStyle(fontSize: tamanoFuenteCabera),
                      ),
                      pw.SizedBox(width: padding),
                      pw.Checkbox(
                        activeColor: PdfColors.black,
                        checkColor: PdfColors.white,
                        width: 10,
                        height: 10,
                        name: '${pregunta.idpregunta}${respuesta.idopcion}',
                        value: (pregunta.idRespuestaSeleccionada == respuesta.idopcion),
                      ),
                    ]
                )
            ]
        )
    );
  }

  /// *********************** FIN TABLA **********************

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

  static List<pw.Widget> _dameTablaPreguntas(
      List<PreguntaDataModel> preguntas,
      List<OpcionRespuestaDataModel> respuestas,
      List<CategoriaPreguntaDataModel> todasLasCategorias,
      ) {

    List<CategoriaPreguntaDataModel> categorias = todasLasCategorias.where((categoria) => categoria.idcat != 1).toList();

    // Agrupar las preguntas por idCategoria, excluyendo las de idCategoria == 1
    Map<int?, List<PreguntaDataModel>> preguntasPorCategoria = {};
    for (var pregunta in preguntas) {
      if (pregunta.idCategoria == 1) {
        continue; // Omitir preguntas con idCategoria 1
      }

      if (preguntasPorCategoria.containsKey(pregunta.idCategoria)) {
        preguntasPorCategoria[pregunta.idCategoria]!.add(pregunta);
      } else {
        preguntasPorCategoria[pregunta.idCategoria] = [pregunta];
      }
    }

    // Ordenar las categorías por su id
    categorias.sort((a, b) => a.idcat.compareTo(b.idcat));

    return [
      pw.Table(
        border: pw.TableBorder.all(width: 1, color: PdfColors.black),
        children: [
          pw.TableRow(
            children: [
              _buildTableCellTitle("REQUISITOS MÍNIMOS DE SEGURIDAD", TextAlign.center) //TODO CATEGORIA 1
            ],
            decoration: pw.BoxDecoration(color: yellowColor),
          ),
        ],
      ),

      ...categorias.expand((categoria) {
        var preguntasDeLaCategoria =
            preguntasPorCategoria[categoria.idcat] ?? [];

        // Título de la categoría + las preguntas de esa categoría
        return [
          pw.Table(
            border: pw.TableBorder.all(width: 1, color: PdfColors.black),
            children: [
              pw.TableRow( //FILA DE TITULO DE LA CATEGORIA
                children: [
                  _buildTableCellTitle("${categoria.idcat - 1}. ${categoria.categoria}", TextAlign.left),
                ],
                decoration: pw.BoxDecoration(color: yellowColor),
              ),
            ],
          ),
          // Fila de título de la categoría

          // Filas de preguntas
          ...preguntasDeLaCategoria.expand((pregunta) {
            return [
              pw.Table(
                columnWidths: {
                  0: const pw.FlexColumnWidth(3),
                  1: const pw.FlexColumnWidth(1),
                },
                border: pw.TableBorder.all(width: 1, color: PdfColors.black),
                children: [
                  pw.TableRow(
                    children: [
                      _buildTableCell(
                        pregunta.pregunta,
                        TextAlign.left
                      ),
                      _buildAnswersRow(respuestas, pregunta),
                    ],
                  ),
                ],
              ),
            ];
          }).toList(),
        ];
      }).toList(),
    ];
  }
  
  //TODO OBSERVACIONES DEBERIA SER UNA CELDA EDITABLE??
  static Widget _dameCeldaEditableTabla(
      String idTextField,
      String texto,
      {int? maxLong = 200, double altura = 30, double anchura = 110}
      ) {
    return Padding(
      padding: const EdgeInsets.all(padding),
      child: pw.TextField(
          name: idTextField,
          value: texto,
          maxLength: maxLong,
          height: altura,
          width: anchura,
          textStyle: const pw.TextStyle(fontSize: tamanoFuente)),
    );
  }

}
