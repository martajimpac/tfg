import 'package:flutter/material.dart';

import '../generated/l10n.dart';

class ErrorPage extends StatelessWidget {
  final String mensajeError;

  const ErrorPage({Key? key, required this.mensajeError}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).error),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(
              Icons.error_outline,
              size: 50,
              color: Colors.red,
            ),
            const SizedBox(height: 20),
            Text(
              S.of(context).defaultError,
              style: const TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            Text(
              mensajeError,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Aquí puedes manejar el botón de manera adecuada, como regresar a la página anterior o reiniciar la aplicación.
              },
              child: Text(S.of(context).back),
            ),
          ],
        ),
      ),
    );
  }
}
