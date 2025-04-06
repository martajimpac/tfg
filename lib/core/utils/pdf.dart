import 'dart:ffi';
import 'dart:io';


import 'package:flutter/foundation.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:logger/logger.dart';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import '../../features/data/models/categoria_pregunta_dm.dart';
import '../../features/data/models/evaluacion_details_dm.dart';
import '../../features/data/models/opcion_respuesta_dm.dart';
import '../../features/data/models/pregunta_dm.dart';
import '../../features/data/shared_prefs.dart';
import '../theme/dimensions.dart';
import 'Constants.dart';
import 'almacenamiento.dart'  as almacenamiento;




///Clase que se encarga de generar las diferentes ficheros con los datos de la inspección inicial

class PdfHelper {

  static const double tamanoFuente = 9;
  static const double tamanoFuenteCabera = 11;
  static const double padding = 5;
  static const double paddingTitle = 12;
  static const double paddingSubtitle = 5;
  static const double paddingCondition = 2;
  static PdfColor yellowColor = PdfColor.fromHex('EEE2BC');

  /*** Función que genera informe **/
  static Future<String?> generarInformePDF(
      EvaluacionDetailsDataModel evaluacion,
      List<PreguntaDataModel> preguntas,
      List<OpcionRespuestaDataModel> respuestas,
      List<CategoriaPreguntaDataModel> categorias
      ) async
  {

    try {
      final userName = await SharedPrefs.getUserName();

      final imagenLogo = MemoryImage(
          (await rootBundle.load('assets/images/gob.jpg')).buffer.asUint8List());

      final pdf = pw.Document();
      pdf.addPage(pw.MultiPage(
        maxPages: 100,
        pageFormat: PdfPageFormat.a4,
        header: (pw.Context context) =>
            _buildCabeceraPaginaChecklist(context, imagenLogo),
        build: (pw.Context context) =>
            _buildCuerpoPaginaChecklist(userName, context, preguntas, respuestas, categorias, evaluacion), // Content
        // Center
        footer: (context) => _buildPiePaginaChecklist(context),
      )); // Page*/

      final bitsPDF = await pdf.save();

      // Guardar el archivo en el almacenamiento interno
      final pathFicheroAlmacenado = await almacenamiento.getNameFicheroAlmacenamientoLocal(evaluacion.ideval);
      final file = File(pathFicheroAlmacenado);
      await file.writeAsBytes(bitsPDF);

      return pathFicheroAlmacenado;
    } catch (e) {
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
    try {
      Directory directory;

      if (Platform.isWindows) {
        // En Windows, guardamos en Documentos o Escritorio para mejor acceso
        directory = Directory(path.join(
            Platform.environment['USERPROFILE'] ?? '',
            'Documents'
        ));
        if (!await directory.exists()) {
          directory = await getApplicationDocumentsDirectory();
        }
      } else {
        // Para móvil/otros, usamos el directorio temporal
        directory = await getTemporaryDirectory();
      }

      final newFilePath = path.join(directory.path, '${getNamePdf(nombreMaquina)}.pdf');
      final newFile = await file.copy(newFilePath);

      if (Platform.isWindows) {
        // En Windows: Abrir el archivo con la aplicación predeterminada
        await OpenFilex.open(newFile.path);

        // Opcional: Mostrar diálogo con la ruta para compartir manualmente
        await Share.share(
          'PDF generado: $newFilePath',
          subject: 'Compartir PDF',
        );
      } else {
        // Para móvil/otros: Compartir directamente el archivo
        await Share.shareXFiles([XFile(newFile.path)]);
      }
    } catch (e) {
      print('Error al compartir PDF: $e');
      // Puedes lanzar el error o manejarlo según tu aplicación
      rethrow;
    }
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
      String userName,
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
      ..._dameTablaDatos(evaluacion, preguntas, respuestas),

      // Aquí se construyen las filas del checklist
      ..._dameTablaPreguntas(userName, preguntas, respuestas, categorias),
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
              _buildTableCellTitle("IDENTIFICACIÓN DEL EQUIPO DE TRABAJO/MÁQUINA:", TextAlign.center)
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
      padding: const pw.EdgeInsets.all(paddingTitle),

      child: pw.Text(
        label,
        style: pw.TextStyle(fontSize: tamanoFuenteCabera, fontWeight: pw.FontWeight.bold),
        textAlign: textAlign,
      ),
    );
  }

  static pw.Widget _buildTableCellSubtitle(String label, TextAlign textAlign) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(paddingSubtitle),

