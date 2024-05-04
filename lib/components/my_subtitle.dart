import 'package:evaluacionmaquinas/theme/dimensions.dart';
import 'package:flutter/material.dart';

class MySubtitle extends StatelessWidget {
  final String text;

  const MySubtitle({
    super.key,
    required this.text
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        // Define el estilo de texto predeterminado
        fontSize: Dimensions.subTitleTextSize,
        color: Theme.of(context).colorScheme.primaryContainer,
        fontWeight: FontWeight.normal,
      ),// Utiliza el estilo de texto proporcionado
    );
  }
}