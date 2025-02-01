import 'dart:io';
import 'dart:math';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'Constants.dart';



///Funcion que sirve para obtener el path en el que esta almacenado el pdf
Future<String> getNameFicheroAlmacenamientoLocal(int ideval) async {
  final directory = await getApplicationDocumentsDirectory();
  String pathFicheroAlmacenado = '${directory.path}/$ideval.pdf';
  return pathFicheroAlmacenado;
}


///Obtener todos los ficheros pdf almacenados en el almacenamiento interno
Future<List<File>> getPdfFiles() async {
  final directory = await getApplicationDocumentsDirectory();
  final pdfDirectory = Directory(directory.path);
  final files = pdfDirectory.listSync(); // Lista de todos los archivos y directorios

  // Filtra solo los archivos PDF
  final pdfFilesList = files
      .where((file) =>
  file is File && file.path.toLowerCase().endsWith('.pdf'))
      .cast<File>()
      .toList();

  return pdfFilesList;
}


///Método encargado de obtener path y permisoso para almacenar el fichero de forma extrerna a la aplicación

Future<Directory?> damePathAlmacenamientoExterno() async {
  Directory? path;

  permisosAlmacenamiento();

  if (Platform.isAndroid) {
    final Directory extDir = await getTemporaryDirectory();

    return Directory(extDir.path);
  } else if (Platform.isIOS) {
    //TODO: Comprobar si funciona en IOS (RN iOS en teoría no hay acceso fuera del sandbox)
    path = await getApplicationDocumentsDirectory();
  } else if (Platform.isWindows) {
    path = await getTemporaryDirectory();
  } else if (kIsWeb) {
    path = await getTemporaryDirectory();
  }
  return path;
}



///Controla permisos de almaacenamiento

Future<void> permisosAlmacenamiento() async {
  ///Obtenemos permisos de almacenamiento

  var status = await Permission.storage.status;
  if (!status.isGranted) {
    // If not we will ask for permission first
    await Permission.storage.request();
  }
}

///Devuelve le nombre pro defcyo que se asigna al fichero
String dameNombrePorDefectoFichero(int idInspeccion, TiposFicheros tipo) {
  late final String nombreFichero;
  late final String extension;

  /// Se pone como nombre de fichero inspeccion-fechahora
  final fechaActual = DateFormat('ddMMyykkmm').format(DateTime.now());

  if (tipo == TiposFicheros.word) {
    extension = 'docx';
  } else if (tipo == TiposFicheros.excel) {
    extension = 'xlsx';
  } else if (tipo == TiposFicheros.pdf) {
    extension = 'pdf';
  }

  int identificador = idInspeccion + Random().nextInt(1000);

  nombreFichero = '$identificador$fechaActual.$extension';
  return nombreFichero;
}

///Elimina un fichero si existe
Future<void> deleteFileFromIdEval(int idEval) async {
  String filePath = await getNameFicheroAlmacenamientoLocal(idEval);
  File file = File(filePath);
  try {
    if (await file.exists()) {
      await file.delete();
    }
  } catch (e) {

  }
}

Future<void> deleteFile(File file) async {
  Logger log = Logger();
  try {
    if (await file.exists()) {
      await file.delete();
    }
  } catch (e) {
    log.e('Se prodicido un ero al eliminar el fichero: $e');
    //rethrow;
  }
}




///Descargar el pdf: Almacena el fichero en un destino elegido por el usuario:
Future<String?> almacenaEnDestinoElegido(String internalFilePath, String fileName) async {
  String? pathFicheroAlmacenado;

  try {
    // Obtenemos la extensión del archivo desde `internalFilePath`
    String extension = internalFilePath.split('.').last;

    // Generamos un nuevo nombre de archivo con la extensión correcta
    String newFileName = '$fileName.$extension';

    if (Platform.isAndroid || Platform.isIOS) {
      // En Android e iOS usamos FlutterFileDialog para guardar en una ubicación elegida
      final Directory tempDir = await getTemporaryDirectory();
      final newFilePath = '${tempDir.path}/$newFileName';

      // Copia el archivo a una ubicación temporal
      final newFile = await File(internalFilePath).copy(newFilePath);

      // Mostramos el diálogo para elegir dónde guardar
      final params = SaveFileDialogParams(sourceFilePath: newFile.path);
      final finalPath = await FlutterFileDialog.saveFile(params: params);

      if (kDebugMode) {
        print('El fichero se ha guardado en $finalPath');
      }
      pathFicheroAlmacenado = finalPath;
    } else if (Platform.isWindows) {
      // En Windows usamos FilePicker para elegir la ubicación
      String? outputFile = await FilePicker.platform.saveFile(
        dialogTitle: 'Elija la carpeta destino del fichero',
        fileName: newFileName, // Usa el nombre personalizado
      );

      if (outputFile != null) {
        await File(internalFilePath).copy(outputFile);
        pathFicheroAlmacenado = outputFile;
      }
    } else {
      throw UnsupportedError('Plataforma no soportada');
    }

    return pathFicheroAlmacenado;
  } catch (e) {
    print('Error al generar el informe: $e');
    rethrow;
  }
}


///Método que comprueba si un fichero existe en el almacenamiento interno
Future<File?> checkIfFileExistAndReturnFile(int idEval) async {
  try {
    String filePath = await getNameFicheroAlmacenamientoLocal(idEval);
    File file = File(filePath);

    // Verifica si el archivo existe
    if (await file.exists()) {
      return file;
    } else {
      return null;
    }
  } catch (e) {
    return null;
  }
}








