import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../../core/utils/pdf.dart';
import '../../../generated/l10n.dart';
import '../../data/models/evaluacion_details_dm.dart';
import '../../data/models/imagen_dm.dart';
import '../../data/repository/repositorio_db_supabase.dart';

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
  List<Object> get props => [evaluacion, imagenes];
}

class DetallesEvaluacionError extends DetallesEvaluacionState {
  final String errorMessage;

  const DetallesEvaluacionError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

class DetallesEvaluacionPdfGenerated extends DetallesEvaluacionState {
  final String pathFichero;

  const DetallesEvaluacionPdfGenerated(this.pathFichero);
  @override
  List<Object> get props => [pathFichero];
}

class DetallesEvaluacionPdfError extends DetallesEvaluacionState {
  final String errorMessage;

  const DetallesEvaluacionPdfError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

// Define el cubit
class DetallesEvaluacionCubit extends Cubit<DetallesEvaluacionState> {
  final RepositorioDBSupabase repositorio;

  DetallesEvaluacionCubit(this.repositorio) : super(DetallesEvaluacionLoading());

  Future<void> getDetallesEvaluacion(BuildContext context, idEvaluacion) async {
    emit(DetallesEvaluacionLoading());
    try {
      final evaluacion = await repositorio.getDetallesEvaluacion(idEvaluacion);
      final imagenes = await repositorio.getImagenesEvaluacion(idEvaluacion);
      emit(DetallesEvaluacionLoaded(evaluacion, imagenes));
    } catch (e) {
      emit(DetallesEvaluacionError(S.of(context).cubitEvaluationDetailsError));
    }
  }

    Future<void> generatePdf(BuildContext context, EvaluacionDetailsDataModel evaluacion) async {
    emit(DetallesEvaluacionLoading());
    try {
      final preguntas = await repositorio.getPreguntas(evaluacion.ideval);
      final categorias = await repositorio.getCategorias(evaluacion.ideval, evaluacion.idmaquina);
      final respuestas = await repositorio.getRespuestas();

      String? pathFichero = await PdfHelper.generarInformePDF(
          evaluacion, preguntas, respuestas, categorias
      );

      if (pathFichero == null) {
        emit(DetallesEvaluacionPdfError(S.of(context).cubitEvaluationDetailsError));
      } else {
        emit(DetallesEvaluacionPdfGenerated(pathFichero));

        //RESTAURAR EL ESTADO DEL CUBIT
        //emit(PreguntasLoaded(loadedState.preguntas, loadedState.categorias, loadedState.respuestas));
      }
    } catch (e) {
      emit(DetallesEvaluacionError(S.of(context).cubitEvaluationDetailsError));
    }
  }
}
