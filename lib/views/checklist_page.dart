
import 'package:evaluacionmaquinas/modelos/opcion_respuesta_dm.dart';
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
import '../utils/ConstantsHelper.dart';

class CheckListPage extends StatefulWidget {
  final int idEvaluacion;
  final bool isModifying;
  const CheckListPage({super.key, required this.idEvaluacion, required this.isModifying});

  @override
  State<CheckListPage> createState() => _CheckListPageState();

}

class _CheckListPageState extends State<CheckListPage> {


  @override
  void initState() {
    super.initState();
    BlocProvider.of<PreguntasCubit>(context).getPreguntas(widget.idEvaluacion);

  }

  final _pageViewController = PageController(initialPage: 0);
  final _scrollController = ScrollController();
  bool _isRed = false;
  int _selectedCircle = 0;

  @override
  void dispose() {
    _pageViewController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void checkAllAnswer(List<PreguntaDataModel> preguntas, List<CategoriaPreguntaDataModel> categorias){
    // Filtra las preguntas sin respuesta
    List<PreguntaDataModel> preguntasSinResponder = preguntas.where((pregunta) => pregunta.idRespuestaSeleccionada == null).toList();

    // Calcula el número de preguntas sin respuesta
    int numeroPreguntasSinResponder = preguntasSinResponder.length;
    if(numeroPreguntasSinResponder > 0){
      ConstantsHelper.showMyOkDialog(context, "Error", "Hay $numeroPreguntasSinResponder preguntas sin responder.\nLas preguntas no respondidas se marcarán en rojo.", () {
        Navigator.of(context).pop();
      });
      setState(() {
        _isRed = true;

        //buscar la categoria de la primera pregunta en rojo y centrarnos en ella
        var categoriaId = preguntas.firstWhere(
              (pregunta) => pregunta.idRespuestaSeleccionada == null,
        ).idCategoria;

        if (categoriaId != null && categoriaId != -1) {
          int index = categorias.indexWhere((categoria) => categoria.idcat == categoriaId);
          if (index != -1) {
            goToPage(index, preguntas, categorias);
          }
        }

      });
    }else{
      _isRed = false;
      ConstantsHelper.showLoadingDialog(context);
      context.read<PreguntasCubit>().insertarRespuestas(widget.idEvaluacion);
    }
  }

  void goToPage(int index, List<PreguntaDataModel> preguntas, List<CategoriaPreguntaDataModel> categorias) {
    // Primero cambia la página
    _pageViewController.animateToPage(
      index,
      duration: const Duration(seconds: 1),
      curve: Curves.ease,
    );


    if(_isRed){
      // Escucha cuando se complete la transición de página
      _pageViewController.addListener(() {

        // Obtén el índice de la página actual
        int currentPageIndex = _pageViewController.page!.round();

        // Si el índice de la página actual coincide con el índice al que queremos ir, realiza el scroll
        if (currentPageIndex == index) {

          //Scroll a la primera preguta sin responder
          var categoriaId = categorias[index].idcat;
          // Encuentra el índice de la pregunta sin responder dentro de su categoría
          var preguntasPagina = preguntas.where((pregunta) => pregunta.idCategoria == categoriaId).toList();
          int preguntaIndex = preguntasPagina.indexWhere((pregunta) => pregunta.idRespuestaSeleccionada == null);

          // Desplaza el ListView a la pregunta sin responder
          if (preguntaIndex != -1) {
            debugPrint("MARTA: preguntaindex: $preguntaIndex");
            _scrollController.animateTo(
              preguntaIndex * 100, // Ajusta este valor según el tamaño de tus elementos
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }




          setState(() {
            _selectedCircle = index;
          });

          // Importante: Elimina el listener después de completar el scroll
          _pageViewController.removeListener(() {});
        }
      });
    }else{
      setState(() {
        _selectedCircle = index;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          widget.isModifying ? "Modificar checklist" : "Checklist",
          style: const TextStyle(
            color: Colors.white,
            fontSize: Dimensions.titleTextSize,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
      body: Center(
        child: BlocConsumer<PreguntasCubit, PreguntasState>(
          builder: (context, state) {
            if (state is PreguntasLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is PreguntasLoaded) {
              final List<PreguntaDataModel> preguntas = state.preguntas;
              final List<CategoriaPreguntaDataModel> categorias = state.categorias;
              final List<OpcionRespuestaDataModel> respuestas = state.respuestas;

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
                                goToPage(index, state.preguntas, state.categorias);

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
                              child: PageView.builder(
                                controller:
                                _pageViewController,
                                itemCount: categorias.length,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, pageIndex) {
                                  final preguntasPagina = preguntas.where((pregunta) => pregunta.idCategoria == categorias[pageIndex].idcat).toList();
                                  return ListView.builder(
                                    itemCount: preguntasPagina.length,
                                    controller: _scrollController,
                                    itemBuilder: (context, index) {
                                      return MyListTile(
                                        name: preguntasPagina[index].pregunta,
                                        listAnswers: respuestas,
                                        answerSelected: preguntasPagina[index].idRespuestaSeleccionada != null
                                            ? respuestas.firstWhere(
                                              (respuesta) => respuesta.idopcion == preguntasPagina[index].idRespuestaSeleccionada,
                                              orElse: () => respuestas[0],
                                        ): null,
                                        onAnswerSelected: (answer){
                                          preguntasPagina[index].idRespuestaSeleccionada = answer.idopcion;
                                          context.read<PreguntasCubit>().updatePreguntas(preguntasPagina[index]);
                                        },
                                        isRed: _isRed && preguntasPagina[index].idRespuestaSeleccionada == null,
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        )
                    ),
                    if(_selectedCircle == (categorias.length - 1))
                      MyButton(
                          adaptableWidth: false,
                          onTap: (){
                            //comprobar que todas las preguntas han sido respondidas
                            checkAllAnswer(state.preguntas, state.categorias);
                          },
                          text: "TERMINAR",
                          roundBorders: false,
                      )
                  ]
              );

            } else if (state is PreguntasError) {
              return Text('Error: ${state.errorMessage}');
            } else {
              return const Text('Estado desconocido del cubit');
            }
          }, listener: (BuildContext context, PreguntasState state) {
            if(state is PreguntasSaved){
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => const TerminarPage()));
            }
        },
        ),
      ),
    );
  }


}

