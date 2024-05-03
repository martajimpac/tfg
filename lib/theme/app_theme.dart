import 'package:flutter/material.dart';
import 'package:evaluacionmaquinas/theme/dimensions.dart';
class MyAppTheme {
  static final lightTheme = ThemeData(

    drawerTheme: const DrawerThemeData(
      backgroundColor: Colors.white,
    ),
    brightness: Brightness.light,

    colorScheme: ColorScheme.light(
      background: Colors.grey.shade200, //Fondo
      onPrimary: const Color(0xFF000405), //texto

      primaryContainer: const Color(0xE2DA105E), //color que cojen los botones por defecto, tambien lo he usado para el fondo de text view
      secondaryContainer: const Color(0xE2EC6498),
      onPrimaryContainer: Colors.white,
      inversePrimary: Colors.grey.shade600,
      //Text view
      primary: Colors.grey.shade400, // Color primario, text indicator...
      onBackground: Colors.white, //color para el fondo de text view
    ),

    appBarTheme: const AppBarTheme(
      elevation: 0,
      color: Colors.transparent,
      iconTheme: IconThemeData(
        color: Color(0xFF000405), //color para texto de los botones y texto sobre azul
      ),
    ),

    textTheme: const TextTheme(
      titleMedium: TextStyle(
        fontFamily: 'Manrope',
        fontSize: Dimensions.bigTextSize,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'Manrope',
        fontSize: Dimensions.defaultTextSize,
        fontWeight: FontWeight.normal,
        color: Colors.black,
      ),

      labelMedium: TextStyle(
        fontFamily: 'Manrope',
        fontSize: Dimensions.defaultTextSize,
        fontWeight: FontWeight.bold,
        color:  Colors.white,
      ),
    ),
  );

  static final darkTheme = ThemeData(

    drawerTheme: DrawerThemeData(
      backgroundColor: Colors.grey.shade800,
    ),

    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      background: Colors.black,
      onPrimary: Colors.white, //texto
      primaryContainer: const Color(0xE2DA105E),
      inversePrimary: Colors.grey.shade800,

      secondaryContainer: const Color(0xE2EC6498),
      onPrimaryContainer: Colors.white,

      primary: Colors.grey.shade400,
      onBackground: Colors.grey.shade800,
    ),

    appBarTheme: const AppBarTheme(
      elevation: 0,
      color: Colors.transparent,
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
    ),

    textTheme: const TextTheme(
      titleMedium: TextStyle(
        fontFamily: 'Manrope',
        fontSize: Dimensions.bigTextSize,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'Manrope',
        fontSize: Dimensions.defaultTextSize,
        fontWeight: FontWeight.normal,
        color: Colors.white,
      ),
      labelMedium: TextStyle(
        fontFamily: 'Manrope',
        fontSize: Dimensions.defaultTextSize,
        fontWeight: FontWeight.bold,
        color:  Colors.white,
      ),
    ),
  );

}
