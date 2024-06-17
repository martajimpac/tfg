import 'dart:io';
import 'package:evaluacionmaquinas/modelos/evaluacion_details_dm.dart';
import 'package:evaluacionmaquinas/modelos/pregunta_categoria_dm.dart';
import 'package:evaluacionmaquinas/repository/repositorio_db_supabase.dart';
import 'package:file_picker/file_picker.dart';

import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import '../modelos/opcion_respuesta_dm.dart';
import '../repository/repositorio_db.dart';
import 'almacenamiento.dart'  as almacenamiento;

///Acciones que se pueden realizar con los pdf y execl de los checkist
enum AccionesPdfChecklist { guardar, compartir }

enum AccionesExcelChecklist { guardar, compartir }

enum AccionesPdfChequeoInicial { guardar, compartir }

enum AccionesExcelChequeoInicial { guardar, compartir }

///Clase que se encarga de generar las diferentes ficheros con los datos de la inspección inicial

class GenerarFicherosInforme {
  ///Método estático que genera el informe de cheque inicial en pdf
  static Future<String?> generarInformePDFChequeoInicial(
      int idInspeccion, RepositorioDBSupabase repoDB,
      {AccionesPdfChequeoInicial accion =
          AccionesPdfChequeoInicial.guardar}) async {
    final log = Logger();

    late final String? pathFicheroAlmacenado;

    log.i('Se va a generar el informe pdf de la inspección $idInspeccion');

    try {
      //Solicitamos permisos de almacenamiento si es necesario

      await almacenamiento.permisosAlmacenamiento();

      //Generamos el pdf con los datos de la inspección

      final bitsPDF =
          await generaDocumentPdfModeloMinisdef(idInspeccion, repoDB);

      ///Genero el nombre del fichero (inspeccion-fechahora)
      final nombreFichero = almacenamiento.dameNombrePorDefectoFichero(
          idInspeccion, almacenamiento.TiposFicheros.pdf);

      if (accion == AccionesPdfChequeoInicial.guardar) {
        if (Platform.isAndroid) {
          ///Obtenemos el directorio de almacenamiento externo
          final output = await almacenamiento.damePathAlmacenamientoExterno();
          log.d(
              'El fichero se va a almacenar en el directorio temporal: ${output!.path}');

          /// Se pone como nombre de fichero inspeccion-fechahora

          final file = File('${output.path}/$nombreFichero');

          if (bitsPDF != null) await file.writeAsBytes(bitsPDF);

          log.d('Se ha generado el fichero PDF ${file.path}');

          ///Usamos el plugin FlutterFileDialog para guardar el fichero donde elija el usuario
          final params = SaveFileDialogParams(sourceFilePath: file.path);
          final finalPath = await FlutterFileDialog.saveFile(params: params);

          if (finalPath != null) {
            log.i('El fichero se ha guardado en $finalPath');
            pathFicheroAlmacenado = finalPath;
          } else {
            log.i('El usuario ha cancelado la operación');
            pathFicheroAlmacenado = null;
          }
          //Elimino el archivo creado en temporal
          await almacenamiento.deleteFile(file);
        } else if (Platform.isWindows) {
          String? outputFile = await FilePicker.platform.saveFile(
              dialogTitle: 'Elija la carpeta destino del fichero',
              fileName: nombreFichero);

          if (outputFile == null) {
            log.i('El usuario ha cancelado la operación');
            pathFicheroAlmacenado = null;
          } else {
            pathFicheroAlmacenado = outputFile;
            File returnedFile = File(outputFile);
            await returnedFile.writeAsBytes(bitsPDF!);
          }

          log.i('El fichero se ha guardado en $pathFicheroAlmacenado');
        } else {
          //TODO. Establecer la lógica a seguir para otros sistemas operativos
          throw UnimplementedError('Sólo se admite android y windows');
        }
      } else if (accion == AccionesPdfChequeoInicial.compartir) {
        //La opción de compartir sólo se admite en entornos andrid e Ios
        if (Platform.isAndroid || Platform.isIOS) {
          ///Obtenemos el directorio de almacenamiento externo
          final output = await almacenamiento.damePathAlmacenamientoExterno();
          log.d(
              'El fichero se va a almacenar en el directorio temporal: ${output!.path}');

          /// Se pone como nombre de fichero inspeccion-fechahora

          final file = File('${output.path}/$nombreFichero');

          if (bitsPDF != null) await file.writeAsBytes(bitsPDF);

          log.d('Se ha generado el fichero PDF ${file.path}');

          ///usamo sel plugin de share para comprtir el fichero geneardo
          //TODO. OJO: he cambiado File por XFile ya que compartir File me sale como deprceatged
          await Share.shareXFiles([XFile(file.path)],
              text: 'Informe de la inspección $idInspeccion');
        } else {
          throw UnimplementedError('Sólo se admite compartir en Android e IOS');
        }
      } else {
        throw UnimplementedError('Sólo se admite guardar o compartir');
      }
    } catch (e) {
      log.e('Error al generar el informe PDF: $e');
      return null;
    }
    return pathFicheroAlmacenado;
  }

