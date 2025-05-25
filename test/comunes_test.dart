import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:prl_chcklst_23/utils/comunes.dart' as comunes;

void main() {
  group('compruebaEsFecha', () {
    //Comprueba que la función compruebaEsFecha devuelve true para una fecha válida
    test('Devuelve true para fecha válida', () {
      // Arrange
      String validDateStr = '01/01/2022';

      // Act
      bool result = comunes.compruebaEsFecha(dateStr: validDateStr);

      // Assert
      expect(result, isTrue);
    });

//Devuleve false para fecha inválida
    test('Devuelve false para fecha inválida', () {
      // Arrange
      String invalidDateStr = '32/01/2022';

      // Act
      bool result = comunes.compruebaEsFecha(dateStr: invalidDateStr);

      // Assert
      expect(result, isFalse);
    });
  });

  //Devuelve false para una ceana de texto que no es fecha
  test('Devuelve false para cadena de texto que no es fecha', () {
    // Arrange
    String notDateStr = 'hola';

    // Act
    bool result = comunes.compruebaEsFecha(dateStr: notDateStr);

    // Assert
    expect(result, isFalse);
  });

//Compruebo cambiando el formato de la fecha
  test('Devuelve true para fecha válida con otro formato', () {
    // Arrange
    String validDateStr = '01-01-2022';

    // Act
    bool result = comunes.compruebaEsFecha(dateStr: validDateStr);

    // Assert
    expect(result, isTrue);
  });

  //Devuelve true si le paso una fecha con locale en inglés
  test('Devuelve true para fecha válida con locale en inglés', () {
    // Arrange
    String validDateStr = '01/13/2022';
    Locale locale = const Locale('en', 'US');

    // Act
    bool result =
        comunes.compruebaEsFecha(dateStr: validDateStr, locale: locale);

    // Assert
    expect(result, isTrue);
  });

  //Prueba función genera código nombre
  /* group('generarURIQR', () {
    test('Generates correct URI for given id', () {
      // Arrange
      int idEvalMaquina = 123;

      // Act
      String result = generarURIQR(idEvalMaquina: idEvalMaquina);

      // Assert
      expect(result, 'esquemaDL://hostDL/app/maquinas/resumenQRMaquina/123');
    });
  });*/

  group('generaCodigoNombreEmpleado', () {
    test('Generates a code of correct length', () {
      // Arrange
      String nombreEmpleado = 'John Doe';
      int longitud = 5;

      // Act
      String result = comunes.generaCodigoNombreEmpleado(
          nombreEmpleado: nombreEmpleado, longitud: longitud);

      // Assert
      expect(result.length, longitud);
    });

    test('Generates different codes for different names', () {
      // Arrange
      String nombreEmpleado1 = 'John Doe';
      String nombreEmpleado2 = 'Jane Doe';
      int longitud = 5;

      // Act
      String result1 = comunes.generaCodigoNombreEmpleado(
          nombreEmpleado: nombreEmpleado1, longitud: longitud);
      String result2 = comunes.generaCodigoNombreEmpleado(
          nombreEmpleado: nombreEmpleado2, longitud: longitud);

      // Assert
      expect(result1, isNot(equals(result2)));
    });

    test('Generates different code for the same name', () {
      // Arrange
      String nombreEmpleado = 'John Doe';
      int longitud = 5;

      // Act
      String result1 = comunes.generaCodigoNombreEmpleado(
          nombreEmpleado: nombreEmpleado, longitud: longitud);
      String result2 = comunes.generaCodigoNombreEmpleado(
          nombreEmpleado: nombreEmpleado, longitud: longitud);

      // Assert
      expect(result1, isNot(equals(result2)));
    });
  });

  group('limpiarCaracteresEspeciales', () {
    test('Devuelve la cadena sin caracteres especiales', () {
      // Arrange
      String cadena = '¡HolaÑñ! ¿Qué tal?';

      // Act
      String result = comunes.limpiarCadena(input: cadena);

      // Assert
      expect(result, 'Hola Qu tal');
    });
  });
}
