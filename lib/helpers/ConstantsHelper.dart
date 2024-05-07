import 'package:evaluacionmaquinas/components/dialog/my_loading_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../components/dialog/my_ok_dialog.dart';

int selectedIndexHome = 0;

//Posibles valores: desarrollo, producción
enum EntornoVersion { desarrollo, produccion }

const EntornoVersion entornoVersion = EntornoVersion.desarrollo;

const DateFormatString = 'dd/MM/yyyy';
class ConstantsHelper {

  static void showMyOkDialog(BuildContext context, String title, String desc, Function()? onTap) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MyOkDialog(
          title: title,
          desc: desc,
          onTap: onTap,
        );
      },
    );
  }

  static void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const MyLoadingAlertDialog();
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
    int daysOfDifference = (to.difference(from).inHours / 24).round();

    // Calcular años completos
    int years = daysOfDifference ~/ 365;

    // Calcular días restantes después de restar los años completos
    int remainingDays = daysOfDifference % 365;

    // Calcular meses completos (asumiendo que cada mes tiene 30 días)
    int months = remainingDays ~/ 30;

    // Calcular días restantes finales
    int days = remainingDays % 30;

    // Construir el mensaje según los resultados
    String message = 'Quedan ';

    if (years > 0) {
      message += '$years años ';
    }
    if (months > 0) {
      message += '$months meses ';
    }
    if (days > 0) {
      message += 'y $days días';
    }

    return message;
  }

}