import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../generated/l10n.dart';
import '../../data/models/evaluacion_details_dm.dart';
import '../../data/models/imagen_dm.dart';
import '../../data/repository/repositorio_db_supabase.dart';

// Define los estados para el cubit
abstract class InsertarEvaluacionState extends Equatable {
  const InsertarEvaluacionState();

  @override
  List<Object> get props => [];
}

class InsertarEvaluacionInicial extends InsertarEvaluacionState {}

class InsertarEvaluacionLoading extends InsertarEvaluacionState {}

class EvaluacionInsertada extends InsertarEvaluacionState {
  final EvaluacionDetailsDataModel evaluacion;
  final List<ImagenDataModel> imagenes;
  const EvaluacionInsertada(this.evaluacion, this.imagenes);

  @override
  List<Object> get props => [evaluacion, imagenes];
}

class InsertarEvaluacionError extends InsertarEvaluacionState {
  final String errorMessage;

  const InsertarEvaluacionError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

class CamposCheckError extends InsertarEvaluacionState {
  final String errorMessage;
  bool isFechasRed = false;
  bool isCentroRed = false;
  bool isNombreMaquinaRed = false;
  bool isNumeroSerieRed = false;

  CamposCheckError(this.errorMessage, this.isFechasRed, this.isCentroRed,
      this.isNombreMaquinaRed, this.isNumeroSerieRed);

