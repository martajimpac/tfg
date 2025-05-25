import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:evaluacionmaquinas/core/utils/almacenamiento.dart';
import 'package:evaluacionmaquinas/core/utils/Constants.dart';

void main() {
  group('Almacenamiento', () {
    test('getNameFicheroAlmacenamientoLocal devuelve ruta válida', () async {
      final path = await getNameFicheroAlmacenamientoLocal(123);
      expect(path, contains('123.pdf'));
    });

    test('dameNombrePorDefectoFichero genera nombre correcto', () {
      final nombre = dameNombrePorDefectoFichero(1, TiposFicheros.pdf);
      expect(nombre, endsWith('.pdf'));
      expect(nombre, contains('1'));
    });

    test('deleteFile elimina un archivo existente', () async {
      final tempDir = await Directory.systemTemp.createTemp();
      final file = File('${tempDir.path}/testfile.txt');
      await file.writeAsString('contenido');
      expect(await file.exists(), isTrue);

      await deleteFile(file);
      expect(await file.exists(), isFalse);

      await tempDir.delete(recursive: true);
    });

    test('checkIfFileExistAndReturnFile devuelve null si no existe', () async {
      final file =
          await checkIfFileExistAndReturnFile(9999999999); // idEval improbable
      expect(file, isNull);
    });

    test('getPdfFiles devuelve lista (puede estar vacía)', () async {
      final files = await getPdfFiles();
      expect(files, isA<List<File>>());
    });

    test('permisosAlmacenamiento no lanza excepción', () async {
      // Solo comprobamos que no lanza excepción (en entorno de test puede no pedir permisos realmente)
      await permisosAlmacenamiento();
    });

    test('damePathAlmacenamientoExterno devuelve un Directory o null',
        () async {
      final dir = await damePathAlmacenamientoExterno();
      expect(dir == null || dir is Directory, isTrue);
    });

    test('deleteFile elimina un archivo existente', () async {
      final tempDir = await Directory.systemTemp.createTemp();
      final file = File('${tempDir.path}/testfile.txt');
      await file.writeAsString('contenido');
      expect(await file.exists(), isTrue);

      await deleteFile(file);
      expect(await file.exists(), isFalse);

      await tempDir.delete(recursive: true);
      test('deleteFileFromIdEval no lanza excepción si el archivo no existe',
          () async {
        // Usamos un idEval improbable para asegurarnos de que no existe
        await deleteFileFromIdEval(
            99999999999); // Llama con el número correcto de argumentos
        // Si no lanza excepción, el test pasa
        expect(true, isTrue);
      });
      expect(true, isTrue);
    });
    // Puedes añadir más tests para otros métodos según lo necesites
  });
}
