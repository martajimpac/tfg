import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import '../../../core/utils/Constants.dart';
import '../../../core/utils/pdf.dart';
import '../../../generated/l10n.dart';
import '../../data/models/categoria_pregunta_dm.dart';
import '../../data/models/evaluacion_details_dm.dart';
import '../../data/models/opcion_respuesta_dm.dart';
import '../../data/models/pregunta_dm.dart';
import '../../data/repository/repositorio_db_supabase.dart';


// Define el estado del cubit
abstract class PreguntasState extends Equatable {
  const PreguntasState();

  @override
  List<Object> get props => [];
}

class PreguntasLoading extends PreguntasState {
  final String loadingMessage;

  const PreguntasLoading(this.loadingMessage);

  @override
  List<Object> get props => [loadingMessage];
}

class PreguntasLoaded extends PreguntasState {
  final int idEval;
  final int pageIndex;

  const PreguntasLoaded(this.idEval, this.pageIndex);

  @override
  List<Object> get props => [idEval, pageIndex];
}

class PreguntasError extends PreguntasState {
  final String errorMessage;

  const PreguntasError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

class PdfGenerated extends PreguntasState {
  final String pathFichero;

  const PdfGenerated(this.pathFichero);

  @override
  List<Object> get props => [pathFichero];
}

class PdfError extends PreguntasState {
  final String errorMessage;

  const PdfError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

// Define el cubit
class PreguntasCubit extends Cubit<PreguntasState> {
  final RepositorioDBSupabase repositorio;

  // Cache para almacenar las preguntas, categorías y respuestas cargadas por evaluación.
  List<PreguntaDataModel>? preguntas;
  List<CategoriaPreguntaDataModel>? categorias;
  List<OpcionRespuestaDataModel>? respuestas;
  int? _idEvalacionActual;
  bool? _isMaqMovil;
  bool? _isMaqCarga;
  bool? _isMaqMovilNew;
  bool? _isMaqCargaNew;


  PreguntasCubit(this.repositorio) : super(const PreguntasLoading(""));

  Future<List<PreguntaDataModel>> _getPreguntas(int idEvaluacion, bool isMaqMovil, bool isMaqCarga) async {
    // Si las preguntas ya están en el caché, y no hemos hecho cambios en el tipo de maquina, se devuelven directamente.
    if (preguntas != null && _idEvalacionActual == idEvaluacion) {
      bool configChanged = _isMaqMovil != isMaqMovil || _isMaqCarga != isMaqCarga;
      if(configChanged){

        if(removeMaqMovil()){
          preguntas?.removeWhere((p) => p.idCategoria == idMaqMovil1 || p.idCategoria == idMaqMovil2);
        }
        if(removeMaqCarga()){
          preguntas?.removeWhere((p) => p.idCategoria == idMaqCarga1 || p.idCategoria == idMaqCarga2);
        }

        if(addMaqMovil() || addMaqCarga()){
          //Añadir preguntas
          var preguntasNew = await repositorio.getPreguntas(idEvaluacion);
          preguntasNew = preguntasNew.where((p) => [idMaqMovil1, idMaqMovil2, idMaqCarga1, idMaqCarga2].contains(p.idCategoria)).toList();
          preguntas?.addAll(preguntasNew);
          return preguntas ?? []; // Añadir las nuevas preguntas después de las otras
        }

      }else{
        return preguntas ?? [];
      }
    }

    try {
      preguntas = await repositorio.getPreguntas(idEvaluacion);
      return preguntas ?? [];
    } catch (e) {
      return [];
    }
  }

  Future<List<CategoriaPreguntaDataModel>> _getCategorias(int idEvaluacion, int idMaquina, bool isMaqMovil, bool isMaqCarga) async {
    // Si las categorías ya están en el caché, se devuelven directamente.
    if (categorias != null && _idEvalacionActual == idEvaluacion) {
      bool configChanged = _isMaqMovil != isMaqMovil || _isMaqCarga != isMaqCarga;
      if(configChanged){

        // Eliminar maq móvil si corresponde
        if(removeMaqMovil()){
          categorias?.removeWhere((c) => c.idcat == idMaqMovil1 || c.idcat == idMaqMovil2);
        }

        // Eliminar maq carga si corresponde
        if(removeMaqCarga()){
          categorias?.removeWhere((c) => c.idcat == idMaqCarga1 || c.idcat == idMaqCarga2);
        }

        // Ver si se ha añadido alguna
        if(addMaqMovil() || addMaqCarga()){
          var categoriasNew = await repositorio.getCategorias(idEvaluacion, idMaquina);
          categoriasNew = categoriasNew.where((c) =>
              [idMaqMovil1, idMaqMovil2, idMaqCarga1, idMaqCarga2].contains(c.idcat)).toList();
          categorias?.addAll(categoriasNew);
        }


      }else{
        return categorias ?? [];
      }
    }

    try {
      categorias = await repositorio.getCategorias(idEvaluacion, idMaquina);
      debugPrint("marta cate $categorias");
      return categorias ?? [];
    } catch (e) {
      return [];
    }
  }

