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
  final List<PreguntaDataModel> preguntasPorPagina;
  final CategoriaPreguntaDataModel categoria;
  final int idEval;
  final int pageIndex;

  const PreguntasLoaded(this.preguntasPorPagina, this.categoria, this.idEval, this.pageIndex);

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

  PreguntasCubit(this.repositorio) : super(const PreguntasLoading(""));

  Future<List<PreguntaDataModel>> _getPreguntas(int idEvaluacion) async {
    // Si las preguntas ya están en el caché, se devuelven directamente.
    if (preguntas != null && _idEvalacionActual == idEvaluacion) {
      return preguntas ?? [];
    }

    try {
      preguntas = await repositorio.getPreguntas(idEvaluacion);
      return preguntas ?? [];
    } catch (e) {
      return [];
    }
  }

  Future<List<CategoriaPreguntaDataModel>> _getCategorias(int idEvaluacion) async {
    // Si las categorías ya están en el caché, se devuelven directamente.
    if (categorias != null && _idEvalacionActual == idEvaluacion) {
      return categorias ?? [];
    }

    try {
      categorias = await repositorio.getCategorias(idEvaluacion);
      return categorias ?? [];
    } catch (e) {
      return [];
    }
  }

  Future<List<OpcionRespuestaDataModel>> _getRespuestas(int idEvaluacion) async {
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

  Future<void> getPreguntas(BuildContext context, int idEvaluacion, int pageIndex) async { //TOO SOLO EN EL INIT, LUEGO YA...
    _idEvalacionActual = idEvaluacion;
    try {
      emit(PreguntasLoading(""));
      final preguntas = await _getPreguntas(idEvaluacion);
      final categorias = await _getCategorias(idEvaluacion);
      await _getRespuestas(idEvaluacion);

      if (categorias.isEmpty || pageIndex < 0 || pageIndex >= categorias.length) {
        debugPrint("MARTA: Índice de página fuera de rango o categorías vacías.");
      }


      final categoria = categorias[pageIndex];
      final preguntasPagina = preguntas.where(
            (pregunta) => pregunta.idCategoria == categoria.idcat,
      ).toList();




      emit(PreguntasLoaded(preguntasPagina,categoria, idEvaluacion, pageIndex));

    } catch (e) {
      emit(PreguntasError(S.of(context).cubitQuestionsError));
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

      emit(PreguntasLoading(S.of(context).generatingPdf));


      await repositorio.insertarRespuestas(preguntas ?? [], evaluacion.ideval, categorias ?? []);
      try {

        String? pathFichero = await PdfHelper.generarInformePDF(
            evaluacion, preguntas ?? [], respuestas ?? [], categorias ?? []
        );

        if (pathFichero == null) {
          emit(PdfError(S.of(context).errorPdf));
        } else {
          emit(PdfGenerated(pathFichero));

          emit(PreguntasLoaded(loadedState.preguntasPorPagina, loadedState.categoria, _idEvalacionActual!, loadedState.pageIndex));

        }
      } catch (e) {
        emit(PdfError(S.of(context).errorPdf));
      }
    }
  }


  void deletePreguntas() {
    emit(const PreguntasLoading(""));
  }
}

