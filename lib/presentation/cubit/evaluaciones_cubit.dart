import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/generated/l10n.dart';
import '../../core/utils/Constants.dart';
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

  Future<void> getEvaluaciones(BuildContext context) async {
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
      emit(EvaluacionesError(S.of(context).cubitEvaluationsError));
    }
  }

  void addFilter(BuildContext context,String key, dynamic value) {
    emit(EvaluacionesLoading());
    filtros[key] = value;
    getEvaluaciones(context);
  }

  void removeFilter(BuildContext context,String key) {
    emit(EvaluacionesLoading());
    filtros.remove(key);
    getEvaluaciones(context);
  }

  void clearFilters(BuildContext context,) {
    emit(EvaluacionesLoading());
    filtros.clear();
    getEvaluaciones(context);
  }

}