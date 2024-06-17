import 'dart:io';
import 'dart:math';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

//Listado de tipos de ficheros que podemos crear
enum TiposFicheros { word, excel, pdf }

//Listado de clases de ficheros que podemos crear
enum ClasesFicheros { pvd, inspeccion }

///Funcionaes relacionadas con la escriture/lectura en almacenamiento local

///TODO: Implementar la funcionalidad de almacenamiento local

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

//Métod encargado de geerar el nombre para na foto de una evaluación de riesgo
//Recibe como parámteros la EvaluacionRiesgoDataModel y el
/*Future<String> dameNombreFotoEvaluacionRiesgo(
    EvaluacionRiesgoDataModel evaluacionRiesgo) async {
  String nombreFoto;

  final fechaActual = DateFormat('ddMMyykkmmss').format(DateTime.now());

  nombreFoto =
      'foto-${evaluacionRiesgo.idinspeccion}-${evaluacionRiesgo.ideval}-$fechaActual.jpg';

  return nombreFoto;
}*/

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
String dameNombrePorDefectoFichero(int idInspeccion, TiposFicheros tipo,
    {ClasesFicheros clase = ClasesFicheros.inspeccion}) {
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

  switch (clase) {
    case ClasesFicheros.inspeccion:
      nombreFichero = 'prl$identificador$fechaActual.$extension';
      break;
    case ClasesFicheros.pvd:
      nombreFichero = 'pvd$identificador$fechaActual.$extension';
      break;
  }
  return nombreFichero;
}

///Elimina un fichero si existe

Future<void> deleteFile(File file) async {
  Logger log = Logger();
  try {
    if (await file.exists()) {
      await file.delete();
    }
  } catch (e) {
    log.e('Se prodicido un ero al eliminar el fichero: $e');
    rethrow;
  }
}

///Nos devuelve el path del directorio propio de la app App docuemtns directory
Future<String> get dameLocalAppPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

///Almacena el fichero en un destino elegido por el usuario:
///TODO: tratar de que esto funcione. No he conseguido que funcione este mñetdo general para todos los tipos de fichero/S.O/Plataformas
Future<String?> almacenaEnDestinoElegido(
    File fichero, List<int> datos, TiposFicheros tipoFichero) async {
  String? pathFicheroAlmacenado;

  Logger log = Logger();
  try {
    ///Una vez generado el fichero en temporal preguntamos al usuario dónde quiere guardaro
    if (Platform.isAndroid) {
      final params = SaveFileDialogParams(sourceFilePath: fichero.path);
      final finalPath = await FlutterFileDialog.saveFile(params: params);

      log.i('El fichero se ha guardado en $finalPath');
      pathFicheroAlmacenado = finalPath;
    } else if (Platform.isWindows) {
      String? outputFile = await FilePicker.platform.saveFile(
          dialogTitle: 'Elija la carpeta destino del fichero',
          fileName: ((fichero.path).replaceAll('/', '\\')));

      File returnedFile = File(outputFile!);

      await returnedFile.writeAsBytes(datos);

      pathFicheroAlmacenado = outputFile;
    }

    return pathFicheroAlmacenado;
  } catch (e) {
    log.e('Error al generar el informe word: $e');
    rethrow;
  }
}

//Método que recibe un path de un direcctory y devuelev la lista de archivos que forman parte de ese directorio
Future<List<FileSystemEntity>> dameListaArchivosDirectorio(String path) async {
  Logger log = Logger();
  try {
    final directory = Directory(path);
    List<FileSystemEntity> listaArchivos = directory.listSync();
    return listaArchivos;
  } catch (e) {
    log.e('Error al obtener la lista de archivos del directorio: $e');
    rethrow;
  }
}

//Método que recibe un path de un direcctory y devuelve la lista de imágenes (jpg) que forman parte de ese directorio
//correspondientes a una evaluación de riesgo
/*
Future<List<FileSystemEntity>> dameListaImagenesEvaluacionDirectorio(
    String path, EvaluacionRiesgoDataModel evaluacionRiesgo) async {
  Logger log = Logger();
  try {
    final directory = Directory(path);
    List<FileSystemEntity> listaArchivos = directory.listSync();
    List<FileSystemEntity> listaImagenes = [];

    for (FileSystemEntity archivo in listaArchivos) {
      if (archivo.path.contains(
              'foto-${evaluacionRiesgo.idinspeccion}-${evaluacionRiesgo.ideval}') &&
          archivo.path.contains('.jpg')) {
        listaImagenes.add(archivo);
      }
    }
    return listaImagenes;
  } catch (e) {
    log.e('Error al obtener la lista de archivos del directorio: $e');
    rethrow;
  }
}
*/

//Método que recibe un path de un direcctory y uan evaluación de riesgo y elimina
//las imágenes (jpg) que forman parte de ese directorio correspondientes a esa evaluación de riesgo
/*Future<int> eliminaImagenesEvaluacionDirectorio(
    String path, EvaluacionRiesgoDataModel evaluacionRiesgo) async {
  Logger log = Logger();
  int count = 0;
  try {
    final directory = Directory(path);
    List<FileSystemEntity> listaArchivos = directory.listSync();

    for (FileSystemEntity archivo in listaArchivos) {
      if (archivo.path.contains(
              'foto-${evaluacionRiesgo.idinspeccion}-${evaluacionRiesgo.ideval}') &&
          archivo.path.contains('.jpg')) {
        await archivo.delete();
        log.d('Se ha eliminado el archivo: ${archivo.path}');
        count++;
      }
    }
  } catch (e) {
    log.e('Error al obtener la lista de archivos del directorio: $e');
    rethrow;
  }
  return count;
}*/
