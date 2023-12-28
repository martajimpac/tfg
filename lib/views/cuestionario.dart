import 'package:flutter/material.dart';
import 'package:modernlogintute/components/my_navigation_drawer.dart';
import 'package:modernlogintute/views/my_home_page.dart';

import '../components/my_button.dart';
import '../components/my_textfield.dart';
import '../components/square_tile.dart';

class Cuestionario extends StatefulWidget {
  const Cuestionario({super.key});

  @override
  State<Cuestionario> createState() => _CuestionarioState();

}

class _CuestionarioState extends State<Cuestionario> {

  // text editing controllers
  final searcController = TextEditingController();
  final pageViewController = PageController(initialPage: 1);


  @override
  void dispose() {
    pageViewController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("hola que tal"),
          actions: [
            IconButton(
                onPressed: () => {
                  pageViewController.previousPage( //animate to
                      duration: const Duration(seconds: 1),
                      curve: Curves.easeInOut)
                },
                icon: const Icon(Icons.keyboard_arrow_left)
            ),
            IconButton(
                onPressed: () {},
                icon: const Icon(Icons.keyboard_arrow_right)
            )
          ],
        ),
        drawer: MyNavigationDrawer(),

        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //search bar
              MyTextField(
                controller: searcController,
                hintText: 'Username',
                obscureText: false,
              ),
              Expanded(
                child : PageView( //hay algun error aqui
                  controller: pageViewController,
                  children: [
                    Container( //TODO SCROLL VIEW
                        color: Colors.red,
                        child: const Center(child: Text('Page 1'))
                    ),
                    Container(
                        color: Colors.red,
                        child: const Center(child: Text('Page 2'))
                    ),
                    Container(
                        color: Colors.red,
                        child: const Center(child: Text('Page 3'))
                    )
                  ],
                ),
              )
            ]
        )
    );
  }

}

