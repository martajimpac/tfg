import 'package:flutter/material.dart';
import '../../theme/dimensions.dart';

class MyLoginTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;

  const MyLoginTextField({super.key,
    required this.controller,
    required this.hintText,
    this.obscureText = false, //TODO METER VARIBLE DARK BORDE PARA LOGIN
  });

  @override
  _MyLoginTextFieldState createState() => _MyLoginTextFieldState();
}

class _MyLoginTextFieldState extends State<MyLoginTextField> {
  bool _isTyping = false;
  bool _obscureTextIsOn = true;

  @override
  void initState() {
    // TODO: implement initState
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
        controller: widget.controller,
        obscureText: _obscureTextIsOn, // Corregir el operador ternario
        onChanged: (text) {
          setState(() {
            _isTyping = text.isNotEmpty;
          });
        },
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.circular(Dimensions.cornerRadiusButton),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
            borderRadius: BorderRadius.circular(Dimensions.cornerRadiusButton),
          ),
          fillColor: Theme.of(context).colorScheme.background,
          filled: true,
          hintText: widget.hintText,
          hintStyle: const TextStyle(
            color: Colors.grey,
            fontSize: Dimensions.defaultTextSize,
            fontWeight: FontWeight.w100
          ),
          suffixIcon: widget.obscureText ?
          IconButton(
            icon: Icon(
              _obscureTextIsOn ? Icons.visibility_off : Icons.visibility,
              color: _obscureTextIsOn ? Colors.grey : Theme.of(context).colorScheme.primaryContainer,
            ),
            onPressed: () {
              setState(() {
                _obscureTextIsOn = !_obscureTextIsOn;
              });
            },
          )

          : _isTyping
              ? IconButton(
            icon: Icon(Icons.clear),
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
