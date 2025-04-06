import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:evaluacionmaquinas/features/data/models/centro_dm.dart';
import 'package:flutter/cupertino.dart';

import '../../../core/utils/Constants.dart';
import '../../../core/utils/almacenamiento.dart ';
import '../../data/shared_prefs.dart';
import '../../../generated/l10n.dart';
import '../../data/models/evaluacion_list_dm.dart';
import '../../data/repository/repositorio_db_supabase.dart';

// Define el estado del cubit
abstract class EvaluacionesState extends Equatable {
  const EvaluacionesState();

  @override
  List<Object> get props => [];
}

class EvaluacionesLoading extends EvaluacionesState {}

class EvaluacionesLoaded extends EvaluacionesState {
  const EvaluacionesLoaded();

}

class EvaluacionesError extends EvaluacionesState {
  final String errorMessage;

  const EvaluacionesError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

class EvaluacionesDeleteLoading extends EvaluacionesState {}

class
EvaluacionesDeleteSuccess extends EvaluacionesState {}

class EvaluacionesDeleteError extends EvaluacionesState {
  final String errorMessage;

  const EvaluacionesDeleteError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

// Define el cubit
class EvaluacionesCubit extends Cubit<EvaluacionesState> {
  final RepositorioDBSupabase repositorio;
  final Map<String, dynamic> filtros = {};
  List<EvaluacionDataModel> evaluaciones = [];
  List<EvaluacionDataModel> evaluacionesFiltered = [];
  bool sortedByDate = true;
  bool sortDateDescendent = true;
  bool sortNameDescendent = true;

  EvaluacionesCubit(this.repositorio) : super(EvaluacionesLoading());

  Future<void> getEvaluaciones(BuildContext context) async {
    try {
      emit(EvaluacionesLoading());

      final id = await SharedPrefs.getUserId();
      evaluaciones = await repositorio.getListaEvaluaciones(id);

      evaluacionesFiltered = evaluaciones;
      // Filtrar las evaluaciones con los filtros
      if (filtros[filtroCentro] != null) {
        if (filtros[filtroCentro] is CentroDataModel) {
          final centro = filtros[filtroCentro] as CentroDataModel;
          evaluacionesFiltered = evaluacionesFiltered.where((evaluacion) => evaluacion.idCentro == centro.idCentro).toList();
        }
      }

      if (filtros[filtroFechaRealizacion] != null) {
        evaluacionesFiltered = evaluacionesFiltered.where((evaluacion) => evaluacion.fechaRealizacion.isAfter(filtros[filtroFechaRealizacion])).toList();
      }

      if (filtros[filtroFechaCaducidad] != null) {
        evaluacionesFiltered = evaluacionesFiltered.where((evaluacion) => evaluacion.fechaCaducidad.isBefore(filtros[filtroFechaCaducidad])).toList();
      }

      // Ordenar por defecto al iniciar
      evaluacionesFiltered.sort((a, b) {
        // Ordenar por fecha de realización en orden descendente
        return a.fechaRealizacion.compareTo(b.fechaRealizacion);
      });

      // Emitir el estado con los filtros y evaluaciones almacenadas en el cubit
      emit(EvaluacionesLoaded());
    } catch (e) {
      emit(EvaluacionesError(S.of(context).cubitEvaluationsError));
    }
  }

  void updateSorting(BuildContext context, bool sortByDate) {
   if (evaluacionesFiltered.isNotEmpty) {
      emit(EvaluacionesLoading());
      // Actualizar los criterios de ordenación
      if (sortByDate) {
        if (sortedByDate) {
          //si ya estabamos ordenando por fecha ordenar al reves
          sortDateDescendent = !sortDateDescendent;
        }
        sortedByDate = true;
      } else {
        if (sortedByDate == false) {
          //si ya estabamos ordenando por nombre ordenar al reves
          sortNameDescendent = !sortNameDescendent;
        }
        sortedByDate = false;
      }

      //ordenar
      evaluacionesFiltered.sort((a, b) {
        if (sortedByDate) {
          return sortDateDescendent
              ? a.fechaRealizacion.compareTo(b.fechaRealizacion)
              : b.fechaRealizacion.compareTo(a.fechaRealizacion);
        } else {
          return sortNameDescendent
              ? a.nombreMaquina.compareTo(b.nombreMaquina)
              : b.nombreMaquina.compareTo(a.nombreMaquina);
        }
      });

      // Emitir el nuevo estado con las evaluaciones ordenadas
      emit(EvaluacionesLoaded());
    }
  }

  void addFilter(BuildContext context, String key, dynamic value) {
    filtros[key] = value;
    getEvaluaciones(context);
  }

  void removeFilter(BuildContext context, String key) {
    filtros.remove(key);
    getEvaluaciones(context);
  }

  void clearFilters(BuildContext context) {
    filtros.clear();
    getEvaluaciones(context);
  }

  Map<String, dynamic> filtrosGuardados = {};

  /** Metodo que guarda una copia de los filtros aplicados actualmente **/
  void saveCurrentFilters() {
    // Guardar una copia de los filtros actuales
    filtrosGuardados = Map.from(filtros);

    debugPrint("Filtros guardados temporalmente.");
  }
  /** Metodo que resetea los filtros al estado en el que estaban cuando se guardo la copia **/
  void resetFilters(BuildContext context) {
    // Restaurar los filtros guardados
    filtros.clear();
    filtros.addAll(filtrosGuardados);

    // Llamar a getEvaluaciones para aplicar los filtros restaurados
    getEvaluaciones(context);

    debugPrint("Filtros restaurados exitosamente.");
  }

  Future<void> eliminarEvaluacion(BuildContext context, int idEvaluacion, int idMaquina) async {
    emit(EvaluacionesDeleteLoading());

    try {
      // Realizar las operaciones de eliminación
      await repositorio.eliminarEvaluacion(idEvaluacion);
      await repositorio.eliminarMaquina(idMaquina);
      await deleteFileFromIdEval(idEvaluacion);

      // Filtrar la evaluación eliminada de la lista
      evaluacionesFiltered = evaluacionesFiltered.where((evaluacion) => evaluacion.ideval != idEvaluacion).toList();

      // Emitir el estado con las evaluaciones actualizadas
      emit(EvaluacionesDeleteSuccess());
    } catch (e, stackTrace) {
      debugPrint('Error al eliminar la evaluación: $e');
      debugPrint(stackTrace.toString());
      emit(EvaluacionesDeleteError(S.of(context).cubitDeleteEvaluationError));
    }
  }
}
