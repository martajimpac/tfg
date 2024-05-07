import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:evaluacionmaquinas/repository/repositorio_db_supabase.dart';

abstract class EliminarEvaluacionState {}

class EliminarEvaluacionInicial extends EliminarEvaluacionState {}

class EliminarEvaluacionLoading extends EliminarEvaluacionState {}

class EliminarEvaluacionCompletada extends EliminarEvaluacionState {}

class EliminarEvaluacionError extends EliminarEvaluacionState {
  final String errorMessage;

  EliminarEvaluacionError(this.errorMessage);
}

// Define el cubit
class EliminarEvaluacionCubit extends Cubit<EliminarEvaluacionState> {
  final RepositorioDBSupabase repositorio;
  EliminarEvaluacionCubit(this.repositorio) : super(EliminarEvaluacionInicial());

  Future<void> eliminarEvaluacion(int idEvaluacion) async {
    emit(EliminarEvaluacionLoading());
    try {
      await repositorio.eliminarEvaluacion(idEvaluacion);
      emit(EliminarEvaluacionCompletada());
    } catch (e) {
      emit(EliminarEvaluacionError('Error al eliminar la evaluación: $e'));
    }
  }
}
