import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyButtonCard extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  final Icon icon;

  MyButtonCard({required this.onTap, required this.text, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: Theme.of(context).colorScheme.onBackground,
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
                  color: Theme.of(context).colorScheme.primaryContainer,
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
    );
  }
}