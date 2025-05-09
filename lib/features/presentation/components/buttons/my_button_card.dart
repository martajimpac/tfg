
import 'package:flutter/material.dart';

import '../../../../core/theme/dimensions.dart';

class MyButtonCard extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  final Icon icon;
  final Color? iconContainerColor; // Parámetro opcional para el color del contenedor

  const MyButtonCard({super.key, 
    required this.onTap,
    required this.text,
    required this.icon,
    this.iconContainerColor, // Agregamos el parámetro opcional
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.marginMedium, vertical: 5), // Ajusta el valor según lo necesites
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        color: Theme.of(context).colorScheme.onPrimary,
        elevation: 0, // Establecer la elevación a 0 para eliminar la sombra
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(15.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: iconContainerColor ?? Theme.of(context).colorScheme.secondaryContainer, // Usa el color proporcionado o el predeterminado
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Center(
                    child: icon, // Utiliza directamente el icono pasado al constructor
                  ),
                ),
                const SizedBox(width: 16.0),
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