  ///Se genera el odf para un checlist de un modelo dferenets a de inisial de la actividad definido por el ministerio
  static Future<String?> generarInformePDFChecklist(
      int idInspeccion,
      int idLista,
      AccionesPdfChecklist accion,
      RepositorioDBSupabase repoDB) async {
    final log = Logger();

    late final String? pathFicheroAlmacenado;

    log.i('Se va a generar el informe pdf de la inspección $idInspeccion');

    try {
      //Solicitamos permisos de almacenamiento si es necesario

      await almacenamiento.permisosAlmacenamiento();

      //Generamos el pdf con los datos de la inspección

      final bitsPDF = await generaDocumentPdfChecklist(idLista, repoDB);

      ///Genero el nombre del fichero (inspeccion-fechahora)
      final nombreFichero = almacenamiento.dameNombrePorDefectoFichero(
          idInspeccion, almacenamiento.TiposFicheros.pdf);

      //En función de la acci´n solictada almacenamos o compatimos el pdf generado
      if (accion == AccionesPdfChecklist.guardar) {
        if (Platform.isAndroid) {
          ///Obtenemos el directorio de almacenamiento externo
          final output = await almacenamiento.damePathAlmacenamientoExterno();
          log.d(
              'El fichero se va a almacenar en el directorio temporal: ${output!.path}');

          /// Se pone como nombre de fichero inspeccion-fechahora

          final file = File('${output.path}/$nombreFichero');

          if (bitsPDF != null) await file.writeAsBytes(bitsPDF);

          log.d('Se ha generado el fichero PDF ${file.path}');

          ///Usamos el plugin FlutterFileDialog para guardar el fichero donde elija el usuario
          final params = SaveFileDialogParams(sourceFilePath: file.path);
          final finalPath = await FlutterFileDialog.saveFile(params: params);

          if (finalPath != null) {
            log.i('El fichero se ha guardado en $finalPath');
            pathFicheroAlmacenado = finalPath;
          } else {
            log.i('El usuario ha cancelado la operación');
            pathFicheroAlmacenado = null;
          }
          //Elimino el archivo creado en temporal
          await almacenamiento.deleteFile(file);
        } else if (Platform.isWindows) {
          String? outputFile = await FilePicker.platform.saveFile(
              dialogTitle: 'Elija la carpeta destino del fichero',
              fileName: nombreFichero);

          if (outputFile == null) {
            log.i('El usuario ha cancelado la operación');
            pathFicheroAlmacenado = null;
          } else {
            pathFicheroAlmacenado = outputFile;
            File returnedFile = File(outputFile);
            await returnedFile.writeAsBytes(bitsPDF!);
          }

          log.i('El fichero se ha guardado en $pathFicheroAlmacenado');
        } else {
          //TODO. Establecer la lógica a seguir para otros sistemas operativos
          throw UnimplementedError('Sólo se admite android y windows');
        }
      } else if (accion == AccionesPdfChecklist.compartir) {
        //La opción de compartir sólo se admite en entornos andrid e Ios
        if (Platform.isAndroid || Platform.isIOS) {
          ///Obtenemos el directorio de almacenamiento externo
          final output = await almacenamiento.damePathAlmacenamientoExterno();
          log.d(
              'El fichero se va a almacenar en el directorio temporal: ${output!.path}');

          /// Se pone como nombre de fichero inspeccion-fechahora

          final file = File('${output.path}/$nombreFichero');

          if (bitsPDF != null) await file.writeAsBytes(bitsPDF);

          log.d('Se ha generado el fichero PDF ${file.path}');

          ///usamo sel plugin de share para comprtir el fichero geneardo
          /*await Share.shareFiles([file.path],
              text: 'Informe de la inspección $idInspeccion');*/
          //TODO. Ojo he cambiado compartir file por Xgile porque compartir file stabada drecated
          await Share.shareXFiles([XFile(file.path)],
              text: 'Informe de la inspección $idInspeccion');
        } else {
          throw UnimplementedError('Sólo se admite compartir en Android e IOS');
        }
      } else {
        throw UnimplementedError('Sólo se admite guardar o compartir');
      }
    } catch (e) {
      log.e('Error al generar el informe PDF: $e');
      return null;
    }
    return pathFicheroAlmacenado;
  }

