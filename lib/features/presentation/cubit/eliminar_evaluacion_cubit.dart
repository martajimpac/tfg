
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/almacenamiento.dart ';
import '../../../generated/l10n.dart';
import '../../data/repository/repositorio_db_supabase.dart';


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

  Future<void> eliminarEvaluacion(BuildContext context, idEvaluacion, int idMaquina) async {
    emit(EliminarEvaluacionLoading());
    try {
      await repositorio.eliminarEvaluacion(idEvaluacion);
      await repositorio.eliminarMaquina(idMaquina);
      await deleteFileFromIdEval(idEvaluacion);
      emit(EliminarEvaluacionCompletada());
      emit(EliminarEvaluacionInicial());
    } catch (e) {
      emit(EliminarEvaluacionError(S.of(context).cubitDeleteEvaluationError));
      emit(EliminarEvaluacionInicial());
    }
  }
}
