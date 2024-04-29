import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  final String mensajeError;

  const ErrorPage({Key? key, required this.mensajeError}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Error Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.error_outline,
              size: 50,
              color: Colors.red,
            ),
            SizedBox(height: 20),
            Text(
              'Ha ocurrido un error:',
              style: TextStyle(fontSize: 20),
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
              child: Text('Volver'),
            ),
          ],
        ),
      ),
    );
  }
}
