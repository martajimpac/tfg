import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:evaluacionmaquinas/modelos/evaluacion_details_dm.dart';
import 'package:evaluacionmaquinas/modelos/evaluacion_list_dm.dart';
import 'package:evaluacionmaquinas/repository/repositorio_db_supabase.dart';

import '../modelos/imagen_dm.dart';

// Define el estado del cubit
abstract class DetallesEvaluacionState extends Equatable {
  const DetallesEvaluacionState();

  @override
  List<Object> get props => [];
}

class DetallesEvaluacionLoading extends DetallesEvaluacionState {}

class DetallesEvaluacionLoaded extends DetallesEvaluacionState {
  final EvaluacionDetailsDataModel evaluacion;
  final List<ImagenDataModel> imagenes;

  const DetallesEvaluacionLoaded(this.evaluacion, this.imagenes);

  @override
  List<Object> get props => [evaluacion];
}

class DetallesEvaluacionError extends DetallesEvaluacionState {
  final String errorMessage;

  const DetallesEvaluacionError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

// Define el cubit
class DetallesEvaluacionCubit extends Cubit<DetallesEvaluacionState> {
  final RepositorioDBSupabase repositorio;

  DetallesEvaluacionCubit(this.repositorio) : super(DetallesEvaluacionLoading());

  Future<void> getDetallesEvaluacion(int idEvaluacion) async {
    emit(DetallesEvaluacionLoading());
    try {
      final evaluacion = await repositorio.getDetallesEvaluacion(idEvaluacion);
      final imagenes = await repositorio.getImagenesEvaluacion(idEvaluacion);
      emit(DetallesEvaluacionLoaded(evaluacion, imagenes));
    } catch (e) {
      emit(DetallesEvaluacionError('Error al obtener la evaluación: $e'));
    }
  }
}
