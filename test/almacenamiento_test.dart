import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:evaluacionmaquinas/core/utils/almacenamiento.dart';
import 'package:evaluacionmaquinas/core/utils/Constants.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:path_provider/path_provider.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockPathProviderPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements PathProviderPlatform {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final mockPathProvider = MockPathProviderPlatform();
  PathProviderPlatform.instance = mockPathProvider;

  setUp(() {
    when(() => mockPathProvider.getApplicationDocumentsPath())
        .thenAnswer((_) async => '/tmp');
    when(() => mockPathProvider.getTemporaryPath())
        .thenAnswer((_) async => '/tmp');
  });

  group('almacenamiento.dart', () {
    test('getNameFicheroAlmacenamientoLocal devuelve la ruta esperada',
        () async {
      final idEval = 123;
      final path = await getNameFicheroAlmacenamientoLocal(idEval);
      expect(path, endsWith('$idEval.pdf'));
    });

    test('dameNombrePorDefectoFichero genera nombre correcto para PDF', () {
      final nombre = dameNombrePorDefectoFichero(1, TiposFicheros.pdf);
      expect(nombre, endsWith('.pdf'));
      expect(nombre, contains('1'));
    });

    test('deleteFileFromIdEval no lanza excepción si el archivo no existe',
        () async {
      await deleteFileFromIdEval(999999); // idEval improbable
      expect(true, isTrue); // Si no lanza, pasa
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
      final file = await checkIfFileExistAndReturnFile(999999);
      expect(file, isNull);
    });

    test('getPdfFiles devuelve lista (puede estar vacía)', () async {
      final dirPath = '/tmp';
      final dir = Directory(dirPath);
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }
      final file = File('$dirPath/testfile.pdf');
      await file.writeAsString('contenido');
      final files = await getPdfFiles();
      expect(files.any((f) => f.path.endsWith('testfile.pdf')), isTrue);
      await file.delete();
    });
  });
}
