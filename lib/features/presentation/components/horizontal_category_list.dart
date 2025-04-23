import 'package:flutter/material.dart';
import '../../data/models/categoria_pregunta_dm.dart';

class HorizontalCategoryList extends StatefulWidget {
  final List<CategoriaPreguntaDataModel> categorias;
  final int currentIndex;
  final Function(int) onCategorySelected;
  final bool enabled;

  const HorizontalCategoryList({
    super.key,
    required this.categorias,
    required this.currentIndex,
    required this.onCategorySelected,
    this.enabled = true,
  });

  @override
  State<HorizontalCategoryList> createState() => _HorizontalCategoryListState();
}

class _HorizontalCategoryListState extends State<HorizontalCategoryList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void didUpdateWidget(HorizontalCategoryList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      _scrollToSelectedCategory();
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedCategory();
    });
  }

  void _scrollToSelectedCategory() {
    // Calculamos la posición para centrar el ítem seleccionado
    final double itemWidth = 66; // 50 (ancho) + 16 (padding)
    final double screenWidth = MediaQuery.of(context).size.width;
    final double offset = (widget.currentIndex * itemWidth) - (screenWidth / 2) + (itemWidth / 2);

    _scrollController.animateTo(
      offset.clamp(0.0, _scrollController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    if (widget.categorias.isEmpty) {
      return const SizedBox.shrink(); // o un loader si quieres
    }

    return IgnorePointer(
      ignoring: !widget.enabled, //desactiva los toques si no está habilitado
      child: Column(
        children: [
          // Lista horizontal de categorías
          Container(
            height: 66, // (50 + 16 margen)
            color: Theme.of(context).colorScheme.primaryContainer,
            child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: widget.categorias.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () => widget.onCategorySelected(index),
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: index == widget.currentIndex
                            ? Theme.of(context).colorScheme.secondaryContainer
                            : Theme.of(context).colorScheme.tertiaryContainer,
                      ),
                      child: Center(
                        child: Text(
                          (index + 1).toString(),
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: index == widget.currentIndex ? Colors.black : Colors.white,
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
                widget.categorias[widget.currentIndex].categoria,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
            ),
          )
        ],
      ),
    );
  }
}