  @override
  List<Object> get props => [
        errorMessage,
        isFechasRed,
        isCentroRed,
        isNombreMaquinaRed,
        isNumeroSerieRed
      ];
}

class CamposCheckSuccess extends InsertarEvaluacionState {}

// Define el cubit
class InsertarEvaluacionCubit extends Cubit<InsertarEvaluacionState> {
  final RepositorioDBSupabase repositorio;
  InsertarEvaluacionCubit(this.repositorio)
      : super(InsertarEvaluacionInicial());

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
      bool isMaqMovil,
      bool isMaqCarga,
      List<Uint8List> imagenes) async {
    emit(InsertarEvaluacionLoading());

    try {
      final idMaquina = await repositorio.insertarMaquina(
          nombreMaquina, fabricante, numeroSerie, isMaqMovil, isMaqCarga);

      final idEvaluacion = await repositorio.insertarEvaluacion(
          idMaquina,
          idInspector,
          idCentro,
          idTipoEval,
          fechaRealizacion,
          fechaCaducidad,
          fechaFabricacion,
          fechaPuestaServicio);
      EvaluacionDetailsDataModel evaluacion = EvaluacionDetailsDataModel(
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
          numeroSerie: numeroSerie,
          isMaqCarga: isMaqCarga,
          isMaqMovil: isMaqMovil);

      //TODO usar supabase storage para imágnes
      //final listImagenesIds = await repositorio.insertarImagenesUrl(imagenes, idEvaluacion);

      final listImagenesIds = await repositorio.insertarImagenes(imagenes, idEvaluacion);
      emit(EvaluacionInsertada(evaluacion, listImagenesIds));

      emit(InsertarEvaluacionInicial());
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
      bool isMaqMovil,
      bool isMaqCarga,
      List<ImagenDataModel> imagenes) async {
    emit(InsertarEvaluacionLoading());

    try {
      await repositorio.modificarMaquina(idMaquina, nombreMaquina, fabricante,
          numeroSerie, isMaqMovil, isMaqCarga);

      await repositorio.modificarEvaluacion(
          idEvaluacion,
          idCentro,
          idTipoEval,
          fechaModificacion,
          fechaCaducidad,
          fechaFabricacion,
          fechaPuestaServicio);

      ///ELIMINAR IMAGENES
      //si algun id de las imagenes anteriores no está en los ids de imagenes nuevas hay que eliminar esa imagen
      List<int?> idsNuevasImagenes =
          imagenes.map((imageModel) => imageModel.idimg).toList();
      List<int> idsImagenesAnteriores =
          await repositorio.getIdsImagenesEvaluacion(idEvaluacion);
      List<int> idsImagesToDelete = idsImagenesAnteriores
          .where((id) => !idsNuevasImagenes.contains(id))
          .toList();
      await repositorio.eliminarImagenes(idsImagesToDelete);

      ///AÑADIR NUEVAS
      //si las imagenes no tienen id las insertamos porque significa que no estan insertadas aún
      List<ImagenDataModel> imagenesInsertar =
          imagenes.where((imagen) => imagen.idimg == null).toList();
      final listImagenesIds = await repositorio.insertarImagenesUrl(
          imagenesInsertar.map((imageModel) => imageModel.imagen!).toList(),
          idEvaluacion);

      //TODO usar supabase storage para imágnes
      //final listImagenesIds = await repositorio.insertarImagenesUrl(imagenesInsertar.map((imageModel) => imageModel.imagen!).toList(), idEvaluacion);

      // Actualizar los ids de las imagenes que acabamos de eliminar
      imagenes.removeWhere((imagen) => imagen.idimg == null);

      // Añadir los ids correctos
      imagenes.addAll(listImagenesIds);

      //creamos el objeto evaluación
      EvaluacionDetailsDataModel evaluacion = EvaluacionDetailsDataModel(
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
          numeroSerie: numeroSerie,
          isMaqCarga: isMaqCarga,
          isMaqMovil: isMaqMovil);
      emit(EvaluacionInsertada(evaluacion, imagenes));
    } catch (e) {
      emit(InsertarEvaluacionError(
          S.of(context).cubitInsertEvaluationsModifyError));
    }
  }

/*  void showCheck(
      int? idCentro ,
      String nombreCentro,
      String denominacion,
      String numeroSerie,
      DateTime? fechaFabricacion,
      DateTime? fechaPuestaServicio,
      BuildContext context,
  ){

    bool isFechasRed = false;
    bool isCentroRed = false;
    bool isNombreMaquinaRed = false;
    bool isNumeroSerieRed = false;

    if (idCentro == null  || nombreCentro == "" || denominacion == "" || numeroSerie == "") {
      // Lista para almacenar los nombres de los campos que son null
      List<String> camposNull = [];

      // Verificar cada campo y agregar su nombre a la lista si es null
      if (idCentro == null || nombreCentro == "") {
        camposNull.add(S.of(context).center);
        isCentroRed = true;
      }
      if (denominacion == "") {
        camposNull.add(S.of(context).denomination);
        isNombreMaquinaRed = true;
      }
      if (numeroSerie == "") {
        camposNull.add(S.of(context).serialNumber);
        isNumeroSerieRed = true;
      }

      // Construir el mensaje de error
      String errorMessage = S.of(context).errorMandatoryFields;
      errorMessage += camposNull.join('\n');

      // Mostrar el diálogo con el mensaje de error
      Utils.showMyOkDialog(context, S.of(context).error, errorMessage, () =>  Navigator.of(context).pop());
    }else if(idCentro == -1){
      isFechasRed = false;
      isCentroRed = true;
      isNumeroSerieRed = false;
      isNumeroSerieRed = false;

      String errorMessage = S.of(context).errorCenterDoesntMatch;

      // Mostrar el diálogo con el mensaje de error
      Utils.showMyOkDialog(context, S.of(context).error, errorMessage, () =>  Navigator.of(context).pop());
    } else if(fechaFabricacion != null && fechaPuestaServicio != null){

      if(fechaFabricacion.isBefore(fechaPuestaServicio) || fechaFabricacion == fechaPuestaServicio){
        _showResume(context);
      }else{
        isFechasRed = true;
        isCentroRed = false;
        isNumeroSerieRed = false;
        isNumeroSerieRed = false;

        // Mostrar el diálogo con el mensaje de error
        Utils.showMyOkDialog(context, S.of(context).error, S.of(context).errorComissioningDate, () =>  Navigator.of(context).pop());
      }

    }else{
      _showResume(context);
    }
  }*/
}
