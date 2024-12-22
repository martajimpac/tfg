import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';

import '../../../core/generated/l10n.dart';
import '../../../core/theme/dimensions.dart';
import '../../../core/utils/Utils.dart';
import '../../../core/utils/almacenamiento.dart' as almacenamiento;
import '../../../core/utils/pdf.dart';

class MyQrDialog extends StatelessWidget {
  final String qrData;
  final String nombreMaquina;
  final ScreenshotController _screenshotController = ScreenshotController();

  MyQrDialog({
    Key? key,
    required this.nombreMaquina,
    required this.qrData,
  }) : super(key: key);

  Future<void> _shareQrCode(BuildContext context) async {
    Utils.showLoadingDialog(context, text: "");
    try {
      await Future.delayed(const Duration(milliseconds: 200)); // Espera un breve momento
      final image = await _screenshotController.capture();
      if (image != null) {
        final tempDir = await getTemporaryDirectory();
        final file = await File('${tempDir.path}/qr_code.png').create();
        await file.writeAsBytes(image);
        await Share.shareXFiles([XFile(file.path)], text: 'QR de la máquina: $nombreMaquina');
      }else{
        _showErrorDialogQR(context, "Ha habido un error al compartir el QR.");
      }
    } catch (e) {
      _showErrorDialogQR(context, "Ha habido un error al compartir el QR.");
      debugPrint('Error al compartir el QR: $e');
    }finally{
      // Cierra el diálogo de carga al finalizar
      Navigator.of(context).pop();
    }
  }

  void _showErrorDialogQR(BuildContext context, String message) {
    Utils.showMyOkDialog(
      context,
      S.of(context).error,
      message,
          () {
        Navigator.of(context).pop(); // Cierra el diálogo
      },
    );
  }

  Future<void> _downloadQrCode(BuildContext context) async {
    Utils.showLoadingDialog(context, text: "");
    try {
      await Future.delayed(const Duration(milliseconds: 200)); // Espera un breve momento
      final image = await _screenshotController.capture();
      if (image != null) {
        //almacenar en el almacenamiento interno
        final downloadsDir = await getApplicationDocumentsDirectory();
        final internalPath = '${downloadsDir.path}/qr_code.png';
        final file = await File(internalPath).create();
        await file.writeAsBytes(image);

        await almacenamiento.almacenaEnDestinoElegido(internalPath, PdfHelper.getNamePdf(nombreMaquina));
      }else{
        _showErrorDialogQR(context, "Ha habido un error al compartir el QR.");
      }
    } catch (e) {
      _showErrorDialogQR(context, "Ha habido un error al compartir el QR.");
      debugPrint('Error al descargar el QR: $e');
    }finally{
      // Cierra el diálogo de carga al finalizar
      Navigator.of(context).pop();
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
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            padding: const EdgeInsets.all(Dimensions.marginMedium),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: Dimensions.marginSmall),
                const SizedBox(height: Dimensions.marginBig),
                Screenshot(
                  controller: _screenshotController,
                  child: Container(
                    color: Colors.white, // Fondo sólido (puedes cambiarlo a otro color si lo prefieres)
                    padding: const EdgeInsets.all(16.0), // Opcional, para dar algo de espacio alrededor del QR
                    child: QrImageView(
                      data: qrData,
                      version: QrVersions.auto,
                      size: 200.0,
                      gapless: false,
                    ),
                  ),
                ),
                const SizedBox(height: Dimensions.marginMedium),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Botón para compartir
                    _buildRoundedButton(
                      icon: Icons.share,
                      onPressed: () => _shareQrCode(context),
                      context: context,
                    ),
                    const SizedBox(width: Dimensions.marginSmall),
                    // Botón para descargar
                    _buildRoundedButton(
                      icon: Icons.download,
                      onPressed: () => _downloadQrCode(context),
                      context: context,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: Dimensions.marginSmall,
            right: 0,
            child: IconButton(
              icon: Icon(Icons.close,semanticLabel: 'Cerrar'),
              color: Theme.of(context).colorScheme.onSurface,
              onPressed: () => Navigator.of(context).pop(),
              iconSize: 36,
              padding: const EdgeInsets.all(Dimensions.marginSmall),
            ),
          ),
        ],
      ),
    );
  }




  Widget _buildRoundedButton({
    required IconData icon,
    required VoidCallback onPressed,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(28),
        ),
        padding: const EdgeInsets.all(12),
        child: Icon(
          icon,
          color: Theme.of(context).colorScheme.onPrimaryContainer,
          size: 28, semanticLabel: 'Código QR'
        ),
      ),
    );
  }
}
