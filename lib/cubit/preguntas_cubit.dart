import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:evaluacionmaquinas/modelos/opcion_respuesta_dm.dart';
import 'package:flutter/foundation.dart';
import 'package:evaluacionmaquinas/modelos/categoria_pregunta_dm.dart';
import 'package:evaluacionmaquinas/repository/repositorio_db_supabase.dart';
import 'package:pdf/widgets.dart';

import '../modelos/pregunta_categoria_dm.dart';

// Define el estado del cubit
abstract class PreguntasState extends Equatable {
  const PreguntasState();

  @override
  List<Object> get props => [];
}

class PreguntasLoading extends PreguntasState {}

class PreguntasLoaded extends PreguntasState {
  final List<PreguntaDataModel> preguntas;
  final List<CategoriaPreguntaDataModel> categorias;
  final List<OpcionRespuestaDataModel> respuestas;

  const PreguntasLoaded(this.preguntas, this.categorias, this.respuestas);

  @override
  List<Object> get props => [preguntas];
}

class PreguntasSaved extends PreguntasState {}

class PreguntasError extends PreguntasState {
  final String errorMessage;

  const PreguntasError(this.errorMessage);

@override
  List<Object> get props => [errorMessage];
}

// Define el cubit
class PreguntasCubit extends Cubit<PreguntasState> {
  final RepositorioDBSupabase repositorio;

  PreguntasCubit(this.repositorio) : super(PreguntasLoading());

  Future<void> getPreguntas(int? idEvaluacion) async { //TODO AQUI NO HACE FALTA EL ?
    if (state is PreguntasLoaded) {
      // Si el estado actual ya tiene preguntas, no hacemos nada
      return;
    }

    try {
      emit(PreguntasLoading()); // Emitir estado de carga

      final preguntas = await repositorio.getPreguntasRespuesta(idEvaluacion);
      final categorias = await repositorio.getCategorias();
      final respuestas = await repositorio.getRespuestas();

      emit(PreguntasLoaded(preguntas, categorias, respuestas));
    } catch (e) {
      emit(PreguntasError('Error al obtener las preguntas: $e'));
    }
  }
  void updatePreguntas(PreguntaDataModel updatedPregunta) {
    if (state is PreguntasLoaded) {
      final loadedState = state as PreguntasLoaded;
      final updatedPreguntas = loadedState.preguntas.map((pregunta) {
        return pregunta.idpregunta == updatedPregunta.idpregunta ? updatedPregunta : pregunta;
      }).toList();

      emit(PreguntasLoaded(updatedPreguntas, loadedState.categorias, loadedState.respuestas));
    }
  }

  Future<void> insertarRespuestas(int idEvaluacion)async {
    if (state is PreguntasLoaded) {
      final loadedState = state as PreguntasLoaded;
      await repositorio.insertarRespuestas(loadedState.preguntas, idEvaluacion);
      emit(PreguntasSaved());

      emit(PreguntasLoaded(loadedState.preguntas, loadedState.categorias, loadedState.respuestas));
    }
  }

  void deletePreguntas() {
    emit(PreguntasLoading()); // Restablece el estado a PreguntasLoading
  }
}
