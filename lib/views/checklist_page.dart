
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:evaluacionmaquinas/components/my_list_tile_check.dart';
import 'package:evaluacionmaquinas/cubit/preguntas_cubit.dart';
import 'package:evaluacionmaquinas/modelos/categoria_pregunta_dm.dart';
import 'package:evaluacionmaquinas/theme/dimensions.dart';
import 'package:evaluacionmaquinas/views/terminar_page.dart';

import '../components/my_button.dart';
import '../components/textField/my_textfield.dart';
import '../modelos/pregunta_categoria_dm.dart';

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

  @override
  void initState() {
    super.initState();
    BlocProvider.of<PreguntasCubit>(context).getPreguntas();

  }

  final pageViewController = PageController(initialPage: 0);
  late List<TextEditingController> controllers;



  // checkbox was tapped
  void checkBoxChanged(Answer? value, int index) {
    setState(() {
      //pre[index][1] = !toDoList[index][1];
    });
  }

  int _selectedCircle = 0;
  int _idCategorySelected = 0;
  List<PreguntaDataModel> _preguntasFiltradas = [];

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
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          "Checklist",
          style: TextStyle(
            color: Colors.white,
            fontSize: Dimensions.titleTextSize,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
      body: Center(
        child: BlocBuilder<PreguntasCubit, PreguntasState>(
          builder: (context, state) {
            if (state is PreguntasLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is PreguntasLoaded) {
              final List<PreguntaDataModel> preguntas = state.preguntas;
              final List<CategoriaPreguntaDataModel> categorias = state.categorias;
              _preguntasFiltradas = preguntas.where((pregunta) => pregunta.idCategoria == categorias[0].idcat).toList();
              return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 66, //(50 + 16 margen)
                      color: Theme.of(context).colorScheme.primaryContainer,
                      child:
                      ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(Dimensions.marginSmall),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedCircle = index;
                                  _idCategorySelected = categorias[index].idcat; //revisar
                                  print("hola $_idCategorySelected");
                                  _preguntasFiltradas = preguntas.where((pregunta) => pregunta.idCategoria == _idCategorySelected).toList();
                                });
                                pageViewController.animateToPage(
                                  index,
                                  duration: const Duration(seconds: 1),
                                  curve: Curves.ease,
                                );
                              },
                              child: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: index == _selectedCircle ? Theme.of(context).colorScheme.secondaryContainer : Theme.of(context).colorScheme.tertiaryContainer,
                                ),
                                child: Center(
                                  child: Text(
                                    categorias[index].idcat.toString(),
                                    style:  TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: index == _selectedCircle ? Colors.black : Colors.white
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        itemCount: categorias.length,
                      ),

                    ),
                    const SizedBox(height: Dimensions.marginMedium),
                    Text(categorias[_selectedCircle].categoria, style: Theme.of(context).textTheme.headlineMedium),
                    Expanded(
                        child : Column(
                          children: [
                            const SizedBox(height: Dimensions.marginSmall),
                            Expanded(
                              child: PageView( //hay algun error aqui
                                controller: pageViewController,
                                physics: const NeverScrollableScrollPhysics(),
                                children: [
                                  ListView.builder(
                                  itemCount: _preguntasFiltradas.length,
                                    itemBuilder: (context, index){
                                      return MyListTile(
                                        name: _preguntasFiltradas[index].pregunta,
                                        answerSelected: Answer.notselected,
                                      );
                                    },
                                  )
                                ],

                              ),
                            )
                          ],
                        )
                    ),
                    if(_selectedCircle == (categorias.length - 1))
                      MyButton(
                          adaptableWidth: false,
                          onTap: (){
                            //GoRouter.of(context).go('/terminar');
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const TerminarPage(),),);
                          },
                          text: "TERMINAR"
                      )
                  ]
              );

            } else if (state is PreguntasError) {
              return Text('Error: ${state.errorMessage}');
            } else {
              return const Text('Estado desconocido del cubit');
            }
          },
        ),
      ),
    );
  }

}

