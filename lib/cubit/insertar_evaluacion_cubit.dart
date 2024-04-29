import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../modelos/evaluacion_to_insert_dm.dart';
import '../repository/repositorio_db_supabase.dart';


// Define los estados para el cubit
abstract class EvaluacionState {}

class EvaluacionInicial extends EvaluacionState {}

class EvaluacionLoading extends EvaluacionState {
  EvaluacionLoading();
}

class EvaluacionInsertada extends EvaluacionState {
  final int idEvaluacion;

  EvaluacionInsertada(this.idEvaluacion);
}

class EvaluacionError extends EvaluacionState {
  final String errorMessage;

  EvaluacionError(this.errorMessage);
}

// Define el cubit
class EvaluacionCubit extends Cubit<EvaluacionState> {
  final RepositorioDBSupabase repositorio;
  EvaluacionCubit(this.repositorio) : super(EvaluacionInicial());

  Future<void> insertarEvaluacion(EvaluacionToInsertDataModel item, List<Uint8List> imagenes) async {
    emit(EvaluacionLoading());
    try {
      final idEvaluacion = await repositorio.insertarEvaluacion(item);
      repositorio.insertarImagenes(imagenes, idEvaluacion);
      emit(EvaluacionInsertada(idEvaluacion));
    } catch (e) {
      emit(EvaluacionError('Error al insertar la evaluación: $e'));
    }
  }
}