  Future<List<OpcionRespuestaDataModel>> _getRespuestas(int idEvaluacion, bool isMaqMovil, bool isMaqCarga) async {
    // Si las respuestas ya están en el caché, se devuelven directamente.
    if (respuestas != null && _idEvalacionActual == idEvaluacion) {
      return respuestas ?? [];
    }

    try {
      respuestas =  await repositorio.getRespuestas(); // Guardar en el caché
      return respuestas ?? [];
    } catch (e) {
      return [];
    }
  }

  Future<void> getPreguntas(BuildContext context, EvaluacionDetailsDataModel evaluacion, int pageIndex) async { //TOO SOLO EN EL INIT, LUEGO YA...
    _idEvalacionActual = evaluacion.ideval;
    _isMaqMovilNew = evaluacion.isMaqMovil;
    _isMaqCargaNew = evaluacion.isMaqCarga;
    try {
      emit(PreguntasLoading(""));
      final preguntas = await _getPreguntas(evaluacion.ideval, evaluacion.isMaqMovil, evaluacion.isMaqCarga);
      final categorias = await _getCategorias(evaluacion.ideval, evaluacion.idmaquina,   evaluacion.isMaqMovil, evaluacion.isMaqCarga);
      await _getRespuestas(evaluacion.ideval,  evaluacion.isMaqMovil, evaluacion.isMaqCarga);

      _isMaqCarga = evaluacion.isMaqCarga;
      _isMaqMovil = evaluacion.isMaqMovil;

      if (categorias.isEmpty || pageIndex < 0 || pageIndex >= categorias.length) {
        debugPrint("MARTA: Índice de página fuera de rango o categorías vacías.");
      }


      /*final categoria = categorias[pageIndex];
      final preguntasPagina = preguntas.where(
            (pregunta) => pregunta.idCategoria == categoria.idcat,
      ).toList();*/


      //debugPrint("MARTA: $categoria ${preguntasPagina.map((t) => t.idRespuestaSeleccionada).toList()}");


      emit(PreguntasLoaded(evaluacion.ideval, pageIndex));

    } catch (e) {
      emit(PreguntasError(S.of(context).cubitQuestionsError));
    }
  }

  void cambiarCategoria(int nuevoIndex) {
    final currentState = state;
    if (currentState is PreguntasLoaded) {
      emit(PreguntasLoaded(
        currentState.idEval,
        nuevoIndex,
      ));
    }
  }




  void clearCache() {
    preguntas = null;
    categorias = null;
    respuestas = null;
  }

  Future<void> insertarRespuestasAndGeneratePdf(BuildContext context, EvaluacionDetailsDataModel evaluacion, AccionesPdfChecklist accion)async {

    if (state is PreguntasLoaded) {

      final loadedState = state as PreguntasLoaded;

      emit(PreguntasLoading(S.of(context).sanvingAnswers));


      await repositorio.insertarRespuestas(preguntas ?? [], evaluacion.ideval, categorias ?? []);
      try {


        emit(PreguntasLoading(S.of(context).generatingPdf));
        String? pathFichero = await PdfHelper.generarInformePDF(
            evaluacion, preguntas ?? [], respuestas ?? [], categorias ?? []
        );

        if (pathFichero == null) {
          emit(PdfError(S.of(context).errorPdf));
        } else {
          emit(PdfGenerated(pathFichero));

          emit(PreguntasLoaded(_idEvalacionActual!, loadedState.pageIndex));

        }
      } catch (e) {
        emit(PdfError(S.of(context).errorPdf));
      }
    }
  }

  bool removeMaqMovil() {
    if(_isMaqMovil != null && _isMaqMovilNew != null){
      return (!_isMaqMovil! && _isMaqMovilNew!);
    }else{
      return false;
    }
  }

  bool removeMaqCarga() {
    if(_isMaqCarga != null && _isMaqCargaNew != null){
      return (!_isMaqCarga! && _isMaqCargaNew!);
    }else{
      return false;
    }
  }

  bool addMaqMovil() {
    if (_isMaqMovil != null && _isMaqMovilNew != null) {
      return (!_isMaqMovil! && _isMaqMovilNew!); // Antes no era móvil, ahora sí
    } else {
      return false;
    }
  }

  bool addMaqCarga() {
    if (_isMaqCarga != null && _isMaqCargaNew != null) {
      return (!_isMaqCarga! && _isMaqCargaNew!); // Antes no era carga, ahora sí
    } else {
      return false;
    }
  }


  void resetCubit() {
    emit(const PreguntasLoading(""));
  }
}

