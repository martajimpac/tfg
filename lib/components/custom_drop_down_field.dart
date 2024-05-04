import 'package:dropdownfield2/dropdownfield2.dart';
import 'package:flutter/material.dart';
import 'package:evaluacionmaquinas/modelos/centro_dm.dart';
import 'package:evaluacionmaquinas/theme/dimensions.dart';

class CustomDropdownField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final List<CentroDataModel> items;
  final int numItems;
  final Function(dynamic)? onValueChanged;

  const CustomDropdownField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.items,
    required this.numItems,
    this.onValueChanged,
  }) : super(key: key);

  @override
  _CustomDropdownFieldState createState() => _CustomDropdownFieldState();
}

class _CustomDropdownFieldState extends State<CustomDropdownField> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          0, // Izquierda
          Dimensions.marginSmall, // Arriba
          0, // Derecha
          Dimensions.marginSmall, // Abajo (añadiendo un espacio extra)
        ),
        decoration: BoxDecoration(
          border: Border.all(color: _isHovered ? Theme.of(context).colorScheme.primary : Colors.transparent), // Cambia el color del borde si el mouse está sobre él
          borderRadius: BorderRadius.circular(Dimensions.cornerRadiusButton),
        ),
        child: DropDownField(
          controller: widget.controller,
          hintText: widget.hintText,
          hintStyle: const TextStyle(color: Colors.grey),
          enabled: true,
          itemsVisibleInDropdown: widget.numItems,
          items: widget.items.map((centro) => centro.denominacion).toList(),
          onValueChanged: widget.onValueChanged,
        ),
      ),
    );
  }
}
