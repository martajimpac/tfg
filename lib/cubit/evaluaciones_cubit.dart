import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:evaluacionmaquinas/helpers/ConstantsHelper.dart';
import 'package:flutter/foundation.dart';
import 'package:evaluacionmaquinas/modelos/evaluacion_details_dm.dart';
import 'package:evaluacionmaquinas/modelos/evaluacion_list_dm.dart';
import 'package:evaluacionmaquinas/repository/repositorio_db_supabase.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Define el estado del cubit
abstract class EvaluacionesState extends Equatable {
  const EvaluacionesState();

  @override
  List<Object> get props => [];
}

class EvaluacionesLoading extends EvaluacionesState {}

class EvaluacionesLoaded extends EvaluacionesState {
  final List<EvaluacionDataModel> evaluaciones;

  const EvaluacionesLoaded(this.evaluaciones);

  @override
  List<Object> get props => [evaluaciones];
}

class EvaluacionesError extends EvaluacionesState {
  final String errorMessage;

  const EvaluacionesError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

// Define el cubit
class EvaluacionesCubit extends Cubit<EvaluacionesState> {
  final RepositorioDBSupabase repositorio;
  final Map<String, dynamic> filtros;

  EvaluacionesCubit(this.repositorio, this.filtros) : super(EvaluacionesLoading());

  Future<void> getEvaluaciones() async {
    try {
      emit(EvaluacionesLoading());

      SharedPreferences prefs = await SharedPreferences.getInstance();
      final id = prefs.getString('id') ?? ''; // Obtener el nombre del usuario guardado, o un valor predeterminado si no existe
      var evaluaciones = await repositorio.getListaEvaluaciones(id);

      // Filtrar las evaluaciones con los filtros
      if (filtros[filtroCentro] != null) {
        evaluaciones = evaluaciones.where((evaluacion) => evaluacion.centro == filtros[filtroCentro]).toList(); //TODO FILTRO CENTRO NO DEBERÍA SER POR ID, SI DEBERÍA??
      }

      if (filtros[filtroFechaRealizacion] != null) {
        evaluaciones = evaluaciones.where((evaluacion) => evaluacion.fechaRealizacion.isAfter(filtros[filtroFechaRealizacion])).toList();
      }

      if (filtros[filtroFechaCaducidad] != null) {
        evaluaciones = evaluaciones.where((evaluacion) => evaluacion.fechaCaducidad.isBefore(filtros[filtroFechaCaducidad])).toList();
      }

      emit(EvaluacionesLoaded(evaluaciones));
    } catch (e) {
      emit(EvaluacionesError('Error al obtener las evaluaciones: $e'));
    }
  }

  void addFilter(String key, dynamic value) {
    emit(EvaluacionesLoading());
    filtros[key] = value;
    getEvaluaciones();
  }

  void removeFilter(String key) {
    emit(EvaluacionesLoading());
    filtros.remove(key);
    getEvaluaciones();
  }

  void clearFilters() {
    emit(EvaluacionesLoading());
    filtros.clear();
    getEvaluaciones();
  }

}