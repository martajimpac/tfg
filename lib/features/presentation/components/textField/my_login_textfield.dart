import 'package:flutter/material.dart';

import '../../../../core/theme/dimensions.dart';
import '../../../../generated/l10n.dart';

class MyLoginTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final bool isRed;
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
  });

  @override
  _MyLoginTextFieldState createState() => _MyLoginTextFieldState();
}

class _MyLoginTextFieldState extends State<MyLoginTextField> {
  late bool _isEmpty;
  late bool _obscureTextIsOn;

  @override
  void initState() {
    super.initState();
    // Inicializar _isEmpty basado en el contenido inicial del controlador.
    _isEmpty = widget.controller.text.isEmpty;
    // Inicializar el estado de _obscureTextIsOn.
    _obscureTextIsOn = widget.obscureText;

    // Agregar un listener al controlador para monitorear cambios.
    widget.controller.addListener(_updateIsEmpty);
  }

  @override
  void dispose() {
    // Eliminar el listener para evitar fugas de memoria.
    widget.controller.removeListener(_updateIsEmpty);
    super.dispose();
  }

  void _updateIsEmpty() {
    setState(() {
      _isEmpty = widget.controller.text.isEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        0, // Izquierda
        Dimensions.marginTextField, // Arriba
        0, // Derecha
        Dimensions.marginTextField, // Abajo
      ),
      child: TextField(
        style: const TextStyle(
          fontWeight: FontWeight.bold, // Fuente en negrita
        ),
        focusNode: widget.focusNode,
        controller: widget.controller,
        obscureText: _obscureTextIsOn,
        onSubmitted: (_) {
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
          fillColor: Theme.of(context).colorScheme.surface,
          filled: true,
          hintText: widget.hintText,
          hintStyle: TextStyle(
            color: Theme.of(context).colorScheme.onSecondary,
            fontSize: Dimensions.defaultTextSize,
            fontWeight: FontWeight.normal,
          ),
          suffixIcon: widget.obscureText
              ? IconButton(
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
              : !_isEmpty
              ? IconButton(
            icon: Icon(Icons.clear, semanticLabel: S.of(context).semanticlabelClearText),
            onPressed: () {
              widget.controller.clear();
            },
          )
              : null,
        ),
      ),
    );
  }
}
