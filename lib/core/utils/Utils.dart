import 'dart:io';
import 'dart:typed_data';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:evaluacionmaquinas/features/data/models/imagen_dm.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../features/presentation/components/dialog/my_loading_dialog.dart';
import '../../features/presentation/components/dialog/my_ok_dialog.dart';

import 'package:image/image.dart' as img;

import '../../generated/l10n.dart';


class Utils {

  static void showMyOkDialog(BuildContext context, String title, String desc, Function()? onTap, {String? buttonText}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return MyOkDialog(
          title: title,
          desc: desc,
          onTap: onTap,
          buttonText: buttonText ?? '', // Si buttonText es null, usa un valor vacío como predeterminado
        );
      },
    );
  }


  static void showLoadingDialog(BuildContext context, {String text = ""}) {

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return MyLoadingAlertDialog(message: text);
        },
      );
  }


  static DateTime calculateDate(BuildContext context, int years, {bool add = true}) {
    DateTime now = DateTime.now();
    int newYear;
    if(add) {
      newYear = now.year + years;
    } else {
      newYear = now.year - years;
    }

    DateTime result = DateTime(newYear, now.month, now.day);
    return result;
  }

  static String getDifferenceBetweenDates(BuildContext context, DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);

    int years = 0;
    int months = 0;
    int days = 0;

    // Calcular años completos
    while (DateTime(from.year + years + 1, from.month, from.day).isBefore(to) ||
        DateTime(from.year + years + 1, from.month, from.day) == to) {
      years++;
    }

    // Calcular meses completos después de restar años completos
    while (DateTime(from.year + years, from.month + months + 1, from.day).isBefore(to) ||
        DateTime(from.year + years, from.month + months + 1, from.day) == to) {
      months++;
    }

    // Calcular días restantes después de restar meses completos
    days = to.difference(DateTime(from.year + years, from.month + months, from.day)).inDays;

    // Construir el mensaje según los resultados
    String message = 'Caduca en ';

    if (years == 1) {
      message += '$years año ';
    } else if (years > 0) {
      message += '$years años ';
    }

    if (months == 1) {
      if (years != 0) {
        message += ', ';
      }
      message += '$months mes ';
    } else if (months > 0) {
      if (years != 0) {
        message += ', ';
      }
      message += '$months meses ';
    }

    if (days == 1) {
      if (years != 0 || months != 0) {
        message += 'y ';
      }
      message += '$days día';
    } else if (days > 0) {
      if (years != 0 || months != 0) {
        message += 'y ';
      }
      message += '$days días';
    }

    return message;
  }


  static String getDays(BuildContext context, DateTime to) {
    to = DateTime(to.year, to.month, to.day);
    int daysOfDifference = (to.difference(DateTime.now()).inHours / 24).round() + 1;

    if (daysOfDifference == 0) {
      return "Caduca hoy";
    } else if(daysOfDifference == 1) {
      return "Caduca mañana";
    } else{
      return "Caduca en $daysOfDifference días";
    }
  }

  static bool menosDe30DiasParaCaducar(BuildContext context, DateTime to) {
    to = DateTime(to.year, to.month, to.day);
    int daysOfDifference = (to.difference(DateTime.now()).inHours / 24).round() + 1;

    if(daysOfDifference < 30){
      return true;
    }else{
      return false;
    }
  }

  static bool haCaducado(BuildContext context, DateTime to) {
    to = DateTime(to.year, to.month, to.day);
    int daysOfDifference = (to.difference(DateTime.now()).inHours / 24).round() + 1;

    if(daysOfDifference < 0){
      return true;
    }else{
      return false;
    }
  }

  static Uint8List? convertImage(imagenJson){
    if (imagenJson != null) {

      final cadenaRecortada = imagenJson.substring(4, imagenJson.length - 2); //quitar "[" y "]" caracteres ascii

      List<String> listaString = cadenaRecortada.split('2c'); //quitar caracteres "," ascii

      List<int> listaDecimal = [];

      for (var it in listaString) {
        String numeroSinImpares = '';
        for (int i = 0; i < it.length; i++) {
          // Si la posición es par, agregar el dígito a la cadena resultante
          if (i % 2 != 0) {
            numeroSinImpares += it[i];
          }
        }
        listaDecimal.add(int.parse(numeroSinImpares));
      }
      return Uint8List.fromList(listaDecimal);
    }
    return null;
  }


  static Future<bool> hayConexion() async {

    // Verificar tipo de conectividad (WiFi, Ethernet, Móvil, Ninguna)
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      return false; // No hay conexión a ninguna red
    }

    if(Platform.isWindows){
      return true;
    }
    return await _verificarAccesoInternet();
  }

  static Future<bool> _verificarAccesoInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false; // Sin acceso a Internet
    }
  }

  ///Función para mostrar la imagen
  static Image showImage(ImagenDataModel imagen) {
    if (imagen.imagen != null) {
      return Image.memory(imagen.imagen!, fit: BoxFit.contain); // Si es Uint8List
    } else if (imagen.image_url != null) {
      return Image.network(imagen.image_url!, fit: BoxFit.contain); // Si es una URL
    } else {
      // Retornar una imagen por defecto
      return Image.asset(
        'assets/images/default_image.png', // Ruta de la imagen por defecto
        fit: BoxFit.contain,
      );
    }
  }

  /// Función para comprimir imágenes
  static Future<Uint8List> compressImage(Uint8List imageBytes, BuildContext context) async {

    // Decodificar la imagen
    final image = img.decodeImage(imageBytes);
    if (image == null) {
      throw Exception(S.of(context).errorUploadingImage);
    }

    // Redimensionar la imagen (opcional)
    final resizedImage = img.copyResize(
      image,
      width: 800,
    );

    Uint8List finalImage = Uint8List.fromList(img.encodeJpg(resizedImage, quality: 70)); // Cambia el `quality` (0-100) según tus necesidades

    // Codificar la imagen comprimida a JPEG
    return finalImage;
  }



  /// Muestra un mensaje estilo Toast/SnackBar adaptado a la plataforma
  /// - Android/iOS: Usa FlutterToast (estilo nativo)
  /// - Windows/macOS/Linux: Usa SnackBar (centrado y con estilo similar)
  static showAdaptiveToast({
    required BuildContext context,
    required String message,
    ToastGravity gravity = ToastGravity.CENTER,
    Color backgroundColor = Colors.grey,
    Color textColor = Colors.white,
    Duration duration = const Duration(seconds: 2),
  }) {
    if (Platform.isAndroid || Platform.isIOS) {
      // Para móvil: Toast nativo
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: gravity,
        backgroundColor: backgroundColor,
        textColor: textColor,
      );
    } else {
      // Para escritorio: SnackBar personalizado
      final snackBar = SnackBar(
        content: Text(message, style: TextStyle(color: textColor)),
        duration: duration,
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        margin: _calculateMargin(context, gravity),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  /// Calcula el margen para posicionar el SnackBar según el gravity
  static

  EdgeInsets _calculateMargin(BuildContext context, ToastGravity gravity) {
    final screenHeight = MediaQuery.of(context).size.height;
    switch (gravity) {
      case ToastGravity.TOP:
        return EdgeInsets.only(top: 20, left: 20, right: 20);
      case ToastGravity.BOTTOM:
        return EdgeInsets.only(bottom: 20, left: 20, right: 20);
      case ToastGravity.CENTER:
      default:
        return EdgeInsets.only(
          bottom: screenHeight * 0.4,
          left: 20,
          right: 20,
        );
    }
  }

}