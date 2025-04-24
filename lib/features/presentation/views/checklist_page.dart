
import 'package:evaluacionmaquinas/features/presentation/components/textField/my_textform_field.dart';
import 'package:evaluacionmaquinas/features/presentation/views/terminar_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/dimensions.dart';
import '../../../core/utils/Constants.dart';
import '../../../core/utils/Utils.dart';
import '../../../generated/l10n.dart';
import '../../data/models/categoria_pregunta_dm.dart';
import '../../data/models/evaluacion_details_dm.dart';
import '../../data/models/imagen_dm.dart';
import '../../data/models/opcion_respuesta_dm.dart';
import '../../data/models/pregunta_dm.dart';
import '../components/buttons/my_button.dart';
import '../components/horizontal_category_list.dart';
import '../components/my_list_tile_check.dart';
import '../cubit/preguntas_cubit.dart';


class CheckListPage extends StatefulWidget {
  final EvaluacionDetailsDataModel evaluacion;
  final List<ImagenDataModel> imagenes;
  final bool isModifying;

  const CheckListPage({super.key, required this.isModifying, required this.evaluacion, required this.imagenes});

  @override
  State<CheckListPage> createState() => _CheckListPageState();

}

class _CheckListPageState extends State<CheckListPage> {

  late PreguntasCubit _cubit;
  late int _currentPageIndex;
  final _observacionesCategoryController = TextEditingController();


  @override
  void initState() {
    super.initState();
    _cubit = BlocProvider.of<PreguntasCubit>(context);
    _currentPageIndex = 0; // Inicializa con la primera página
    _cubit.getPreguntas(context, widget.evaluacion,_currentPageIndex);
  }

  void _checkAllAnswer(List<PreguntaDataModel> preguntas){
    // Filtra las preguntas sin respuesta
    List<PreguntaDataModel> preguntasSinResponder = preguntas.where((pregunta) => pregunta.idRespuestaSeleccionada == null).toList();

    //asignar por defecto la respuesta si a la preguntas sin resoonder
    for (var pregunta in preguntasSinResponder) {
      pregunta.idRespuestaSeleccionada = pregunta.idDefaultAnswer; //ID DE Sí
    }
    //ConstantsHelper.showLoadingDialog(context);
    _cubit.insertarRespuestasAndGeneratePdf(context, widget.evaluacion, AccionesPdfChecklist.guardar);
  }

