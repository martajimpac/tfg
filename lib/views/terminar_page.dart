import 'package:flutter/material.dart';
import 'package:modernlogintute/components/my_button.dart';
import 'package:modernlogintute/views/pdf_page.dart';

import '../components/circle_tab_indicator.dart';

class TerminarPage extends StatefulWidget {
  const TerminarPage({Key? key}) : super(key: key);

  @override
  _TerminarPageState createState() => _TerminarPageState();
}

class _TerminarPageState extends State<TerminarPage> {
  final PageController _pageController = PageController(initialPage: 0);
  int _selectedButtonIndex = 0;

  void _goToPage(int pageIndex) {
    setState(() {
      _selectedButtonIndex = pageIndex;
      _pageController.animateToPage(
        pageIndex,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Terminado!'),
          ),
          body: Column(
            children:[
              TabBar(
                indicator: CircleTabIndicator(color: Theme.of(context).colorScheme.onPrimary, radius: 4),
                labelColor: Theme.of(context).colorScheme.onPrimary,
                isScrollable: true,
                labelPadding: const EdgeInsets.only(left: 20, right: 20),
                tabs: const [
                  Tab(text: "Resumen"),
                  Tab(text: "PDF",)
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    Container(
                      child: const Text("Resumen"),
                    ),
                    Container(
                      child: const Text("PDF"),
                    )
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: MyButton(
                        adaptableWidth: false,
                        onTap: () {
                          _mostrarDialogo(context);

                        },
                        text: "Modificar"
                    )
                  ),
                  const SizedBox(width: 2), // Espacio entre los botones
                  Expanded(
                    child: MyButton(
                        adaptableWidth: false,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PdfPage(),
                            ),
                          );
                        },
                        text: "Terminar"
                    )
                  ),
                ],
              ),
            ],
          )
        )
    );
  }
}

void _mostrarDialogo(BuildContext context){
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Título del Diálogo'),
        content: const Text('Contenido del diálogo.'),
        actions: [
          TextButton(
            onPressed: () {
              // Acción cuando se presiona el botón en el diálogo
              Navigator.of(context).pop(); // Cierra el diálogo
            },
            child: const Text('Aceptar'),
          ),
        ],
      );
    },
  );
}


