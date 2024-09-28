import 'package:flutter/material.dart';
import 'package:evaluacionmaquinas/theme/dimensions.dart';
class MyAppTheme {
  static final lightTheme = ThemeData(

    drawerTheme: const DrawerThemeData(
      backgroundColor: Colors.white,
    ),
    brightness: Brightness.light,

    colorScheme: ColorScheme.light(
      background: const Color(0xFFEFEFEF), //Fondo
      onPrimary: const Color(0xFFD0D3D9), //texto

      primaryContainer: const Color(0xFF1C438E), //color que cojen los botones por defecto, tambien lo he usado para el fondo de text view
      secondaryContainer: const Color(0xFFFCC707),
      tertiaryContainer: const Color(0xFF5371AA),

      onPrimaryContainer: Colors.white,

      //Text view
      primary: Colors.grey.shade400, // Color primario, text indicator...
      onBackground: Colors.white, //color para el fondo de text view

      onSecondary: Colors.grey.shade700, //color de texto claro

      onSurface: Colors.black //texto text field
    ),

    appBarTheme: const AppBarTheme(
      elevation: 0,
      color: Colors.transparent,
      iconTheme: IconThemeData(
        color: Colors.black,  //color para texto de los botones y texto sobre azul
      ),
    ),

    textTheme: const TextTheme(
      titleMedium: TextStyle(
        fontFamily: 'Gill-Sans',
        fontSize: Dimensions.titleTextSize,
        fontWeight: FontWeight.bold,
        color: Colors.black
      ),
      bodyMedium: TextStyle(
        fontFamily: 'Gill-Sans',
        fontSize: Dimensions.defaultTextSize,
        fontWeight: FontWeight.normal,
        color: Colors.black,
      ),

      labelMedium: TextStyle(
        fontFamily: 'Gill-Sans',
        fontSize: Dimensions.defaultTextSize,
        fontWeight: FontWeight.bold,
        color:  Colors.white,
      ),
      headlineMedium: TextStyle(
        fontFamily: 'Gill-Sans',
        fontSize: Dimensions.subTitleTextSize,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1C438E),
      )
    ),
  );

  static final darkTheme = ThemeData(

    drawerTheme: DrawerThemeData(
      backgroundColor: Colors.grey.shade800,
    ),

    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      background: const Color(0xFF131313),
      onPrimary: Colors.white, //texto

      primaryContainer: const Color(0xFF7898CE),
      secondaryContainer: const Color(0xFFFCC707),
      tertiaryContainer: const Color(0xFF657FB0),

      onPrimaryContainer: Colors.white,

      primary: Colors.grey.shade400,
      onBackground: Colors.grey.shade900,

      onSecondary: Colors.grey.shade200, //color de texto claro
      onSurface: Colors.white//texto text field
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
          fontFamily: 'Gill-Sans',
          fontSize: Dimensions.titleTextSize,
          fontWeight: FontWeight.bold,
          color:  Colors.white,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'Gill-Sans',
          fontSize: Dimensions.defaultTextSize,
          fontWeight: FontWeight.normal,
          color: Colors.white,
        ),

        labelMedium: TextStyle(
          fontFamily: 'Gill-Sans',
          fontSize: Dimensions.defaultTextSize,
          fontWeight: FontWeight.bold,
          color:  Colors.white,
        ),
        headlineMedium: TextStyle(
          fontFamily: 'Gill-Sans',
          fontSize: Dimensions.subTitleTextSize,
          fontWeight: FontWeight.bold,
          color: Color(0xFF5371AA),
        )
    ),
  );

}
