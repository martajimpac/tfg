import 'package:flutter/material.dart';

import '../../../../core/theme/dimensions.dart';
import '../../../../generated/l10n.dart';

class MyTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isRed;
  final int? numLines;
  final Function(String)? onTextChanged;
  final VoidCallback? onSubmited;
  final FocusNode? focusNode;
  final String? Function(String?)? validator;
  final Color? backgroundColor;

  const MyTextFormField({
    super.key,
    required this.controller,
    required this.hintText,
    this.isRed = false,
    this.numLines,
    this.onSubmited,
    this.focusNode,
    this.onTextChanged,
    this.validator,
    this.backgroundColor,
  });

  @override
  _MyTextFormFieldState createState() => _MyTextFormFieldState();
}

class _MyTextFormFieldState extends State<MyTextFormField> {
  late bool _isEmpty;

  @override
  void initState() {
    super.initState();
    // Inicializar el estado de _isEmpty en función del controlador.
    _isEmpty = widget.controller.text.isEmpty;

    // Agregar un listener al controlador para monitorear cambios de texto.
    widget.controller.addListener(_updateIsEmpty);
  }

  @override
  void dispose() {
    // Eliminar el listener del controlador.
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
      child: TextFormField(
        style: const TextStyle(
          fontWeight: FontWeight.bold, // Fuente en negrita
          fontSize: Dimensions.smallTextSize
        ),
        focusNode: widget.focusNode,
        controller: widget.controller,
        maxLines: widget.numLines, // Máximo de líneas
        minLines: widget.numLines, // Mínimo de líneas
        validator: widget.validator, // Validador opcional
        onChanged: (text) {
          if (widget.onTextChanged != null) {
            widget.onTextChanged!(text);
          }
        },
        onFieldSubmitted: (_) {
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
          fillColor: widget.backgroundColor ?? Theme.of(context).colorScheme.onPrimary,
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
              if (widget.onTextChanged != null) {
                widget.onTextChanged!("");
              }
            },
          )
              : null,
        ),
      ),
    );
  }
}
