
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:modernlogintute/components/my_list_tile_check.dart';
import 'package:modernlogintute/cubit/categorias_cubit.dart';
import 'package:modernlogintute/cubit/preguntas_cubit.dart';
import 'package:modernlogintute/modelos/categoria_pregunta_dm.dart';
import 'package:modernlogintute/theme/dimensions.dart';
import 'package:modernlogintute/views/terminar_page.dart';

import '../components/my_button.dart';
import '../components/login_textfield.dart';
import '../components/my_textfield.dart';
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


  List toDoList = [
    ["Make tdsd fada dasa ffda dfsaas", Answer.notselected],
    ["Do dfasd asdf sdf asdf asf exercdfasfise", Answer.notselected]
  ];

  // checkbox was tapped
  void checkBoxChanged(Answer? value, int index) {
    setState(() {
      toDoList[index][1] = !toDoList[index][1];
    });
  }

  int _selectedCircle = 0;

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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          "Checklist",
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      body: Center(
        child: BlocBuilder<PreguntasCubit, PreguntasState>(
          builder: (context, state) {
            if (state is PreguntasLoading) {
              return const CircularProgressIndicator();
            } else if (state is PreguntasLoaded) {
              final List<PreguntaDataModel> preguntas = state.preguntas;
              final List<CategoriaPreguntaDataModel> categorias = state.categorias;

              // Aquí deberías devolver algún widget que muestre las preguntas y categorías, por ejemplo:
              return ListView.builder(
                itemCount: preguntas.length,
                itemBuilder: (context, index) {
                  final pregunta = preguntas[index];
                  return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 66, //(50 + 16 margen)
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primaryContainer,
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(Dimensions.cornerRadius),
                              bottomRight: Radius.circular(Dimensions.cornerRadius),
                            ),
                          ),
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
                                    });
                                    pageViewController.animateToPage(
                                      index,
                                      duration: const Duration(seconds: 1),
                                      curve: Curves.easeInOut,
                                    );
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 600),
                                    width: _selectedCircle == index ? 200 : 50,
                                    height: _selectedCircle == index ? 200 : 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: index == _selectedCircle ? Colors.black : Theme.of(context).colorScheme.secondaryContainer,
                                    ),
                                    child: Center(
                                      child: _selectedCircle == index
                                          ? Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 50, // Ancho fijo deseado
                                            child: Text(
                                              categorias[index].idcat.toString(), //TODO ORDENAR POR ID CATEGORIA
                                              style: const TextStyle(fontSize: 15, color: Colors.white),
                                              textAlign: TextAlign.center, // Alinear el texto al centro
                                              overflow: TextOverflow.ellipsis, // Controlar el desbordamiento del texto
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              categorias[index].categoria.toString(),
                                              style: const TextStyle(fontSize: 15, color: Colors.white),
                                              textAlign: TextAlign.start, // Alinear el texto al centro
                                              overflow: TextOverflow.ellipsis, // Controlar el desbordamiento del texto
                                            ),
                                          ),
                                        ],
                                      )
                                          : Text(
                                        categorias[index].idcat.toString(),
                                        style: const TextStyle(fontSize: 15, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            itemCount: categorias.length,
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
                                        itemCount: 1,
                                        itemBuilder: (context, index) {
                                          return ListTile(
                                            title: Text('Elemento $index'), // Contenido del elemento de la lista
                                            onTap: () {
                                              // Acción a realizar cuando se hace clic en el elemento
                                              print('Elemento $index clickeado');
                                            },
                                          );
                                        },
                                      ),
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
                },
              );

            } else if (state is PreguntasError) {
              return Text('Error: ${state.errorMessage}');
            } else {
              return Text('Estado desconocido del cubit');
            }
          },
        ),
      ),
    );
  }

}

