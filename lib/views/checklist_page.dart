
import 'package:equatable/equatable.dart';
import 'package:evaluacionmaquinas/modelos/evaluacion_details_dm.dart';
import 'package:evaluacionmaquinas/modelos/evaluacion_list_dm.dart';
import 'package:evaluacionmaquinas/modelos/opcion_respuesta_dm.dart';
import 'package:evaluacionmaquinas/utils/pdf.dart';
import 'package:evaluacionmaquinas/views/pdf_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:evaluacionmaquinas/components/my_list_tile_check.dart';
import 'package:evaluacionmaquinas/cubit/preguntas_cubit.dart';
import 'package:evaluacionmaquinas/modelos/categoria_pregunta_dm.dart';
import 'package:evaluacionmaquinas/theme/dimensions.dart';
import 'package:evaluacionmaquinas/views/terminar_page.dart';
import '../components/buttons/my_button.dart';
import '../generated/l10n.dart';
import '../modelos/imagen_dm.dart';
import '../modelos/pregunta_dm.dart';
import '../utils/Constants.dart';
import '../utils/Utils.dart';

class CheckListPage extends StatefulWidget {
  final EvaluacionDetailsDataModel evaluacion;
  final List<ImagenDataModel> imagenes;
  final bool isModifying;
  const CheckListPage({super.key, required this.isModifying, required this.evaluacion, required this.imagenes});

  @override
  State<CheckListPage> createState() => _CheckListPageState();

}

class _CheckListPageState extends State<CheckListPage> {


  @override
  void initState() {
    super.initState();
    _selectedCircle = 0; // Reinicia al primer círculo
    BlocProvider.of<PreguntasCubit>(context).getPreguntas(context, widget.evaluacion.ideval);
  }

  final _pageViewController = PageController(initialPage: 0);
  final _scrollController = ScrollController();
  int _selectedCircle = 0;

