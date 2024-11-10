import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:evaluacionmaquinas/modelos/evaluacion_details_dm.dart';
import 'package:evaluacionmaquinas/modelos/evaluacion_list_dm.dart';
import 'package:evaluacionmaquinas/modelos/opcion_respuesta_dm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:evaluacionmaquinas/modelos/categoria_pregunta_dm.dart';
import 'package:evaluacionmaquinas/repository/repositorio_db_supabase.dart';
import 'package:pdf/widgets.dart';

import '../generated/l10n.dart';
import '../modelos/pregunta_dm.dart';
import '../utils/Constants.dart';
import '../utils/pdf.dart';

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

  PreguntasCubit(this.repositorio) : super(const PreguntasLoading("Cargando las preguntas..."));

  Future<void> getPreguntas(BuildContext context, int idEvaluacion) async {
    if (state is PreguntasLoaded && (state as PreguntasLoaded).idEval == idEvaluacion) {
      // Si las preguntas de la evaluacion actual ya están cargadas, no hacemos nada
      return;
    }

    try {
      emit(const PreguntasLoading("Cargando las preguntas...")); // Emitir estado de carga
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

  Future<void> insertarRespuestasAndGeneratePdf(EvaluacionDetailsDataModel evaluacion, AccionesPdfChecklist accion)async {

    if (state is PreguntasLoaded) {

      final loadedState = state as PreguntasLoaded;

      emit(const PreguntasLoading("Generando el pdf..."));

      await repositorio.insertarRespuestas(loadedState.preguntas, evaluacion.ideval);
      try {

        String? pathFichero = await PdfHelper.generarInformePDF(
            evaluacion, loadedState.preguntas, loadedState.respuestas, loadedState.categorias
        );

        if (pathFichero == null) {
          emit(const PdfError("Se ha producido un error al generar el pdf.")); //TODO STRINGS
        } else {
          emit(PdfGenerated(pathFichero));

          //RESTAURAR EL ESTADO DEL CUBIT
          emit(PreguntasLoaded(loadedState.preguntas, loadedState.categorias, loadedState.respuestas, loadedState.idEval));
        }
      } catch (e) {
        debugPrint('MARTA Excepcion PDF: $e');
        emit(const PdfError("Se ha producido un error al generar el pdf."));
      }
    }
  }

  void deletePreguntas() {
    emit(const PreguntasLoading("")); // Restablece el estado a PreguntasLoading
  }
}
