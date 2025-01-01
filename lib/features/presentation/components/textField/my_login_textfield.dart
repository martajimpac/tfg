import 'package:flutter/material.dart';

import '../../../../core/theme/dimensions.dart';
import '../../../../generated/l10n.dart';

class MyLoginTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final bool isRed;
  final Function(String)? onTextChanged;
  final VoidCallback? onSubmited;
  final FocusNode? focusNode;

  const MyLoginTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.onSubmited,
    this.focusNode,
    this.obscureText = false,
    this.isRed = false,
    this.onTextChanged,
  });


  @override
  _MyLoginTextFieldState createState() => _MyLoginTextFieldState();
}

class _MyLoginTextFieldState extends State<MyLoginTextField> {
  bool _isTyping = false;
  bool _obscureTextIsOn = true;

  @override
  void initState() {
    super.initState();
    _obscureTextIsOn = widget.obscureText;
  }

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
        obscureText: _obscureTextIsOn, // Corregir el operador ternario
        onChanged: (text) {
          setState(() {
            _isTyping = text.isNotEmpty;
          });

          // Llama a la función onTextChanged si no es nula
          if (widget.onTextChanged != null) {
            widget.onTextChanged!(text);
          }
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
            borderSide: BorderSide(color:  widget.isRed ? Colors.red : Theme.of(context).colorScheme.primary),
            borderRadius: BorderRadius.circular(Dimensions.cornerRadiusButton),
          ),
          fillColor: Theme.of(context).colorScheme.surface,
          filled: true,
          hintText: widget.hintText,
          hintStyle: TextStyle(
            color: Theme.of(context).colorScheme.onSecondary,
            fontSize: Dimensions.defaultTextSize,
            fontWeight: FontWeight.normal
          ),
          suffixIcon: widget.obscureText ?
          IconButton(
            icon: Icon(
              _obscureTextIsOn ? Icons.visibility_off : Icons.visibility,
              color: _obscureTextIsOn ? Colors.grey : Theme.of(context).colorScheme.onSecondary,
              semanticLabel: S.of(context).semanticlabelShowPassword,
            ),
            onPressed: () {
              setState(() {
                _obscureTextIsOn = !_obscureTextIsOn;
              });
            },
          )

          : _isTyping
              ? IconButton(
            icon: Icon(Icons.clear, semanticLabel: S.of(context).semanticlabelClearText),
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