  ///Método que genera el documento pdf
  // modificale controla si los campos del pdf son editables/modiifcables por el
  //usuario o no
  static Future<List<int>?> generaDocumentPdfModeloMinisdef(
      int idInspeccion, RepositorioDBSupabase bbdd,
      {bool modificable = false}) async {
    Logger log = Logger();

    try {
      EvaluacionDetailsDataModel datosPdf =
          await bbdd.getDetallesEvaluacion(idInspeccion);
      final imagenLogo = MemoryImage(
          (await rootBundle.load('lib/images/gob.jpg'))
              .buffer
              .asUint8List());

      final pdf = pw.Document();
      pdf.addPage(pw.MultiPage(
        maxPages: 100,
        pageFormat: PdfPageFormat.a4.landscape,
        header: (pw.Context context) =>
            _buildCabeceraPagina(context, imagenLogo),
        build: (pw.Context context) =>
            _buildCuerpoPagina(context, datosPdf), // Center
        footer: (context) => _buildPiePagina(context),
      )); // Page

      //Solicitamos permisos de almacenamiento si es necesario

      await almacenamiento.permisosAlmacenamiento();
      final bitsPDF = await pdf.save();

      return bitsPDF;
    } on Exception catch (e) {
      log.e('Se ha producdo un error en la ´generación del documento word: $e');
      rethrow;
    }
  }

