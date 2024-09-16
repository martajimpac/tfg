import 'package:evaluacionmaquinas/components/my_button.dart';
import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../../theme/dimensions.dart';

class MySelectPhotoDialog extends StatelessWidget {
  final Function()? onCameraButtonTap;
  final Function()? onGalleryButtonTap;

  const MySelectPhotoDialog({
    Key? key,
    this.onCameraButtonTap,
    this.onGalleryButtonTap,
  }) : super(key: key);

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
            color: Theme.of(context).colorScheme.onBackground,
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
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    ),
                    child: const Icon(Icons.photo_library_rounded, color: Colors.white),
                  ),
                  ElevatedButton(
                    onPressed: onCameraButtonTap,
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(20),
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    ),
                    child: const Icon(Icons.camera_alt, color: Colors.white),
                  )
                ],
              ),
            ],
          )
      ),
    );
  }
}
