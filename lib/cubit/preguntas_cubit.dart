import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:evaluacionmaquinas/modelos/categoria_pregunta_dm.dart';
import 'package:evaluacionmaquinas/repository/repositorio_db_supabase.dart';

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

  const PreguntasLoaded(this.preguntas, this.categorias);

  @override
  List<Object> get props => [preguntas];
}

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

  Future<void> getPreguntas() async {
    try {
      final preguntas = await repositorio.getPreguntas(null);
      final categorias = await repositorio.getCategorias();

      // Convertir el mapa de preguntas únicas de nuevo en una lista
      emit(PreguntasLoaded(preguntas, categorias));
    } catch (e) {
      emit(PreguntasError('Error al obtener las preguntas: $e'));
    }
  }
}
