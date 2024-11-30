import 'package:flutter/material.dart';
import '../../theme/dimensions.dart';

class MyImageDialog extends StatelessWidget {
  final Image image;

  const MyImageDialog({
    super.key,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(Dimensions.marginMedium),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.cornerRadius),
          color: Theme.of(context).colorScheme.onBackground,
        ),
        padding: const EdgeInsets.all(Dimensions.marginMedium),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Botón de cerrar en la esquina superior izquierda
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: Icon(Icons.close),
                color: Theme.of(context).colorScheme.onSurface,
                onPressed: () => Navigator.of(context).pop(),
                iconSize: 36,
                padding: const EdgeInsets.all(0), // Elimina padding adicional
              ),
            ),
            const SizedBox(height: Dimensions.marginSmall), // Espaciado debajo del botón
            // Imagen centrada
            Flexible(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(Dimensions.cornerRadiusButton),
                child: image, // Muestra la imagen directamente
              ),
            ),
          ],
        ),
      ),
    );
  }
}
