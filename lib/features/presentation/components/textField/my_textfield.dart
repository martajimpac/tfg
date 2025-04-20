import 'package:flutter/material.dart';

import '../../../../core/theme/dimensions.dart';
import '../../../../generated/l10n.dart';

class MyTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isRed;
  final VoidCallback? onSubmited;
  final FocusNode? focusNode;
  final Function(String)? onTextChanged;

  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.isRed = false,
    this.onSubmited,
    this.focusNode,
    this.onTextChanged,
  });

  @override
  _MyTextFieldState createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  late bool _isEmpty;

  @override
  void initState() {
    super.initState();
    // Inicializar _isEmpty basado en el contenido inicial del controlador.
    _isEmpty = widget.controller.text.isEmpty;

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
        onChanged: (text) {
          if (widget.onTextChanged != null) {
            widget.onTextChanged!(text);
          }
        },
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
          fillColor: Theme.of(context).colorScheme.onPrimary,
          filled: true,
          hintText: widget.hintText,
          hintStyle: TextStyle(
            color: Theme.of(context).colorScheme.onSecondary,
            fontSize: Dimensions.smallTextSize,
            fontWeight: FontWeight.normal,
          ),
          suffixIcon: !_isEmpty
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
