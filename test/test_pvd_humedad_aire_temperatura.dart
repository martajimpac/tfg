import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prl_chcklst_23/repositorios/repositorio_almacenamiento_local.dart';

void main() {
  group('getCondicionesPVDHumedadTemperaturaVelocidadAire', () {
    test('returns a list with three elements and correct condicion field',
        () async {
      WidgetsFlutterBinding.ensureInitialized();
      await RepositorioLocalHive.inicializarHive();
      await RepositorioLocalHive.abrirBoxes();
      // Arrange
      var repositorioAlmacenamientoLocalHive = RepositorioLocalHive();

      // Act
      List result = await repositorioAlmacenamientoLocalHive
          .getCondicionesPVDHumedadTemperaturaVelocidadAire();

      // Assert
      expect(result.length, 3);
      expect(result[0].condicion, 'Humedad(%)');
      expect(result[1].condicion, 'Velocidad del aire(km/h)');
      expect(result[2].condicion, 'Temperatura(Celsius)');
    });
  });
}