  ///Método que construye el cuerpo de página del informe
  ///Modificable controla si los campos del pdf son editables/modiifcables por el
  ///usuario o no
  static List<pw.Widget> _buildCuerpoPagina(
      Context context, EvaluacionDetailsDataModel datosEvaluacion) {
    TextAlign alineadoTextoCabecera = TextAlign.center;
    TextAlign alineadoTexto = TextAlign.left;
    double? tamanoFuenteCabecera = 9;
    double? tamanoFuenteCuerpo = 9;
    double paddingCelda = 5;

    return [
      pw.SizedBox(height: 20),
      pw.Table(
          columnWidths: {
            0: const pw.FlexColumnWidth(3),
            1: const pw.FlexColumnWidth(3),
            2: const FlexColumnWidth(2),
            3: const FlexColumnWidth(2),
            4: const FlexColumnWidth(2),
            5: const FlexColumnWidth(2),
            6: const FlexColumnWidth(4),
          },
          border: TableBorder.all(color: PdfColors.black),
          children: [
            pw.TableRow(
                decoration: pw.BoxDecoration(color: PdfColor.fromHex('EEE2BC')),
                children: [
                  _dameCeldaCabeceraTabla(
                      'EXIGENCIA NORMATIVA',
                      tamanoFuenteCabecera,
                      alineadoTextoCabecera,
                      paddingCelda,
                      2),
                  _dameCeldaCabeceraTabla('ACCIÓN', tamanoFuenteCabecera,
                      alineadoTextoCabecera, paddingCelda, 1),
                  _dameCeldaCabeceraTabla(
                      'SITUACIÓN ACTUAL',
                      tamanoFuenteCabecera,
                      alineadoTextoCabecera,
                      paddingCelda,
                      1),
                  _dameCeldaCabeceraTabla('RESPONSABLE', tamanoFuenteCabecera,
                      alineadoTextoCabecera, paddingCelda, 2),
                  _dameCeldaCabeceraTabla(
                      'FECHA PREVISTA',
                      tamanoFuenteCabecera,
                      alineadoTextoCabecera,
                      paddingCelda,
                      2),
                  _dameCeldaCabeceraTabla(
                      'FECHA REALIZADA',
                      tamanoFuenteCabecera,
                      alineadoTextoCabecera,
                      paddingCelda,
                      2),
                  _dameCeldaCabeceraTabla('OBSERVACIONES', tamanoFuenteCabecera,
                      alineadoTextoCabecera, paddingCelda, 2),
                ]),
/*            _dameFilaDatosTabla(
                e, tamanoFuenteCuerpo, alineadoTexto, paddingCelda,
                editable: true)*/

          ]),
    ];
  }

/* static List<Widget> _buildCuerpoPaginaChecklist(
      Context context, List<PreguntaDataModel> datosChecklist) {
    TextAlign alineadoTexto = TextAlign.left;

    double? tamanoFuenteCabecera = 9;
    double? tamanoFuenteCuerpo = 9;
    double paddingCelda = 5;

    ///En los objetos que nos devuelve la base de datos nos encontramos con que
    ///el ítem o pregunta aparece tantas veces como opciones de respuesta se le ofrecen al
    ///usuario. Por ejemplo nos devuelven datos como estos:
    ///"{""idlista"":30,""idmodelo"":4,""idinspeccion"":32,""descripcion_chklst"":""prueba"",""iditem"":85,""nombre_item"":""El acceso al puesto de conducción se realiza de manera segura"",""idopcion"":73,""texto_opcion"":""No procede"",""respuesta_seleccionada"":true,""observacion"":null}"
    ///"{""idlista"":30,""idmodelo"":4,""idinspeccion"":32,""descripcion_chklst"":""prueba"",""iditem"":85,""nombre_item"":""El acceso al puesto de conducción se realiza de manera segura"",""idopcion"":115,""texto_opcion"":""No"",""respuesta_seleccionada"":false,""observacion"":null}"
    ///"{""idlista"":30,""idmodelo"":4,""idinspeccion"":32,""descripcion_chklst"":""prueba"",""iditem"":85,""nombre_item"":""El acceso al puesto de conducción se realiza de manera segura"",""idopcion"":146,""texto_opcion"":""Se está estudiando"",""respuesta_seleccionada"":false,""observacion"":null}"
    ///Para eliminar esas repeticiones me voy a quedar con la lista de ítems únicos

    var auxUnicos =
        <String>{}; //Nos servimos de que los et sólo pueen tener elementoos distintos
    List<EvaluacionDetailsDataModel> itemUnicos = datosChecklist
        .where((elemento) => auxUnicos.add(elemento.nombreItem!))
        .toList();

    ///En el modelo de datos de checklist, las observaciones se asocian a cada opcion de respuesta,
    ///aunque en realizada sólo haya una observación por ítem. Sólo en la opción de respuesta elegida por
    ///el usuario la observación puede tener contenido, en las opciones del ítem no eleguidas las
    ///observaciones sera´n null. Esto lo podemos ver en el ejemplo del comentario previo
    ///donde mostramso un ejemplo de los datos que nos devuleve la base de datos
    ///Sin embrgo, a la hora de mostrar los datos en el pdf, las observaciones hemos de consoolidarlas
    ///y quedaro sólo con el valor no nulo del ítem para mostrar una observación por ítem
    ///Para ello, recorremos la lista de ítems únicos y para cada uno de ellos recorremos la lista de todos
    ///los ítems y nos quedamos con la observación no nula.
    for (var item in itemUnicos) {
      for (var itemTodos in datosChecklist) {
        if (item.nombreItem == itemTodos.nombreItem) {
          if (itemTodos.observacion != null) {
            item.observacion = itemTodos.observacion;
          }
        }
      }

      ///Si no hemos encontrado ninguna observación sobre el ítem le asignamos eso como observación
      item.observacion ??= 'Sin observaciones';
    }

    DatosPdfChecklistDataModel item;

    return [
      pw.SizedBox(height: 20),
      pw.Table(children: [
        ..._dameFilasItemChecklist(itemUnicos, datosChecklist,
            tamanoFuenteCuerpo, alineadoTexto, paddingCelda),
      ]),
    ];
  }

  static List<pw.TableRow> _dameFilasItemChecklist(
    List<PreguntaDataModel> preguntas,
    List<OpcionRespuestaDataModel> respuestas,
    double tamanoFuenteCuerpo,
    TextAlign alineadoTexto,
    double paddingCelda,
  ) {
    List<pw.TableRow> celdasItem = [];

    ///Recorremos una a uno los direnets item o preguntas de los que consta el modelo de checklist
    for (var item in preguntas) {
      PreguntaDataModel opcionItem;
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
                    color: PdfColor(1, 1, 1))),
            children: [
              pw.TableRow(
                  decoration:
                      pw.BoxDecoration(color: PdfColor.fromHex('EEE2BC')),
                  children: [
                    _dameCeldaCabeceraTabla(
                        item.pregunta!, 11, alineadoTexto, paddingCelda, 3)
                  ]),

              ///SizedBox para añadir el espacio en blanco antes de la priera respuesta
              pw.TableRow(children: [
                pw.SizedBox(height: 10),
              ]),

              ///Me quedo con las opciones que corresponden a ese item
              *//*for (opcionItem in respuestas)
                  .where((opcion) => opcion.iditem == item.iditem)
                  .toList())
                pw.TableRow(children: [
                  pw.Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Padding(
                          padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
                          child: pw.Text("repuestaaa",
                              style: const pw.TextStyle(fontSize: 11)),
                        ),
                        pw.Padding(
                          padding: const EdgeInsets.fromLTRB(20, 2, 10, 2),
                          child: pw.Checkbox(
                            activeColor: PdfColors.black,
                            checkColor: PdfColors.white,
                            width: 10,
                            height: 10,
                            name: item.iditem.toString() +
                                opcionItem.idopcion!.toString(),
                            value: opcionItem.respuestaSeleccionada!,
                          ),
                        ),
                      ])*//*
                ]),
            ])
      ]));
      celdasItem.add(pw.TableRow(children: [
        pw.SizedBox(height: 16),
      ]));
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
                    'Observaciones: ', 10, alineadoTexto, 5, 5),
                _dameCeldaEditableTabla(
                    ('${item.idlista}-${item.iditem}').toString(),
                    item.observacion!,
                    10,
                    alineadoTexto,
                    5)
              ])
            ]),
      ]));
    }

    return celdasItem;
  }*/

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

