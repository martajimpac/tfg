import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/repositorio_db_supabase.dart';


// Define los estados para el cubit
abstract class InsertarEvaluacionState {}

class InsertarEvaluacionInicial extends InsertarEvaluacionState {}

class InsertarEvaluacionLoading extends InsertarEvaluacionState {
  InsertarEvaluacionLoading();
}

class EvaluacionInsertada extends InsertarEvaluacionState {
  final int idEvaluacion;
  final int idMaquina;
  EvaluacionInsertada(this.idEvaluacion, this.idMaquina);
}

class InsertarEvaluacionError extends InsertarEvaluacionState {
  final String errorMessage;

  InsertarEvaluacionError(this.errorMessage);
}

// Define el cubit
class InsertarEvaluacionCubit extends Cubit<InsertarEvaluacionState> {
  final RepositorioDBSupabase repositorio;
  InsertarEvaluacionCubit(this.repositorio) : super(InsertarEvaluacionInicial());

  Future<void> insertarEvaluacion(
      String idInspector,
      int idCentro,
      int idTipoEval,
      DateTime fechaRealizacion,
      DateTime fechaCaducidad,
      DateTime? fechaFabricacion,
      DateTime? fechaPuestaServicio,
      String nombreMaquina,
      String fabricante,
      String numeroSerie,
      List<Uint8List> imagenes) async {
    emit(InsertarEvaluacionLoading());

    try {
      final idMaquina = await repositorio.insertarMaquina(nombreMaquina, fabricante, numeroSerie);

      final idEvaluacion = await repositorio.insertarEvaluacion(
          idMaquina,
          idInspector,
          idCentro,
          idTipoEval,
          fechaRealizacion,
          fechaCaducidad,
          fechaFabricacion,
          fechaPuestaServicio
      );
      repositorio.insertarImagenes(imagenes, idEvaluacion);
      emit(EvaluacionInsertada(idEvaluacion, idMaquina));
    } catch (e) {
      emit(InsertarEvaluacionError('Error al insertar la evaluación: $e'));
    }

  }
}

