
import 'package:flutter/material.dart';

import '../../../../core/theme/dimensions.dart';
import '../../../../generated/l10n.dart';

class MySelectPhotoDialog extends StatelessWidget {
  final Function()? onCameraButtonTap;
  final Function()? onGalleryButtonTap;

  const MySelectPhotoDialog({
    super.key,
    this.onCameraButtonTap,
    this.onGalleryButtonTap,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(Dimensions.marginMedium),
      content: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.cornerRadiusButton),
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          padding: const EdgeInsets.all(Dimensions.marginMedium),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Hacer que la columna sea del tamaño mínimo
            children: [
              Text(
                S.of(context).photoDesc,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: Dimensions.marginMedium), // Espacio entre el título y el texto siguiente
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: onGalleryButtonTap,
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(20),
                      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                      foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                    child: Icon(Icons.photo_library_rounded, color: Colors.white, semanticLabel: S.of(context).semanticlabelAddFromGallery),
                  ),
                  ElevatedButton(
                    onPressed: onCameraButtonTap,
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(20),
                      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                      foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                    child: Icon(Icons.camera_alt, color: Colors.white, semanticLabel:  S.of(context).semanticlabelOpenCamera),
                  )
                ],
              ),
            ],
          )
      ),
    );
  }
}
