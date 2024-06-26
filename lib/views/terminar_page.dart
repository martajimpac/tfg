import 'package:evaluacionmaquinas/helpers/ConstantsHelper.dart';
import 'package:evaluacionmaquinas/views/mis_evaluaciones_page.dart';
import 'package:evaluacionmaquinas/views/my_home_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:evaluacionmaquinas/components/my_button.dart';
import 'package:evaluacionmaquinas/views/pdf_page.dart';

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
                          ConstantsHelper.showMyOkDialog(context, "title", "desc", () => null);
                        },
                        text: "Modificar"
                    )
                  ),
                  const SizedBox(width: 2), // Espacio entre los botones
                  Expanded(
                    child: MyButton(
                        adaptableWidth: false,
                        onTap: () {
                          //GoRouter.of(context).go('/pdf');
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const MyHomePage()));
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


