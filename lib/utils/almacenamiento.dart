import 'dart:io';
import 'dart:math';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

import 'Constants.dart';



///Funcionaes relacionadas con la escriture/lectura en almacenamiento local

Future<String> getNameFicheroAlmacenamientoLocal(int ideval) async {
  final directory = await getApplicationDocumentsDirectory();
  String pathFicheroAlmacenado = '${directory.path}/$ideval.pdf';
  return pathFicheroAlmacenado;
}

///Método encargado de obtener path y permisoso para almacenar el fichero de forma extrerna a la aplicación

Future<Directory?> damePathAlmacenamientoExterno() async {
  Directory? path;

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




///Almacena el fichero en un destino elegido por el usuario:
Future<String?> almacenaEnDestinoElegido(String internalFilePath, String fileName) async {
  String? pathFicheroAlmacenado;

  try {
    ///Obtenemos la extensión del archivo desde `internalFilePath`
    String extension = internalFilePath.split('.').last;

    /// Generamos un nuevo nombre de archivo con la extensión correcta
    String newFileName = '$fileName.$extension';

    /// Una vez generado el fichero en temporal, preguntamos al usuario dónde quiere guardarlo
    if (Platform.isAndroid) {
      // Obtiene el directorio temporal y crea una nueva ruta con el nuevo nombre
      final Directory extDir = await getTemporaryDirectory();
      final newFilePath = '${extDir.path}/$newFileName';

      // Copia el archivo con el nuevo nombre
      final newFile = await File(internalFilePath).copy(newFilePath);

      // Guardar en la ubicación elegida por el usuario
      final params = SaveFileDialogParams(sourceFilePath: newFile.path);
      final finalPath = await FlutterFileDialog.saveFile(params: params);

      if (kDebugMode) {
        print('El fichero se ha guardado en $finalPath');
      }
      pathFicheroAlmacenado = finalPath;

    } else if (Platform.isWindows) {
      String? outputFile = await FilePicker.platform.saveFile(
        dialogTitle: 'Elija la carpeta destino del fichero',
        fileName: newFileName,  // Usa el nombre personalizado
      );

      File returnedFile = File(outputFile!);
      pathFicheroAlmacenado = outputFile;
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





//Método que recibe un path de un direcctory y devuelev la lista de archivos que forman parte de ese directorio todo usar para ver si pdf está o no
/*Future<bool> checkIfFileExist(int idEval) async {

  try {
    String filePath = await getNameFicheroAlmacenamientoLocal(idEval);
    File file = File(filePath);

    // Verifica si el archivo existe
    if (await file.exists()) {
      return true;
    } else {
      return false;
    }
  } catch (e) {
    return false;
  }
}

Future<bool> checkIfFileExist2(int idEval) async {
  Logger log = Logger();
  try {
    // Obtiene el directorio de almacenamiento de documentos de la aplicación
    final directory = await getApplicationDocumentsDirectory();

    // Lista todos los archivos del directorio
    List<FileSystemEntity> listaArchivos = directory.listSync();

    // Comprueba si existe un archivo cuyo nombre contenga el idEval
    for (var archivo in listaArchivos) {
      if (archivo is File && archivo.path.endsWith('$idEval.pdf')) {
        return true; // El archivo con idEval fue encontrado
      }
    }

    return false; // No se encontró el archivo
  } catch (e) {
    log.e('Error al obtener la lista de archivos del directorio: $e');
    return false; // Si ocurre un error, regresa false
  }
}*/



