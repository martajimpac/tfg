import 'dart:ui';

import 'package:flutter/material.dart';

class FloatingButtons extends StatelessWidget {
  final VoidCallback onSharePressed;
  final VoidCallback onDownloadPressed;

  const FloatingButtons({
    super.key,
    required this.onSharePressed,
    required this.onDownloadPressed,
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
              child: const Icon(Icons.share),
            ),
            const SizedBox(height: 10),
            FloatingActionButton(
              heroTag: "btnDownload",
              onPressed: onDownloadPressed,
              shape: const CircleBorder(),
              backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
              foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
              child: const Icon(Icons.download),
            ),
            const SizedBox(height: 80),
          ],
        ),
        const SizedBox(width: 16),
      ],
    );
  }
}