  @override
  void dispose() {
    _pageViewController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void checkAllAnswer(List<PreguntaDataModel> preguntas){
    // Filtra las preguntas sin respuesta
    List<PreguntaDataModel> preguntasSinResponder = preguntas.where((pregunta) => pregunta.idRespuestaSeleccionada == null).toList();

    //asignar por defecto la respuesta si a lal preguntas sin resoonder
    for (var pregunta in preguntasSinResponder) {
      pregunta.idRespuestaSeleccionada = 1; //ID DE Sí
    }
    //ConstantsHelper.showLoadingDialog(context);
    context.read<PreguntasCubit>().insertarRespuestasAndGeneratePdf(widget.evaluacion, AccionesPdfChecklist.guardar);
  }

  void goToPage(int index) {
    // Primero cambia la página
    _pageViewController.animateToPage(
      index,
      duration: const Duration(seconds: 1),
      curve: Curves.ease,
    );

    setState(() {
      _selectedCircle = index;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
          widget.isModifying ? S.of(context).modifyChecklistTitle : S.of(context).checklistTitle,
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
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,  // Centra verticalmente la columna
                  children: [
                    Text(state.loadingMessage),
                    const SizedBox(height: 16), // Añade un espacio entre el texto y el indicador
                    const CircularProgressIndicator(),
                  ],
                ),
              );
            } else if (state is PreguntasLoaded) {
              final List<PreguntaDataModel> preguntas = state.preguntas;
              final List<CategoriaPreguntaDataModel> categorias = state.categorias;
              final List<OpcionRespuestaDataModel> respuestas = state.respuestas;

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildHorizontalCategoryList(categorias),
                  const SizedBox(height: Dimensions.marginMedium),
                  _buildCategoryTitle(context, categorias[_selectedCircle].categoria),
                  Expanded(
                    child: PageView.builder(
                      controller: _pageViewController,
                      itemCount: categorias.length,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, pageIndex) {
                        return _buildQuestionsList(context, pageIndex, preguntas, categorias, respuestas);
                      },
                    ),
                  ),
                  if (_selectedCircle == (categorias.length - 1))
                  // Botón "Terminar" si estás en la última página
                    MyButton(
                      adaptableWidth: false,
                      onTap: () {
                        // Comprobar que todas las preguntas han sido respondidas
                        checkAllAnswer(state.preguntas);
                      },
                      text: S.of(context).finish,
                      roundBorders: false,
                    )
                  else
                  // Botón "Siguiente" si no estás en la última página
                    MyButton(
                      adaptableWidth: false,
                      onTap: () {
                        // Ir a la siguiente página
                        goToPage(_selectedCircle + 1);
                      },
                      text: "Siguiente", // Asumiendo que tienes el texto traducido
                      roundBorders: false,
                    )
                ],
              );

            }  else {
              return Text(S.of(context).defaultError);
            }
          }, listener: (BuildContext context, PreguntasState state) {
            if(state is PdfGenerated){
              //Utils.showMyOkDialog(context, "generado", "GENERADO", () => null);
              //Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => TerminarPage(pathFichero: state.pathFichero, evaluacion: widget.evaluacion, imagenes: widget.imagenes)));
            }else if(state is PdfError){
              //Navigator.pop(context);
              Utils.showMyOkDialog(context, "Ha habido un error al generar el pdf", state.errorMessage, () => null); //TODO SI ESTO OCURRE....
            }else if(state is PreguntasError){
              Utils.showMyOkDialog(context, "Ha habido un error al generar el pdf", state.errorMessage, () => null);
            }
        },
        ),
      ),
    );
  }


  // Widget para construir la lista horizontal de categorías
  Widget _buildHorizontalCategoryList(List<CategoriaPreguntaDataModel> categorias) {
    return Container(
      height: 66, //(50 + 16 margen)
      color: Theme.of(context).colorScheme.primaryContainer,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categorias.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(Dimensions.marginSmall),
            child: GestureDetector(
              onTap: () {
                goToPage(index);
              },
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: index == _selectedCircle
                      ? Theme.of(context).colorScheme.secondaryContainer
                      : Theme.of(context).colorScheme.tertiaryContainer,
                ),
                child: Center(
                  child: Text(
                    categorias[index].idcat.toString(),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: index == _selectedCircle ? Colors.black : Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // Widget para construir el título de la categoría
  Widget _buildCategoryTitle(BuildContext context, String category) {
    return Text(
      category,
      style: Theme.of(context).textTheme.headlineMedium,
    );
  }

  // Widget para construir la lista de preguntas
  Widget _buildQuestionsList(BuildContext context, int pageIndex, List<PreguntaDataModel> preguntas, List<CategoriaPreguntaDataModel> categorias, List<OpcionRespuestaDataModel> respuestas) {
    final preguntasPagina = preguntas.where(
          (pregunta) => pregunta.idCategoria == categorias[pageIndex].idcat,
    ).toList();

    return ListView.builder(
      itemCount: preguntasPagina.length,
      controller: _scrollController,
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        return MyListTile(
          text: preguntasPagina[index].pregunta,
          listAnswers: respuestas,
          answerSelected: preguntasPagina[index].idRespuestaSeleccionada != null
              ? respuestas.firstWhere(
                (respuesta) => respuesta.idopcion == preguntasPagina[index].idRespuestaSeleccionada,
            orElse: () => respuestas[0],
          )
              : null,
          onAnswerSelected: (answer) {
            preguntasPagina[index].idRespuestaSeleccionada = answer.idopcion;
            preguntasPagina[index].isAnswered = true;
            context.read<PreguntasCubit>().updatePreguntas(preguntasPagina[index]);
          },
          onObservationsChanged: (observaciones) {
            preguntasPagina[index].observaciones = observaciones;
            preguntasPagina[index].isAnswered = true;
          },
          isAnswered: preguntasPagina[index].isAnswered,
          tieneObservaciones: preguntasPagina[index].tieneObservaciones,
        );
      },
    );
  }

}

