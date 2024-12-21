
import 'package:flutter/material.dart';
import '../../theme/dimensions.dart';

class MyTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isRed;
  final VoidCallback? onSubmited;
  final FocusNode? focusNode;

  const MyTextField({super.key,
    required this.controller,
    required this.hintText,
    this.isRed = false,
    this.onSubmited,
    this.focusNode,
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
        style: TextStyle(
          fontWeight: FontWeight.bold,  // Fuente en cursiva
        ),
        focusNode: widget.focusNode,
        controller: widget.controller,
        onChanged: (text) {
          setState(() {
            _isTyping = text.isNotEmpty;
          });
        },
        onSubmitted: (_){
          if (widget.onSubmited != null) {
            widget.onSubmited!();
          }
        },
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: widget.isRed ? Colors.red : Colors.transparent),
            borderRadius: BorderRadius.circular(Dimensions.cornerRadiusButton),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: widget.isRed ? Colors.red : Theme.of(context).colorScheme.primary),
            borderRadius: BorderRadius.circular(Dimensions.cornerRadiusButton),
          ),
          fillColor: Theme.of(context).colorScheme.onPrimary,
          filled: true,
          hintText: widget.hintText,
          hintStyle: TextStyle(
              color: Theme.of(context).colorScheme.onSecondary,
              fontSize: Dimensions.smallTextSize,
              fontWeight: FontWeight.normal
          ),
          suffixIcon: _isTyping
              ? IconButton(
            icon: const Icon(Icons.clear, semanticLabel: "Borrar texto"),
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
