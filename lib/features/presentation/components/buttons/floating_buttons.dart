
import 'package:flutter/material.dart';

import '../../../../generated/l10n.dart';

class FloatingButtons extends StatelessWidget {
  final VoidCallback onSharePressed;
  final VoidCallback onDownloadPressed;
  final VoidCallback onQRPressed;

  const FloatingButtons({
    super.key,
    required this.onSharePressed,
    required this.onDownloadPressed,
    required this.onQRPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: "btnShare",
              onPressed: onSharePressed,
              shape: const CircleBorder(),
              backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
              foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
              child:  Icon(Icons.share,
                  semanticLabel: S.of(context).semanticlabelShare),
            ),
            const SizedBox(height: 10),
            FloatingActionButton(
              heroTag: "btnDownload",
              onPressed: onDownloadPressed,
              shape: const CircleBorder(),
              backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
              foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
              child: Icon(Icons.download,
                  semanticLabel: S.of(context).semanticlabelDownload),
            ),
            const SizedBox(height: 10),
            FloatingActionButton(
              heroTag: "btnQR",
              onPressed: onQRPressed,
              shape: const CircleBorder(),
              backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
              foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
              child: Icon(Icons.qr_code,
                  semanticLabel: S.of(context).semanticlabelGenerateQR),
            ),
            const SizedBox(height: 80),
          ],
        ),
        const SizedBox(width: 16),
      ],
    );
  }
}
