import 'package:flutter/material.dart';
class MyAppTheme {
  static final lightTheme = ThemeData(

    drawerTheme: const DrawerThemeData(
      backgroundColor: Colors.white,
    ),
    brightness: Brightness.light,

    colorScheme: ColorScheme.light(
      background: Colors.white,
      onPrimary: const Color(0xFF000405), //texto

      primaryContainer: const Color(0xFF54B8CE), //color que cojen los botones por defecto, tambien lo he usado para el fondo de text view
      secondaryContainer: const Color(0xFF7CC7DC),
      onPrimaryContainer: Colors.white,

      //Text view
      primary: Colors.grey.shade400, // Color primario, text indicator...
      onBackground: Colors.grey.shade200, //color para el fondo de text view Y FONDO EN GENERAL
    ),

    appBarTheme: const AppBarTheme(
      elevation: 0,
      color: Colors.transparent,
      iconTheme: IconThemeData(
        color: const Color(0xFF000405), //color para texto de los botones y texto sobre azul
      ),
    ),
  );

  static final darkTheme = ThemeData(

    drawerTheme: const DrawerThemeData(
      backgroundColor: Colors.black,
    ),

    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      background: Colors.black,
      onPrimary: Colors.white, //texto

      primaryContainer: const Color(0xFF0023CE),
      secondaryContainer: const Color(0xFF677AC9),
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
  );

}
