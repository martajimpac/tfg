import 'package:flutter/material.dart';
import 'package:evaluacionmaquinas/theme/dimensions.dart';

import '../generated/l10n.dart';
import 'buttons/my_button.dart'; // Importa el archivo generado

class EmptyView extends StatelessWidget {
  final VoidCallback? onRetry;
  final bool showRetryButton;
  final String? customText; // Variable opcional para texto personalizado

  const EmptyView({
    Key? key,
    this.onRetry,
    this.showRetryButton = true, // Valor por defecto true
    this.customText, // Texto personalizado opcional
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'lib/images/ic_empty_view.png',
            width: 100,
            height: 100,
            semanticLabel: "No hay datos",
          ),
          Text(
            customText ?? S.of(context).noEvaluations, // Usa texto personalizado si está disponible
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: Dimensions.marginMedium),
          if (showRetryButton)
            Text(
              S.of(context).retryText,
            ),
          const SizedBox(height: Dimensions.marginMedium),
          if (showRetryButton) // Condición para mostrar el botón
            MyButton(
              onTap: onRetry,
              text: S.of(context).retryTitle,
              adaptableWidth: true,
            ),
        ],
      ),
    );
  }
}