      child: pw.Text(
        label,
        style: pw.TextStyle(fontSize: tamanoFuenteCabera, fontWeight: pw.FontWeight.bold),
        textAlign: textAlign,
      ),
    );
  }

  static pw.Widget _buildTableCellCondition(String label, TextAlign textAlign) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(paddingCondition),

      child: pw.Text(
        label,
        style: pw.TextStyle(fontSize: tamanoFuente, fontWeight: pw.FontWeight.bold),
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

  static pw.Widget _buildTableCellEditable(String label, String value) {
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
            child: pw.TextField(
              name: "Observaciones",
                value: value,
                textStyle: pw.TextStyle(fontSize: tamanoFuente),
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

  static List<Widget> _dameTablaPreguntas(
      String userName,
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
              _buildTableCellTitle("REQUISITOS MÍNIMOS DE SEGURIDAD", TextAlign.center)
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
              // Fila de título (solo para categorías especiales)
              if (categoria.idcat == idMaqCarga1 || categoria.idcat == idMaqMovil1)
                pw.TableRow(
                  children: [
                    _buildTableCellTitle(
                      getTituloEspecial(categoria),
                      pw.TextAlign.center
                    ),
                  ],
                  decoration: pw.BoxDecoration(color: yellowColor),
                ),

              // Fila de subtítulo
              pw.TableRow(
                children: [
                  _buildTableCellSubtitle(
                    categoria.idcat == idMaqCarga1 ||  categoria.idcat == idMaqCarga2 || categoria.idcat == idMaqMovil1 ||  categoria.idcat == idMaqMovil2
                        ? categoria.categoria
                        : "${categoria.idcat - 1}. ${categoria.categoria}",
                    pw.TextAlign.start,
                  ),
                ],
                decoration: pw.BoxDecoration(
                  color: yellowColor,
                  border: const pw.Border(top: pw.BorderSide.none), // Elimina borde superior para unión visual
                ),
              ),
            ],
          ),
          // Fila de título de la categoría

          // Filas de preguntas
          ...preguntasDeLaCategoria.expand((pregunta) {
            final index = preguntasDeLaCategoria.indexOf(pregunta);
            final widgets = <pw.Widget>[];

            // Insertar condiciones especiales para las preguntas
            if (pregunta.textoAux != null) {
              widgets.add(
                pw.Table(
                  border: pw.TableBorder.all(width: 1, color: PdfColors.black),
                  children: [
                    pw.TableRow(
                      children: [
                        _buildTableCellCondition(
                          pregunta.textoAux ?? "",
                          pw.TextAlign.start,
                        ),
                      ],
                      decoration: pw.BoxDecoration(color: yellowColor),
                    ),
                  ],
                ),
              );
            }

            // Añadir la pregunta normal
            widgets.add(
              pw.Table(
                columnWidths: {
                  0: const pw.FlexColumnWidth(3),
                  1: const pw.FlexColumnWidth(1),
                },
                border: pw.TableBorder.all(width: 1, color: PdfColors.black),
                children: [
                  pw.TableRow(
                    children: [
                      _buildTableCell(pregunta.pregunta, TextAlign.left),
                      _buildAnswersRow(respuestas, pregunta),
                    ],
                  ),
                ],
              ),
            );

            return widgets;
          }),

          //Observaciones
          pw.Table(
            border: pw.TableBorder.all(width: 1, color: PdfColors.black),
            columnWidths: {
              0: pw.FlexColumnWidth(1), // Ancho flexible para la primera columna
              1: pw.FlexColumnWidth(2), // Ancho flexible para la segunda columna
            },
            children: [
              pw.TableRow(children: [
                _buildTableCellWithValue("Observaciones:", categoria.observaciones ?? ""),
              ]),
            ],
          ),


        ];
      }),

      // Agregar el nombre del inspector que ha realizado la evaluación
      pw.SizedBox(height: 10),
      pw.Text(
          'Realizado por: $userName',
          style: pw.TextStyle(fontSize: tamanoFuente, fontWeight: FontWeight.bold)
      ),
    ];
  }




  static String getTituloEspecial(CategoriaPreguntaDataModel categoria) {
    if (categoria.idcat == idMaqCarga1) {
      return "DISPOSICIONES ADICIONALES APLICABLES A MÁQUINAS DE ELEVACIÓN DE CARGAS";
    } else if (categoria.idcat == idMaqMovil1) {
      return "DISPOSICIONES ADICIONALES APLICABLES A MÁQUINAS MÓVILES";
    }
    return "${categoria.idcat - 1}. ${categoria.categoria}";
  }



}
