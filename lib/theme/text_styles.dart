import 'package:flutter/material.dart';

class TextStyles {
  final BuildContext context;

  TextStyles(this.context);

  TextStyle get titleStyle => TextStyle(
    fontFamily: 'Manrope',
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
    color: Theme.of(context).colorScheme.onPrimary,
  );

  TextStyle get bodyStyle => TextStyle(
    fontFamily: 'Manrope',
    fontSize: 16.0,
    fontWeight: FontWeight.normal,
    color: Theme.of(context).colorScheme.onPrimary,
  );

  TextStyle get buttonStyle => TextStyle(
    fontFamily: 'Manrope',
    fontSize: 18.0,
    fontWeight: FontWeight.bold,
    color: Theme.of(context).colorScheme.onPrimaryContainer,
  );
}
