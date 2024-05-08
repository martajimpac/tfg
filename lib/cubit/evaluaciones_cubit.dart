import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:evaluacionmaquinas/modelos/evaluacion_details_dm.dart';
import 'package:evaluacionmaquinas/modelos/evaluacion_list_dm.dart';
import 'package:evaluacionmaquinas/repository/repositorio_db_supabase.dart';

// Define el estado del cubit
abstract class EvaluacionesState extends Equatable {
  const EvaluacionesState();

  @override
  List<Object> get props => [];
}

class EvaluacionesLoading extends EvaluacionesState {}

class EvaluacionesLoaded extends EvaluacionesState {
  final List<ListEvaluacionDataModel> evaluaciones;

  const EvaluacionesLoaded(this.evaluaciones);

  @override
  List<Object> get props => [evaluaciones];
}

class EvaluacionesError extends EvaluacionesState {
  final String errorMessage;

  const EvaluacionesError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

// Define el cubit
class EvaluacionesCubit extends Cubit<EvaluacionesState> {
  final RepositorioDBSupabase repositorio;

  EvaluacionesCubit(this.repositorio) : super(EvaluacionesLoading());

  Future<void> getEvaluaciones() async {
    try {
      final evaluaciones = await repositorio.getListaEvaluaciones();
      /*if (kDebugMode) {
        print("evaluaciones: ${evaluaciones.map((e) => e.imagen)}");
      }*/
      emit(EvaluacionesLoaded(evaluaciones));
    } catch (e) {
      emit(EvaluacionesError('Error al obtener las evaluaciones: $e'));
    }
  }
}
