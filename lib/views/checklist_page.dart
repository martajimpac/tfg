import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modernlogintute/components/my_list_tile_check.dart';
import 'package:modernlogintute/components/my_navigation_drawer.dart';
import 'package:modernlogintute/cubit/page_cubit.dart';
import 'package:modernlogintute/theme/dimensions.dart';
import 'package:modernlogintute/views/my_home_page.dart';
import 'package:modernlogintute/views/terminar_page.dart';

import '../components/my_button.dart';
import '../components/login_textfield.dart';
import '../components/my_textfield.dart';
import '../components/square_tile.dart';
import '../cubit/page_state.dart';

class CheckListPage extends StatefulWidget {
  const CheckListPage({super.key});

  @override
  State<CheckListPage> createState() => _CheckListPageState();

}

//TODO PON ESTO EN UN CONSTANT HELPER O ALGO PARECIDO
enum Answer {
  si,
  no,
  na,
  notselected,
}

extension AnswerExtension on Answer {
  String get text {
    switch (this) {
      case Answer.si:
        return 'Sí';
      case Answer.no:
        return 'No';
      case Answer.na:
        return 'N/A';
      case Answer.notselected:
        return '';
    }
  }
}


class _CheckListPageState extends State<CheckListPage> {

  // text editing controllers
  final fieldController = TextEditingController();
  final pageViewController = PageController(initialPage: 0);

  final List<String> items = List.generate(100, (index) => 'Item $index');
  late List<TextEditingController> controllers;

  final List<int> numbers = List.generate(3, (index) => index + 1); //TODO, los mismos que pageview

  List toDoList = [
    ["Make tdsdfadadasaffda dfsaas", Answer.notselected],
    ["Do dfasd asdf sdf asdf asf exercdfasfise", Answer.notselected]
  ];

  @override
  void initState() {
    super.initState();
    controllers = List.generate(items.length, (index) => TextEditingController());
  }

  // checkbox was tapped
  void checkBoxChanged(Answer? value, int index) {
    setState(() {
      toDoList[index][1] = !toDoList[index][1];
    });
  }

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
          title: Text(
              "CheckList",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
          ),
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          iconTheme: IconThemeData(
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
        drawer: const MyNavigationDrawer(),

        body: BlocBuilder<PageCubit, PageState>(
          builder: (context, state) {
            return Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 66, //(50 + 16 margen)
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(Dimensions.cornerRadius), //TODO USAR CORNER RADIOUS
                          bottomRight: Radius.circular(Dimensions.cornerRadius),
                        ),
                      ),
                      child:  ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(Dimensions.marginSmall),
                            child: GestureDetector(
                              onTap: () {
                                context.read<PageCubit>().selectedPage(index);
                                pageViewController.animateToPage(
                                    index,
                                    duration: const Duration(seconds: 1),
                                    curve: Curves.easeInOut
                                );
                              },
                              child: Container(
                                width: 50, // Ancho del elemento
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25.0),
                                  color: index == state.pageIndex ? Colors.white : Theme.of(context).colorScheme.secondaryContainer,
                                ),
                                child: Center(
                                  child: Text(
                                    numbers[index].toString(),
                                    style: const TextStyle(fontSize: 20, color: Colors.white),
                                  ),
                                ),
                              ),
                            )

                        );
                        },
                        itemCount: numbers.length,
                      ),
                    ),
                    Expanded(
                        child : Column(
                          children: [
                            const SizedBox(height: Dimensions.cornerRadius),
                            Expanded(
                              child: PageView( //hay algun error aqui
                                controller: pageViewController,
                                physics: const NeverScrollableScrollPhysics(),
                                children: [
                                  ListView.builder(
                                    itemCount: items.length,
                                    itemBuilder: (context, index){
                                      return MyTextField(
                                          controller: controllers[index],
                                          hintText: items[index]
                                      );
                                    },
                                  ),
                                  ListView.builder(
                                    itemCount: toDoList.length,
                                    itemBuilder: (context, index){
                                      return MyListTile(
                                        name: toDoList[index][0],
                                        answerSelected: toDoList[index][1],
                                      );
                                    },
                                  ),
                                  ListView.builder(
                                    itemCount: items.length,
                                    itemBuilder: (context, index){
                                      return ListTile(
                                        title: LoginTextField(
                                          controller: fieldController,
                                          hintText: items[index],
                                          obscureText: false,
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            )
                          ],
                        )
                    ),
                    if(state.pageIndex == (numbers.length - 1))
                      MyButton(
                          adaptableWidth: false,
                          onTap: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                builder: (context) => TerminarPage(),
                              ),
                            );
                          },
                          text: "TERMINAR"
                      )
                  ]
              ),
            );
          }
        )

    );
  }

}

