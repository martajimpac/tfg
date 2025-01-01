import 'package:flutter/material.dart';

import '../../../core/theme/dimensions.dart';
import '../../../core/utils/Utils.dart';
import '../../../generated/l10n.dart';

class CaducidadIndicator extends StatelessWidget {
  final DateTime fechaCaducidad;

  const CaducidadIndicator({Key? key, required this.fechaCaducidad}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: Utils.menosDe30DiasParaCaducar(context, fechaCaducidad) || Utils.haCaducado(context, fechaCaducidad),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.cornerRadiusButton),
          border: Border.all(color:  Theme.of(context).colorScheme.secondaryContainer),
          color: Utils.haCaducado(context, fechaCaducidad) ?  Theme.of(context).colorScheme.secondaryContainer : Theme.of(context).colorScheme.onPrimary,
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Wrap(
            children: [
              const SizedBox(width: 2),
              Image.asset(
                'assets/icons/ic_danger.png',
                height: Dimensions.iconSize, // Ajusta el tamaño de la imagen según sea necesario
                width: Dimensions.iconSize,
                semanticLabel: S.of(context).semanticlabelExpiryWarning,
                color: Utils.haCaducado(context, fechaCaducidad) ? Colors.black :  Theme.of(context).colorScheme.secondaryContainer,
              ),
              const SizedBox(width: 8),
              Text(
                Utils.haCaducado(context, fechaCaducidad)
                    ? S.of(context).evaluationHasExpired
                    : Utils.getDays(context,  fechaCaducidad),
                style: Utils.haCaducado(context, fechaCaducidad)
                    ? const TextStyle(color: Colors.black)
                    : TextStyle(color: Theme.of(context).colorScheme.onSecondary),
              ),
              const SizedBox(width: 4),
            ],
          ),
        ),
      ),
    );
  }
}