  void _exit(){
    /*_cubit.clearCache();
    Navigator.of(context).pop(); //TODO ARREGLAR AQUI NAV ATRÁS*/
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child:
        Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white, semanticLabel: S.of(context).semanticlabelBack),
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
          body: BlocConsumer<PreguntasCubit, PreguntasState>(
            builder: (context, state) {
              final List<CategoriaPreguntaDataModel> categorias = _cubit.categorias ?? [];
              /*bool isLastPage = _currentPageIndex == (categorias.length - 1);
              bool isLoading = state is PreguntasLoading;*/

              return Column(
                children: [
                  HorizontalCategoryList(
                    categorias: categorias,
                    currentIndex: _currentPageIndex,
                    enabled: state is PreguntasLoaded,
                    onCategorySelected: (index) {
                      _currentPageIndex = index;
                      _cubit.cambiarCategoria(index);
                    },
                  ),
                  Expanded(
                    child: () {
                      if (state is PreguntasLoading) {
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(state.loadingMessage),
                              const SizedBox(height: 16),
                              const CircularProgressIndicator(),
                            ],
                          ),
                        );
                      } else if (state is PreguntasLoaded) {
                        final List<OpcionRespuestaDataModel> respuestas = _cubit.respuestas ?? [];
                        final List<PreguntaDataModel> preguntas = _cubit.preguntas ?? [];

                        final CategoriaPreguntaDataModel? category = _cubit.categorias?.firstWhere(
                              (it) => it.idcat == (state.pageIndex + 1),
                        );

                        final List<PreguntaDataModel> preguntasPorPagina = category == null
                            ? []
                            : preguntas.where((pregunta) => pregunta.idCategoria == category.idcat).toList();

                        return Column(
                          children: [
                            _buildQuestionsList(context, _currentPageIndex, preguntasPorPagina, category!, respuestas),
                            if (_currentPageIndex == (categorias.length - 1))
                              MyButton(
                                adaptableWidth: false,
                                onTap: () => _checkAllAnswer(preguntas),
                                text: S.of(context).finish,
                                roundBorders: false,
                              )
                            else
                              MyButton(
                                adaptableWidth: false,
                                onTap: () {
                                  _currentPageIndex++;
                                  _cubit.getPreguntas(context, widget.evaluacion, _currentPageIndex);
                                },
                                text: S.of(context).next,
                                roundBorders: false,
                              ),
                          ],
                        );
                      } else {
                        return Center(child: Text(S.of(context).defaultError));
                      }
                    }(),
                  )
                ],
              );
            },

            listener: (BuildContext context, PreguntasState state) {
              if(state is PdfGenerated){
                Navigator.push(context, MaterialPageRoute(builder: (context) => TerminarPage(pathFichero: state.pathFichero, evaluacion: widget.evaluacion, imagenes: widget.imagenes)));
              }else if(state is PdfError){
                Utils.showMyOkDialog(context, S.of(context).error, state.errorMessage, () => { Navigator.of(context).pop() });
              }else if(state is PreguntasError){
                Utils.showMyOkDialog(context, S.of(context).error, state.errorMessage, () => { Navigator.of(context).pop() });
              }
            },
          )
        )
    );
  }



  // Widget para construir la lista de preguntas
  Widget _buildQuestionsList(
      BuildContext context,
      int pageIndex,
      List<PreguntaDataModel> preguntasPagina,
      CategoriaPreguntaDataModel categoria,
      List<OpcionRespuestaDataModel> respuestas,
  ) {


    // Declara la lista fuera del bloque if-else
    List<dynamic> preguntasConObservaciones;

    // Llena la lista según la condición
    if (categoria.tieneObservaciones) {
      preguntasConObservaciones = [
        ...preguntasPagina, // Descompone la lista de preguntas y las agrega
        categoria, // Agrega la categoría
      ];
    } else {
      preguntasConObservaciones = preguntasPagina;
    }
    _observacionesCategoryController.text = categoria.observaciones ?? "";

    return Expanded(child:
      ListView.builder(
      itemCount: preguntasConObservaciones.length,
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        // Diferencia entre tipos
        final pregunta = preguntasConObservaciones[index];
        if (pregunta is PreguntaDataModel) {
          // Pregunta
          return MyListTile(
            text: pregunta.pregunta,
            listAnswers: respuestas,
            answerSelected: pregunta.idRespuestaSeleccionada != null
                ? respuestas.firstWhere(
                  (respuesta) => respuesta.idopcion == pregunta.idRespuestaSeleccionada,
              orElse: () => respuestas[0],
            )
                : null,
            onAnswerSelected: (answer) {
              pregunta.idRespuestaSeleccionada = answer.idopcion;
              pregunta.isAnswered = true;
            },
            onObservationsChanged: (observaciones) {
              pregunta.observaciones = observaciones;
              pregunta.isAnswered = true;
            },
            idDefaultAnswer: pregunta.idDefaultAnswer,
            isAnswered: pregunta.isAnswered,
            tieneObservaciones: pregunta.tieneObservaciones,
            observaciones: pregunta.observaciones ?? "",
            textoAux: pregunta.textoAux,
          );
        } else if (pregunta is CategoriaPreguntaDataModel) {
          return Column(
            children: [
              SizedBox(height: Dimensions.marginMedium),
              Text(
                S.of(context).observationsCateogoryTitle,
                style: TextStyle(color: Theme.of(context).colorScheme.onSecondary, fontSize: Dimensions.smallTextSize),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.marginMedium),
                child: MyTextFormField(
                  controller: _observacionesCategoryController,
                  hintText: S.of(context).observationsDesc,
                  onTextChanged: (observaciones) {
                    categoria.observaciones = observaciones;
                  },
                  numLines: 3,
                ),
              ),
              SizedBox(height: Dimensions.marginMedium),
            ],
          );
        }

        // En caso de que el tipo no sea reconocido
        return const SizedBox.shrink();
      },
    )
    );

  }

}

