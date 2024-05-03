import 'package:flutter/material.dart';
import '../theme/dimensions.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;

  const MyTextField({
    required this.controller,
    required this.hintText,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        0, // Izquierda
        Dimensions.marginSmall, // Arriba
        0, // Derecha
        Dimensions.marginSmall, // Abajo (añadiendo un espacio extra)
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText ?? false, // Corregir el operador ternario
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
          ),
          fillColor: Theme.of(context).colorScheme.onBackground,
          filled: true,
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Colors.grey,
            fontSize: Dimensions.defaultTextSize,
          ),
          suffixIcon: IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              controller.clear(); // Borrar el texto del TextField
            },
          ),
        ),
      ),
    );
  }
}
