import 'package:flutter/material.dart';

import '../../../../core/theme/dimensions.dart';
import '../../../data/models/centro_dm.dart';
import 'dropdownfield2.dart';

class CustomDropdownField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final List<CentroDataModel> items;
  final int numItems;
  final bool isRed;
  final ValueChanged<String?>? onChanged;

  const CustomDropdownField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.items,
    required this.numItems,
    this.isRed = false,
    this.onChanged,
  });

  @override
  _CustomDropdownFieldState createState() => _CustomDropdownFieldState();
}

class _CustomDropdownFieldState extends State<CustomDropdownField> {
  bool isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: Dimensions.marginSmall),
      padding: const EdgeInsets.fromLTRB(
        0, // Izquierda
        Dimensions.marginDropDown, // Arriba
        0, // Derecha
        Dimensions.marginDropDown, // Abajo
      ),
      decoration: BoxDecoration(
        border: Border.all(color: widget.isRed? Colors.red : isFocused ? Theme.of(context).colorScheme.primary : Colors.transparent), // Cambia el color del borde cuando se enfoca
        borderRadius: BorderRadius.circular(Dimensions.cornerRadiusButton),
        color: Theme.of(context).colorScheme.onPrimary,
      ),
      child: Focus(
        onFocusChange: (hasFocus) {
          setState(() {
            isFocused = hasFocus;
          });
        },
        child: DropDownField(
          context: context,
          controller: widget.controller,
          hintText: widget.hintText,
          hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSecondary, fontWeight: FontWeight.normal),
          textStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.bold, fontSize: Dimensions.smallTextSize),
          enabled: true,
          itemsVisibleInDropdown: widget.numItems,
          items: widget.items.map((centro) => centro.denominacion).toList(),
          strict: false,
          onValueChanged: widget.onChanged, // Llamamos al parámetro onChanged aquí
        ),
      ),
    );
  }
}
