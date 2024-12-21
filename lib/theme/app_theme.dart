import 'package:flutter/material.dart';
import 'package:evaluacionmaquinas/theme/dimensions.dart';
class MyAppTheme {
  static final lightTheme = ThemeData(

    brightness: Brightness.light,

    colorScheme: ColorScheme.light(
      surface: const Color(0xFFEFEFEF), //Fondo


      primaryContainer: const Color(0xFF1C438E), //color que cojen los botones por defecto, tambien lo he usado para el fondo de text view
      secondaryContainer: const Color(0xFFFCC707),
      tertiaryContainer: const Color(0xFF5371AA),

      onPrimaryContainer: Colors.white, //texto sobre botones

      //Text view
      primary: Colors.grey.shade400, // Color primario, text indicator...
      onPrimary: Colors.white, //color para los contenedores

      onSecondary: Colors.grey.shade800, //color de texto claro

      onSurface: Colors.black, //texto text field
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
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      surface: const Color(0xFF131313), //Fondo

      primaryContainer: const Color(0xFF7898CE),
      secondaryContainer: const Color(0xFFFCC707),
      tertiaryContainer: const Color(0xFF657FB0),

      onPrimaryContainer: Colors.white, //texto sobre botones

      primary: Colors.grey.shade400,
      onPrimary: Colors.grey.shade800, //color de fondo de los container

      onSecondary: Colors.grey.shade200, //color de texto claro
      onSurface: Colors.white //texto text field
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