  //Método que devuelve una fila de datos el informe de chequeo incial del
  //ministerio
/*
  static pw.TableRow _dameFilaDatosTabla(DatosPdfDataModel datosMostrar,
      double tamanoFuente, TextAlign alineadoTexto, double? padding,
      {required bool editable}) {
    if (editable) {
      return pw.TableRow(children: [
        _dameCeldaTabla(datosMostrar.exigencia ?? '', tamanoFuente,
            alineadoTexto, padding, 4),
        _dameCeldaTabla(
            datosMostrar.accion ?? '', tamanoFuente, alineadoTexto, padding, 3),
        _dameCeldaEditableTabla(
            '${datosMostrar.accion}-${datosMostrar.exigencia}3',
            datosMostrar.situacion ?? '',
            tamanoFuente,
            alineadoTexto,
            padding),
        _dameCeldaEditableTabla(
            '${datosMostrar.accion}-${datosMostrar.exigencia}4',
            datosMostrar.responsable ?? '',
            tamanoFuente,
            alineadoTexto,
            padding),
        _dameCeldaEditableTabla(
            '${datosMostrar.accion}-${datosMostrar.exigencia}5',
            (datosMostrar.fechap == null)
                ? ''
                : DateFormat('dd/MM/yyyy').format(datosMostrar.fechap!),
            tamanoFuente,
            alineadoTexto,
            padding),
        _dameCeldaEditableTabla(
            '${datosMostrar.accion}-${datosMostrar.exigencia}6',
            (datosMostrar.fechar == null)
                ? ''
                : DateFormat('dd/MM/yyyy').format(datosMostrar.fechar!),
            tamanoFuente,
            alineadoTexto,
            padding),
        _dameCeldaEditableTabla(
            '${datosMostrar.accion}-${datosMostrar.exigencia}7',
            datosMostrar.observaciones ?? '',
            tamanoFuente,
            alineadoTexto,
            padding),
      ]);
    } else {
      return pw.TableRow(children: [
        _dameCeldaTabla(datosMostrar.exigencia ?? '', tamanoFuente,
            alineadoTexto, padding, 4),
        _dameCeldaTabla(
            datosMostrar.accion ?? '', tamanoFuente, alineadoTexto, padding, 3),
        _dameCeldaTabla(datosMostrar.situacion ?? '', tamanoFuente,
            alineadoTexto, padding, 1),
        _dameCeldaTabla(datosMostrar.responsable ?? '', tamanoFuente,
            alineadoTexto, padding, 2),
        _dameCeldaTabla(
            (datosMostrar.fechap == null)
                ? ''
                : DateFormat('dd/MM/yyyy').format(datosMostrar.fechap!),
            tamanoFuente,
            alineadoTexto,
            padding,
            1),
        _dameCeldaTabla(
            (datosMostrar.fechar == null)
                ? ''
                : DateFormat('dd/MM/yyyy').format(datosMostrar.fechar!),
            tamanoFuente,
            alineadoTexto,
            padding,
            1),
        _dameCeldaTabla(datosMostrar.observaciones ?? '', tamanoFuente,
            alineadoTexto, padding, 5),
      ]);
    }
  }

  ///Método que devuelveua celda con datos

  static Widget _dameCeldaTabla(String texto, double tamanoFuente,
      TextAlign alineadoTexto, double? padding, int maxLines) {
    return Padding(
        padding: EdgeInsets.all(padding ?? 5),
        child: pw.Text(
          texto,
          style: pw.TextStyle(fontSize: tamanoFuente),
          textAlign: alineadoTexto,
          maxLines: maxLines,
        ));
  }

  ///Método que devuelveua celda con datos

  static Widget _dameCeldaEditableTabla(String idTextField, String texto,
      double tamanoFuente, TextAlign alineadoTexto, double? padding,
      {int? maxLong = 200, double altura = 30, double anchura = 110}) {
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
*/

