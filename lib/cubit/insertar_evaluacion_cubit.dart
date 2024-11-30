import 'dart:typed_data';

import 'package:evaluacionmaquinas/modelos/evaluacion_details_dm.dart';
import 'package:evaluacionmaquinas/modelos/evaluacion_list_dm.dart';
import 'package:evaluacionmaquinas/modelos/imagen_dm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../generated/l10n.dart';
import '../repository/repositorio_db_supabase.dart';


// Define los estados para el cubit
abstract class InsertarEvaluacionState {}

class InsertarEvaluacionInicial extends InsertarEvaluacionState {}

class InsertarEvaluacionLoading extends InsertarEvaluacionState {
  InsertarEvaluacionLoading();
}

class EvaluacionInsertada extends InsertarEvaluacionState {
  final EvaluacionDetailsDataModel evaluacion;
  final List<ImagenDataModel> imagenes;
  EvaluacionInsertada(this.evaluacion, this.imagenes);
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
      BuildContext context,
      String idInspector,
      int idCentro,
      String nombreCentro,
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
      EvaluacionDetailsDataModel evaluacion =
        EvaluacionDetailsDataModel(
          ideval: idEvaluacion,
          idinspector: idInspector,
          idcentro: idCentro,
          nombreCentro: nombreCentro,
          fechaRealizacion: fechaRealizacion,
          fechaCaducidad: fechaCaducidad,
          fechaModificacion: null,
          idmaquina: idMaquina,
          nombreMaquina: nombreMaquina,
          idtipoeval: idTipoEval,
          fechaFabricacion: fechaFabricacion,
          fechaPuestaServicio: fechaPuestaServicio,
          fabricante: fabricante,
          numeroSerie: numeroSerie
        );
      final listImagenesIds = await repositorio.insertarImagenes(imagenes, idEvaluacion);
      emit(EvaluacionInsertada(evaluacion, listImagenesIds));
    } catch (e) {
      emit(InsertarEvaluacionError(S.of(context).cubitInsertEvaluationsError));
    }

  }

  Future<void> modificarEvaluacion(
      BuildContext context,
      String idInspector,
      int idEvaluacion,
      int idCentro,
      String nombreCentro,
      int idTipoEval,
      DateTime fechaRealizacion,
      DateTime fechaModificacion,
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
          fechaModificacion,
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
      debugPrint("MARTA imagenes IMAGEIDS ${listImagenesIds} ");
      imagenes.addAll(listImagenesIds);

      debugPrint("MARTA IMAGENES ${imagenes} ");
      //creamos el objeto evaluación
      EvaluacionDetailsDataModel evaluacion =
      EvaluacionDetailsDataModel(
          ideval: idEvaluacion,
          idinspector: idInspector,
          idcentro: idCentro,
          nombreCentro: nombreCentro,
          fechaRealizacion: fechaRealizacion,
          fechaCaducidad: fechaCaducidad,
          fechaModificacion: null,
          idmaquina: idMaquina,
          nombreMaquina: nombreMaquina,
          idtipoeval: idTipoEval,
          fechaFabricacion: fechaFabricacion,
          fechaPuestaServicio: fechaPuestaServicio,
          fabricante: fabricante,
          numeroSerie: numeroSerie
      );
      debugPrint("MARTA imágenes antes de emitir el estado: ${imagenes}");
      emit(EvaluacionInsertada(evaluacion, imagenes));
    } catch (e) {
      debugPrint("MARTA ERROR");
      emit(InsertarEvaluacionError(S.of(context).cubitInsertEvaluationsModifyError));
    }

  }
}

