import 'package:flutter/material.dart';

class MyLoadingAlertDialog extends StatelessWidget {
  final String message; // Mensaje que se mostrará en el diálogo

  // Asignamos un valor predeterminado vacío al parámetro `message`
  const MyLoadingAlertDialog({super.key, this.message = ""});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      title: Center( // Envolvemos el texto con Center
        child: Text(
          message,
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}
