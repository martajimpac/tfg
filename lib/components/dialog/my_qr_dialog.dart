import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/rendering.dart';
import 'package:screenshot/screenshot.dart';

import '../../theme/dimensions.dart';

class MyQrDialog extends StatelessWidget {
  final String qrData;
  final ScreenshotController _screenshotController = ScreenshotController();

  MyQrDialog({
    Key? key,
    required this.qrData,
  }) : super(key: key);

  Future<void> _shareQrCode() async {
    try {
      // Captura el widget como imagen
      final image = await _screenshotController.capture();
      if (image != null) {
        // Guarda la imagen en un archivo temporal
        final tempDir = await getTemporaryDirectory();
        final file = await File('${tempDir.path}/qr_code.png').create();
        await file.writeAsBytes(image);

        // Comparte el archivo
        await Share.shareXFiles([XFile(file.path)], text: '¡Mira este QR!');
      }
    } catch (e) {
      debugPrint('Error al compartir el QR: $e');
    }
  }

  Future<void> _downloadQrCode(BuildContext context) async {
    try {
      // Captura el widget como imagen
      final image = await _screenshotController.capture();
      if (image != null) {
        // Guarda la imagen en la carpeta de descargas
        final downloadsDir = await getApplicationDocumentsDirectory();
        final file = await File('${downloadsDir.path}/qr_code.png').create();
        await file.writeAsBytes(image);

        // Muestra un snackbar de confirmación
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('El QR se ha descargado en: ${file.path}')),
        );
      }
    } catch (e) {
      debugPrint('Error al descargar el QR: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(Dimensions.marginMedium),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.cornerRadius),
              color: Theme.of(context).colorScheme.onBackground,
            ),
            padding: const EdgeInsets.all(Dimensions.marginMedium),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: Dimensions.marginMedium),
                Screenshot(
                  controller: _screenshotController,
                  child: QrImageView(
                    data: qrData,
                    version: QrVersions.auto,
                    size: 200.0,
                    gapless: false,
                  ),
                ),
                const SizedBox(height: Dimensions.marginMedium),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Botón para compartir
                    IconButton(
                      onPressed: () => _shareQrCode(),
                      icon: Icon(Icons.share),
                      color: Theme.of(context).primaryColor,
                      iconSize: 36,
                    ),
                    const SizedBox(width: Dimensions.marginSmall),
                    // Botón para descargar
                    IconButton(
                      onPressed: () => _downloadQrCode(context),
                      icon: Icon(Icons.download),
                      color: Theme.of(context).primaryColor,
                      iconSize: 36,
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Botón de cerrar en la esquina superior izquierda
          Positioned(
            top: 0,
            left: 0,
            child: IconButton(
              icon: Icon(Icons.close),
              color: Colors.black,
              onPressed: () => Navigator.of(context).pop(),
              iconSize: 36,
              padding: const EdgeInsets.all(Dimensions.marginSmall),
            ),
          ),
        ],
      ),
    );
  }
}
