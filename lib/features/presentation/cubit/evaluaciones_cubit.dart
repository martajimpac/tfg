
import 'package:bloc/bloc.dart';
import 'package:diacritic/diacritic.dart';
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

class EvaluacionesDeleteSuccess extends EvaluacionesState {}

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
  List<EvaluacionDataModel> _evaluaciones = [];
  List<EvaluacionDataModel> _evaluacionesFiltered = [];
  bool sortedByDate = true;
  bool sortDateDescendent = true;
  bool sortNameDescendent = true;

  List<EvaluacionDataModel> get evaluaciones => _evaluaciones;
  List<EvaluacionDataModel> get evaluacionesFiltered => _evaluacionesFiltered;

  EvaluacionesCubit(this.repositorio) : super(EvaluacionesLoading());

  bool isAfterOrSameDay(DateTime a, DateTime b) {
    final aDate = DateTime(a.year, a.month, a.day);
    final bDate = DateTime(b.year, b.month, b.day);
    return aDate.isAfter(bDate);
  }

  bool isBeforeOrSameDay(DateTime a, DateTime b) {
    final aDate = DateTime(a.year, a.month, a.day);
    final bDate = DateTime(b.year, b.month, b.day);
    return aDate.isBefore(bDate);
  }

  Future<void> getEvaluaciones(BuildContext context) async {
    try {
      emit(EvaluacionesLoading());

      final id = await SharedPrefs.getUserId();
      _evaluaciones = await repositorio.getListaEvaluaciones(id);

      _evaluacionesFiltered = _evaluaciones;
      // Filtrar las evaluaciones con los filtros
      if (filtros[filtroCentro] != null) {
        if (filtros[filtroCentro] is CentroDataModel) {
          final centro = filtros[filtroCentro] as CentroDataModel;
          _evaluacionesFiltered = _evaluacionesFiltered
              .where((evaluacion) => evaluacion.idCentro == centro.idCentro)
              .toList();
        }
      }

      if (filtros[filtroFechaRealizacion] != null) {
        _evaluacionesFiltered = _evaluacionesFiltered.where((evaluacion) {
          final fechaEvaluacion = DateTime(
            evaluacion.fechaRealizacion.year,
            evaluacion.fechaRealizacion.month,
            evaluacion.fechaRealizacion.day,
          );
          final filtroFecha = DateTime(
            filtros[filtroFechaRealizacion].year,
            filtros[filtroFechaRealizacion].month,
            filtros[filtroFechaRealizacion].day,
          );

          final pasa = !fechaEvaluacion.isBefore(filtroFecha);
          return pasa;
        }).toList();
      }



      if (filtros[filtroFechaCaducidad] != null) {
        _evaluacionesFiltered = _evaluacionesFiltered.where((evaluacion) {
          final fechaEvaluacion = DateTime(
            evaluacion.fechaCaducidad.year,
            evaluacion.fechaCaducidad.month,
            evaluacion.fechaCaducidad.day,
          );
          final filtroFecha = DateTime(
            filtros[filtroFechaCaducidad].year,
            filtros[filtroFechaCaducidad].month,
            filtros[filtroFechaCaducidad].day,
          );
          final pasa = !fechaEvaluacion.isAfter(filtroFecha);
          return pasa;
        }).toList();
      }

      if (filtros[filtroDenominacion] != null) {
        _evaluacionesFiltered = _evaluacionesFiltered.where((evaluacion) {
          String normalizedFiltro =
              removeDiacritics(filtros[filtroDenominacion].toUpperCase())
                  .trim();
          String normalizadName =
              removeDiacritics(evaluacion.nombreMaquina.toUpperCase()).trim();
          // Normalizamos tanto el texto de búsqueda como el valor del filtro
          return normalizadName.contains(normalizedFiltro);
        }).toList();
      }

      // Ordenar por defecto al iniciar
      _evaluacionesFiltered.sort((a, b) {
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
    if (_evaluacionesFiltered.isNotEmpty) {
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
      _evaluacionesFiltered.sort((a, b) {
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

  /// Metodo que guarda una copia de los filtros aplicados actualmente *
  void saveCurrentFilters() {
    // Guardar una copia de los filtros actuales
    filtrosGuardados = Map.from(filtros);

    debugPrint("Filtros guardados temporalmente.");
  }

  /// Metodo que resetea los filtros al estado en el que estaban cuando se guardo la copia *
  void resetFilters(BuildContext context) {
    // Restaurar los filtros guardados
    filtros.clear();
    filtros.addAll(filtrosGuardados);

    // Llamar a getEvaluaciones para aplicar los filtros restaurados
    getEvaluaciones(context);

    debugPrint("Filtros restaurados exitosamente.");
  }

  Future<void> eliminarEvaluacion(
      BuildContext context, int idEvaluacion, int idMaquina) async {
    emit(EvaluacionesDeleteLoading());

    try {
      // Realizar las operaciones de eliminación
      await repositorio.eliminarEvaluacion(idEvaluacion);
      await repositorio.eliminarMaquina(idMaquina);
      await deleteFileFromIdEval(idEvaluacion);

      // Filtrar la evaluación eliminada de la lista
      _evaluacionesFiltered = _evaluacionesFiltered
          .where((evaluacion) => evaluacion.ideval != idEvaluacion)
          .toList();

      // Emitir el estado con las evaluaciones actualizadas
      emit(EvaluacionesDeleteSuccess());
    } catch (e, stackTrace) {
      debugPrint('Error al eliminar la evaluación: $e');
      debugPrint(stackTrace.toString());
      emit(EvaluacionesDeleteError(S.of(context).cubitDeleteEvaluationError));
    }
  }
}
