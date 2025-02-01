import 'package:flutter/material.dart';

import '../../data/models/categoria_pregunta_dm.dart';

class HorizontalCategoryList extends StatelessWidget {
  final List<CategoriaPreguntaDataModel> categorias;
  final int currentIndex;
  final Function(int) onCategorySelected;

  const HorizontalCategoryList({
    super.key,
    required this.categorias,
    required this.currentIndex,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Lista horizontal de categorías
        Container(
          height: 66, // (50 + 16 margen)
          color: Theme.of(context).colorScheme.primaryContainer,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categorias.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () => onCategorySelected(index),
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: index == currentIndex
                          ? Theme.of(context).colorScheme.secondaryContainer
                          : Theme.of(context).colorScheme.tertiaryContainer,
                    ),
                    child: Center(
                      child: Text(
                        categorias[index].idcat.toString(),
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: index == currentIndex ? Colors.black : Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        // Título de la categoría seleccionada
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              categorias[currentIndex].categoria,
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
          ),
        )
      ],
    );
  }
}