  ///Método que construye la cabecera de página del informe

  static Widget _buildCabeceraPagina(Context context, MemoryImage imagenLogo) {
    return pw.Table(children: [
      pw.TableRow(children: [
        pw.Image(imagenLogo, width: 100, height: 100),
        pw.SizedBox(width: 20),
        pw.Column(
          children: [
            pw.Text('LISTA DE CHEQUEO INICIAL DE LA ACTIVIDAD PREVENTIVA',
                style:
                    pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
          ],
        ),
      ]),
      pw.TableRow(children: [
        pw.SizedBox(height: 20),
      ]),
    ]);
  }

  ///Método que construye el pie de página del informe
  static Widget _buildPiePagina(Context context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text('Página ${context.pageNumber}/${context.pagesCount}'),
        ],
      ),
    );
  }

  ///Método qu egenera el pdf de un chequeo que siga un modelo que no
  /// sea el de ccheque inicla de l actibidad preventiva de minisdef

  static Future<List<int>?> generaDocumentPdfChecklist(
      int idLista, RepositorioDBSupabase bbdd) async {
    Logger log = Logger();

    try {
      List<PreguntaDataModel> datosChecklist =
          await bbdd.getPreguntasRespuesta(idLista);
      final imagenLogo = MemoryImage(
          (await rootBundle.load('assets/imagenes/MDE.Gob.Web-72px.jpg'))
              .buffer
              .asUint8List());

      ///Obtengo el nombre del modleos de checklist

      // String nombreModelo =
      //     await bbdd.getNombreModeloPorId(datosChecklist.first.idmodelo!);

      final pdf = pw.Document();
      /*pdf.addPage(pw.MultiPage(
        maxPages: 100,
        pageFormat: PdfPageFormat.a4,
        header: (pw.Context context) =>
            _buildCabeceraPaginaChecklist(context, imagenLogo, "nombreModelo"),
        build: (pw.Context context) =>
            _buildCuerpoPaginaChecklist(context, bbdd.getPreguntasRespuesta(4)), // Content
        // Center
        footer: (context) => _buildPiePaginaChecklist(context),
      )); // Page*/

      //Solicitamos permisos de almacenamiento si es necesario

      await almacenamiento.permisosAlmacenamiento();
      final bitsPDF = await pdf.save();

      return bitsPDF;
    } on Exception catch (e) {
      log.e('Se ha producdo un error en la generación del documento pdf: $e');
      rethrow;
    }
  }

  ///Método que genera el pdf de un chequeo que siga un modelo que no sea el de chequeo inicial de la actividad preventiva de minisdef

  static Widget _buildCabeceraPaginaChecklist(
      Context context, MemoryImage imagenLogo, String modelo) {
    return pw.Table(children: [
      pw.TableRow(children: [
        pw.Image(imagenLogo, width: 100, height: 100),
        pw.SizedBox(width: 20),
        pw.Column(
          children: [
            pw.Text('MODELO ${modelo.toUpperCase()}',
                style:
                    pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
          ],
        ),
      ]),
      pw.TableRow(children: [
        pw.SizedBox(height: 20),
      ]),
    ]);
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
}
