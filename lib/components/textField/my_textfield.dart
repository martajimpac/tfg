
import 'package:flutter/material.dart';
import '../../theme/dimensions.dart';

class MyTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isRed;

  const MyTextField({super.key,
    required this.controller,
    required this.hintText,
    this.isRed = false,
  });

  @override
  _MyTextFieldState createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  bool _isTyping = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        0, // Izquierda
        Dimensions.marginTextField, // Arriba
        0, // Derecha
        Dimensions.marginTextField, // Abajo (añadiendo un espacio extra)
      ),
      child: TextField(
        controller: widget.controller,
        onChanged: (text) {
          setState(() {
            _isTyping = text.isNotEmpty;
          });
        },
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: widget.isRed ? Colors.red : Colors.transparent),
            borderRadius: BorderRadius.circular(Dimensions.cornerRadiusButton),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
            borderRadius: BorderRadius.circular(Dimensions.cornerRadiusButton),
          ),
          fillColor: Theme.of(context).colorScheme.onBackground,
          filled: true,
          hintText: widget.hintText,
          hintStyle: const TextStyle(
              color: Colors.grey,
              fontSize: Dimensions.smallTextSize,
              fontWeight: FontWeight.normal
          ),
          suffixIcon: _isTyping
              ? IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              setState(() {
                widget.controller.clear();
                _isTyping = false; // Cambia el estado para ocultar la cruz después de borrar el texto
              });
            },
          )
              : null,
        ),
      ),
    );
  }
}
