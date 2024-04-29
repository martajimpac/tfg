import 'package:dropdownfield2/dropdownfield2.dart';
import 'package:flutter/material.dart';
import 'package:modernlogintute/modelos/centro_dm.dart';
import 'package:modernlogintute/theme/dimensions.dart';
import 'package:flutter/material.dart';

class CustomDropdownField extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey), // Establece el borde con un color gris
        borderRadius: BorderRadius.circular(10.0), // Opcional: Establece un radio de borde
      ),
      child: DropDownField(
        controller: controller,
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.blue),
        enabled: true,
        itemsVisibleInDropdown: numItems,
        items:  items.map((centro) => centro.denominacion).toList(),
        onValueChanged: onValueChanged,
      ),
    );
  }
}
