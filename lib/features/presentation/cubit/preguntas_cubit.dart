import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
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
  final List<PreguntaDataModel> preguntas;
  final List<CategoriaPreguntaDataModel> categorias;
  final List<OpcionRespuestaDataModel> respuestas;
  final int idEval;

  const PreguntasLoaded(this.preguntas, this.categorias, this.respuestas, this.idEval);

  @override
  List<Object> get props => [preguntas, categorias, respuestas, idEval];
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

  PreguntasCubit(this.repositorio) : super(const PreguntasLoading(""));

  Future<void> getPreguntas(BuildContext context, int idEvaluacion) async {
    if (state is PreguntasLoaded && (state as PreguntasLoaded).idEval == idEvaluacion) {
      // Si las preguntas de la evaluacion actual ya están cargadas, no hacemos nada
      return;
    }

    try {
      emit(PreguntasLoading(S.of(context).cubitQuestionsLoading)); // Emitir estado de carga
      List<PreguntaDataModel> preguntas;

      preguntas = await repositorio.getPreguntasRespuesta(idEvaluacion);

      final categorias = await repositorio.getCategorias();
      final respuestas = await repositorio.getRespuestas();

      emit(PreguntasLoaded(preguntas, categorias, respuestas, idEvaluacion));
    } catch (e) {
      emit(PreguntasError(S.of(context).cubitQuestionsError));
    }
  }
  void updatePreguntas(PreguntaDataModel updatedPregunta) {
    if (state is PreguntasLoaded) {
      final loadedState = state as PreguntasLoaded;
      final updatedPreguntas = loadedState.preguntas.map((pregunta) {
        return pregunta.idpregunta == updatedPregunta.idpregunta ? updatedPregunta : pregunta;
      }).toList();

      emit(PreguntasLoaded(updatedPreguntas, loadedState.categorias, loadedState.respuestas, loadedState.idEval));
    }
  }

  Future<void> insertarRespuestasAndGeneratePdf(
      BuildContext context,
      EvaluacionDetailsDataModel evaluacion,
      AccionesPdfChecklist accion
  )async {

    if (state is PreguntasLoaded) {

      final loadedState = state as PreguntasLoaded;

      emit(PreguntasLoading(S.of(context).generatingPdf));

      await repositorio.insertarRespuestas(loadedState.preguntas, evaluacion.ideval);
      try {

        String? pathFichero = await PdfHelper.generarInformePDF(
            evaluacion, loadedState.preguntas, loadedState.respuestas, loadedState.categorias
        );

        if (pathFichero == null) {
          emit(PdfError(S.of(context).errorPdf));
        } else {
          emit(PdfGenerated(pathFichero));

          //RESTAURAR EL ESTADO DEL CUBIT
          emit(PreguntasLoaded(loadedState.preguntas, loadedState.categorias, loadedState.respuestas, loadedState.idEval));
        }
      } catch (e) {
        debugPrint('MARTA Excepcion PDF: $e');
        emit(PdfError(S.of(context).errorPdf));
      }
    }
  }

  void deletePreguntas() {
    emit(const PreguntasLoading("")); // Restablece el estado a PreguntasLoading
  }
}
