import 'package:flutter/material.dart';
import '../helpers/ConstantsHelper.dart';
import '../theme/dimensions.dart';

class CaducidadIndicator extends StatelessWidget {
  final DateTime fechaCaducidad;

  const CaducidadIndicator({Key? key, required this.fechaCaducidad}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: ConstantsHelper.menosDe30DiasParaCaducar(context, fechaCaducidad) || ConstantsHelper.haCaducado(context, fechaCaducidad),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.cornerRadiusButton),
          border: Border.all(color: Colors.red),
          color: ConstantsHelper.haCaducado(context, fechaCaducidad) ? Colors.red : Theme.of(context).colorScheme.onBackground,
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Wrap(
            children: [
              const SizedBox(width: 2),
              Image.asset(
                'lib/images/ic_danger.png',
                height: Dimensions.iconSize, // Ajusta el tamaño de la imagen según sea necesario
                width: Dimensions.iconSize,
                color: ConstantsHelper.haCaducado(context, fechaCaducidad) ? Theme.of(context).colorScheme.onBackground : Colors.red,
              ),
              const SizedBox(width: 8),
              Text(
                ConstantsHelper.haCaducado(context, fechaCaducidad)
                    ? "La evaluación ha caducado"
                    : ConstantsHelper.getDays(context,  fechaCaducidad),
                style: ConstantsHelper.haCaducado(context, fechaCaducidad)
                    ? TextStyle(color: Theme.of(context).colorScheme.onBackground)
                    : TextStyle(color: Theme.of(context).colorScheme.onPrimary),
              ),
              const SizedBox(width: 4),
            ],
          ),
        ),
      ),
    );
  }
}
