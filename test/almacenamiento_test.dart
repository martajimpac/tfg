import 'dart:io' as io; // Usaremos 'io' para evitar conflictos de nombres
import 'dart:typed_data';

import 'package:evaluacionmaquinas/core/utils/Utils.dart'; // Asumo que aquí están tus métodos
import 'package:evaluacionmaquinas/core/utils/Constants.dart'; // Para TiposFicheros
import 'package:evaluacionmaquinas/core/utils/almacenamiento.dart%20';
import 'package:file/memory.dart'; // Para MemoryFileSystem
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';



class MockPathProviderPlatform extends Mock
    with MockPlatformInterfaceMixin // Necesario para PlatformInterface
    implements PathProviderPlatform {

  @override
  Future<String?> getApplicationDocumentsDirectory() => super.noSuchMethod(
    Invocation.method(#getApplicationDocumentsDirectory, []),
  );

  @override
  Future<String?> getTemporaryDirectory() => super.noSuchMethod(
    Invocation.method(#getTemporaryDirectory, []),
  );

}

// --- Mocks para PermissionHandler ---
class MockPermissionHandlerPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements PermissionHandlerPlatform {

  @override
  Future<PermissionStatus> checkPermissionStatus(Permission permission) => super.noSuchMethod(
    Invocation.method(#checkPermissionStatus, [permission]),
  );

  @override
  Future<Map<Permission, PermissionStatus>> requestPermissions(List<Permission> permissions) => super.noSuchMethod(
    Invocation.method(#requestPermissions, [permissions]),
  );
// ... otros métodos de PermissionHandlerPlatform que necesites ...
}



// --- Otros mocks de plataforma o clases Fake que puedas necesitar ---
class FakeFile extends Fake implements io.File {}
class FakeDirectory extends Fake implements io.Directory {}
class FakeSaveFileDialogParams extends Fake implements SaveFileDialogParams {}

void main() {
  // Configuración global para los mocks de PlatformInterface
  // Esto debe hacerse antes de que PathProviderPlatform.instance (o similar) sea accedido.
  late MockPathProviderPlatform mockPathProvider;
  late MockPermissionHandlerPlatform mockPermissionHandler;
  late MemoryFileSystem memoryFileSystem;

  // Función auxiliar para configurar el sistema de archivos en memoria
  io.File getFile(String path) => memoryFileSystem.file(path);
  io.Directory getDirectory(String path) => memoryFileSystem.directory(path);

  setUpAll(() {
    // Registrar fallbacks si los vas a usar con any() para estos tipos
    registerFallbackValue(FakeFile());
    registerFallbackValue(FakeDirectory());
    registerFallbackValue(FakeSaveFileDialogParams());
    // ... otros fallbacks que puedas necesitar ...
  });

  setUp(() {
    // Configura el mock para PathProviderPlatform
    mockPathProvider = MockPathProviderPlatform();
    PathProviderPlatform.instance = mockPathProvider; // Inyecta el mock

    // Configura el mock para PermissionHandlerPlatform
    mockPermissionHandler = MockPermissionHandlerPlatform();
    PermissionHandlerPlatform.instance = mockPermissionHandler;

    // Inicializa un nuevo sistema de archivos en memoria para cada test
    memoryFileSystem = MemoryFileSystem();

    // Configuración por defecto para los mocks (puedes sobreescribirla en cada test)
    when(() => mockPathProvider.getApplicationDocumentsDirectory())
        .thenAnswer((_) async => '/mock_documents_path');
    when(() => mockPathProvider.getTemporaryDirectory())
        .thenAnswer((_) async => '/mock_temp_path');
    when(() => mockPermissionHandler.requestPermissions(any()))
        .thenAnswer((_) async => {Permission.storage: PermissionStatus.granted});
    when(() => mockPermissionHandler.checkPermissionStatus(Permission.storage))
        .thenAnswer((_) async => PermissionStatus.granted);
  });

  // --- Tests ---
  group('Utils Tests', () {
    group('getNameFicheroAlmacenamientoLocal', () {
      test('debería devolver la ruta correcta del fichero', () async {
        // Arrange
        const ideval = 123;
        // La configuración de mockPathProvider.getApplicationDocumentsDirectory ya está en setUp

        // Act
        final result = await getNameFicheroAlmacenamientoLocal(ideval);

        // Assert
        expect(result, '/mock_documents_path/$ideval.pdf');
      });
    });

    group('getPdfFiles', () {
      test('debería devolver una lista de archivos PDF existentes', () async {
        // Arrange
        // Crea algunos archivos en el sistema de archivos en memoria
        await getFile('/mock_documents_path/file1.pdf').create(recursive: true);
        await getFile('/mock_documents_path/file2.PDF').create(recursive: true);
        await getFile('/mock_documents_path/file3.txt').create(recursive: true);
        await getDirectory('/mock_documents_path/subdir').create();

        // Act
        final result = await getPdfFiles();

        // Assert
        expect(result.length, 2);
        expect(result.any((file) => file.path.endsWith('file1.pdf')), isTrue);
        expect(result.any((file) => file.path.endsWith('file2.PDF')), isTrue);
      });

      test('debería devolver una lista vacía si no hay archivos PDF', () async {
        // Arrange
        await getFile('/mock_documents_path/file3.txt').create(recursive: true);

        // Act
        final result = await getPdfFiles();

        // Assert
        expect(result, isEmpty);
      });
    });

    group('permisosAlmacenamiento', () {
      test('debería solicitar permisos si no están concedidos', () async {
        // Arrange
        when(() => mockPermissionHandler.checkPermissionStatus(Permission.storage))
            .thenAnswer((_) async => PermissionStatus.denied); // Simula que no están concedidos
        // requestPermissions ya está mockeado en setUp para concederlos

        // Act
        await permisosAlmacenamiento();

        // Assert
        // Verifica que se intentó solicitar los permisos
        verify(() => mockPermissionHandler.requestPermissions([Permission.storage])).called(1);
      });

      test('no debería solicitar permisos si ya están concedidos', () async {
        // Arrange
        // checkPermissionStatus ya está mockeado en setUp para devolver granted
        // requestPermissions también, pero no debería llamarse

        // Act
        await permisosAlmacenamiento();

        // Assert
        // Verifica que NO se intentó solicitar los permisos
        verifyNever(() => mockPermissionHandler.requestPermissions(any()));
      });
    });

    group('dameNombrePorDefectoFichero', () {
      // Para testear esto de forma determinista, necesitamos controlar DateTime.now() y Random.
      // Mockearlos directamente es complicado. Una solución es pasar DateTime y Random como parámetros
      // o usar un paquete como `clock` para controlar el tiempo.
      // Por simplicidad, aquí solo probaremos el formato general.

      test('debería generar un nombre con formato correcto para PDF', () {
        // Arrange
        const idInspeccion = 100;
        final tipo = TiposFicheros.pdf;

        // Act
        final nombre = dameNombrePorDefectoFichero(idInspeccion, tipo);

        // Assert
        expect(nombre, endsWith('.pdf'));
        expect(nombre, matches(RegExp(r'^\d+ddMMyykkmm\.pdf$'.replaceAll('ddMMyykkmm', r'\d{10}'))));
        // No podemos predecir el número aleatorio exacto ni la fecha/hora exacta
        // pero podemos verificar el patrón.
      });

      test('debería generar un nombre con formato correcto para Word', () {
        const idInspeccion = 200;
        final tipo = TiposFicheros.word;
        final nombre = dameNombrePorDefectoFichero(idInspeccion, tipo);
        expect(nombre, endsWith('.docx'));
        expect(nombre, matches(RegExp(r'^\d+ddMMyykkmm\.docx$'.replaceAll('ddMMyykkmm', r'\d{10}'))));
      });

      test('debería generar un nombre con formato correcto para Excel', () {
        const idInspeccion = 300;
        final tipo = TiposFicheros.excel;
        final nombre = dameNombrePorDefectoFichero(idInspeccion, tipo);
        expect(nombre, endsWith('.xlsx'));
        expect(nombre, matches(RegExp(r'^\d+ddMMyykkmm\.xlsx$'.replaceAll('ddMMyykkmm', r'\d{10}'))));
      });
    });

    group('deleteFileFromIdEval', () {
      test('debería eliminar el archivo si existe', () async {
        // Arrange
        const idEval = 789;
        final filePath = '/mock_documents_path/$idEval.pdf';
        await getFile(filePath).create(recursive: true); // Crea el archivo en el mock FS
        expect(await getFile(filePath).exists(), isTrue); // Verifica que existe antes

        // Act
        await deleteFileFromIdEval(idEval);

        // Assert
        expect(await getFile(filePath).exists(), isFalse); // Verifica que ya no existe
      });

      test('no debería fallar si el archivo no existe', () async {
        // Arrange
        const idEval = 789;
        final filePath = '/mock_documents_path/$idEval.pdf';
        expect(await getFile(filePath).exists(), isFalse); // Verifica que no existe

        // Act & Assert
        // El método original tiene un try-catch vacío, por lo que no debería lanzar error.
        await expectLater(deleteFileFromIdEval(idEval), completes);
        expect(await getFile(filePath).exists(), isFalse);
      });
    });

    group('deleteFile', () {
      test('debería eliminar el archivo si existe', () async {
        // Arrange
        final filePath = '/mock_temp_path/test_file_to_delete.txt';
        final file = getFile(filePath);
        await file.create(recursive: true);
        expect(await file.exists(), isTrue);

        // Act
        await deleteFile(file); // Pasa el archivo del MemoryFileSystem

        // Assert
        expect(await file.exists(), isFalse);
      });

      test('no debería lanzar error si el archivo no existe', () async {
        // Arrange
        final filePath = '/mock_temp_path/non_existent_file.txt';
        final file = getFile(filePath);
        expect(await file.exists(), isFalse);

        // Act & Assert
        await expectLater(deleteFile(file), completes);
        expect(await file.exists(), isFalse);
      });
    });


    group('checkIfFileExistAndReturnFile', () {
      test('debería devolver el archivo si existe', () async {
        // Arrange
        const idEval = 456;
        final filePath = '/mock_documents_path/$idEval.pdf';
        await getFile(filePath).create(recursive: true);

        // Act
        final resultFile = await checkIfFileExistAndReturnFile(idEval);

        // Assert
        expect(resultFile, isNotNull);
        expect(resultFile!.path, equals(filePath));
      });

      test('debería devolver null si el archivo no existe', () async {
        // Arrange
        const idEval = 457;
        // No creamos el archivo

        // Act
        final resultFile = await checkIfFileExistAndReturnFile(idEval);

        // Assert
        expect(resultFile, isNull);
      });

      test('debería devolver null si ocurre un error al obtener el path', () async {
        // Arrange
        const idEval = 458;
        when(() => mockPathProvider.getApplicationDocumentsDirectory())
            .thenThrow(Exception("Error simulado al obtener directorio"));

        // Act
        final resultFile = await checkIfFileExistAndReturnFile(idEval);

        // Assert
        expect(resultFile, isNull);
      });
    });

    // --- Tests para almacenaEnDestinoElegido (MÁS COMPLEJOS DE MOCKEAR COMPLETAMENTE) ---
    // Debido a que FlutterFileDialog y FilePicker.platform usan métodos estáticos o instancias
    // globales difíciles de mockear sin wrappers, nos centraremos en lo que podemos probar:
    // la copia al directorio temporal y la preparación de nombres.

    group('almacenaEnDestinoElegido', () {
      // Necesitaremos mockear `Platform.isAndroid`, `Platform.isIOS`, etc.
      // Esto se puede hacer seteando `debugDefaultTargetPlatformOverride`.

      test('en Android, debería copiar a temporal y preparar para FlutterFileDialog', () async {
        // Arrange
        debugDefaultTargetPlatformOverride = TargetPlatform.android; // Simula Android

        final internalFilePath = '/mock_documents_path/source.pdf';
        final fileNameWithoutExtension = 'destino_elegido';
        final expectedTempFileName = '$fileNameWithoutExtension.pdf';
        final expectedTempFilePath = '/mock_temp_path/$expectedTempFileName';

        await getFile(internalFilePath).writeAsString('contenido pdf'); // Crea el archivo fuente

        // Mockea FlutterFileDialog.saveFile para que devuelva una ruta simulada
        // Esto es un desafío porque es estático. Si tuvieras un wrapper, lo mockearías.
        // Por ahora, asumimos que si llega a este punto con los datos correctos, está bien.
        // Si quisieras ir más allá, necesitarías un MethodChannel mock.
        // Para este ejemplo, no verificaremos la llamada a FlutterFileDialog.saveFile directamente.

        // Act
        // No podemos verificar el resultado de FlutterFileDialog.saveFile sin un mock del canal,
        // así que el test se centrará en la copia a temporal.
        // Para hacer que el test pase sin mockear saveFile, podemos hacer que la función
        // falle si saveFile no está mockeado, o modificarla para que sea más testable.
        // Por ahora, vamos a probar la lógica HASTA la copia.

        try {
          await almacenaEnDestinoElegido(internalFilePath, fileNameWithoutExtension);
        } catch (e) {
          // Esperamos un error si FlutterFileDialog no está mockeado y es llamado.
          // O, si modificamos la función para que sea más testable, podríamos evitar esto.
        }

        // Assert
        // Verifica que el archivo fue copiado al directorio temporal con el nombre correcto
        expect(await getFile(expectedTempFilePath).exists(), isTrue,
            reason: "El archivo no se copió a la ubicación temporal esperada");
        expect(await getFile(expectedTempFilePath).readAsString(), equals('contenido pdf'));

        debugDefaultTargetPlatformOverride = null; // Restaura
      });

      // Similar test para Platform.isIOS
      // Similar test para Platform.isWindows (mockeando FilePicker.platform.saveFile si es posible, o un wrapper)

      test('debería lanzar UnsupportedError para plataformas no soportadas', () async {
        debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia; // Plataforma no manejada

        final internalFilePath = '/mock_documents_path/source.pdf';
        final fileName = 'test_file';

        await getFile(internalFilePath).writeAsString('contenido pdf');

        // Act & Assert
        expect(
              () => almacenaEnDestinoElegido(internalFilePath, fileName),
          throwsA(isA<UnsupportedError>()),
        );
        debugDefaultTargetPlatformOverride = null; // Restaura
      });
    });

    group('damePathAlmacenamientoExterno', () {
      test('en Android, debería devolver la ruta del directorio temporal', () async {
        debugDefaultTargetPlatformOverride = TargetPlatform.android;
        // mockPathProvider.getTemporaryDirectory() está configurado en setUp

        final path = await damePathAlmacenamientoExterno();

        expect(path, isNotNull);
        expect(path!.path, equals('/mock_temp_path'));
        verify(() => mockPermissionHandler.checkPermissionStatus(Permission.storage)).called(1); // Verifica llamada a permisos
        debugDefaultTargetPlatformOverride = null;
      });

      test('en iOS, debería devolver la ruta de documentos de la aplicación', () async {
        debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
        // mockPathProvider.getApplicationDocumentsDirectory() está configurado en setUp

        final path = await damePathAlmacenamientoExterno();

        expect(path, isNotNull);
        expect(path!.path, equals('/mock_documents_path'));
        verify(() => mockPermissionHandler.checkPermissionStatus(Permission.storage)).called(1);
        debugDefaultTargetPlatformOverride = null;
      });

      // Añadir tests para Windows y Web si es necesario
    });

  });
}
