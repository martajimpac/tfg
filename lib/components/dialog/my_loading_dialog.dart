import 'package:flutter/material.dart';

class MyLoadingAlertDialog extends StatelessWidget {

  final String message; // Mensaje que se mostrará en el diálogo

  // Asignamos un valor predeterminado vacío al parámetro `message`
  const MyLoadingAlertDialog({super.key, this.message = ""});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.onBackground,
      title: Text(message),
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
