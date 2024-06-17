import 'dart:typed_data';

import 'package:evaluacionmaquinas/modelos/imagen_dm.dart';
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
  final List<ImagenDataModel> imagenes;
  EvaluacionInsertada(this.idEvaluacion, this.idMaquina, this.imagenes);
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
      final listImagenesIds = await repositorio.insertarImagenes(imagenes, idEvaluacion);
      emit(EvaluacionInsertada(idEvaluacion, idMaquina, listImagenesIds));
    } catch (e) {
      emit(InsertarEvaluacionError('Error al insertar la evaluación: $e'));
    }

  }

  Future<void> modificarEvaluacion(
      int idEvaluacion,
      int idCentro,
      int idTipoEval,
      DateTime fechaRealizacion,
      DateTime fechaCaducidad,
      DateTime? fechaFabricacion,
      DateTime? fechaPuestaServicio,
      int idMaquina,
      String nombreMaquina,
      String fabricante,
      String numeroSerie,
      List<ImagenDataModel> imagenes) async {
    emit(InsertarEvaluacionLoading());

    try {
      await repositorio.modificarMaquina(idMaquina, nombreMaquina, fabricante, numeroSerie);

      await repositorio.modificarEvaluacion(
          idEvaluacion,
          idCentro,
          idTipoEval,
          fechaRealizacion,
          fechaCaducidad,
          fechaFabricacion,
          fechaPuestaServicio
      );

      //si algun id de las imagenes anteriores no está en los ids de imagenes nuevas hay que eliminar esa imagen
      List<int?> idsNuevasImagenes = imagenes.map((imageModel) => imageModel.idimg).toList();
      List<int> idsImagenesAnteriores = await repositorio.getIdsImagenesEvaluacion(idEvaluacion);
      List<int> idsImagesToDelete = idsImagenesAnteriores.where((id) => !idsNuevasImagenes.contains(id)).toList();
      await repositorio.eliminarImagenes(idsImagesToDelete);


      //si las imagenes no tienen id las insertamos porque significa que no estan insertadas aún
      List<ImagenDataModel> imagenesInsertar = imagenes.where((imagen) => imagen.idimg == null).toList();
      final listImagenesIds = await repositorio.insertarImagenes(imagenesInsertar.map((imageModel) => imageModel.imagen).toList(), idEvaluacion);
      // Actualizar los ids de las imagenes que acabamos de eliminar
      imagenes.removeWhere((imagen) => imagen.idimg == null);
      imagenes.addAll(listImagenesIds);

      emit(EvaluacionInsertada(idEvaluacion, idMaquina, imagenes));
    } catch (e) {
      emit(InsertarEvaluacionError('Error al modificar la evaluación: $e'));
    }

  }
}

