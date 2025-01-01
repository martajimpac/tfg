import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../../generated/l10n.dart';
import '../../data/models/centro_dm.dart';
import '../../data/repository/repositorio_db_supabase.dart';

// Define el estado del cubit
abstract class CentrosState extends Equatable {
  const CentrosState();

  @override
  List<Object> get props => [];
}

class CentrosLoading extends CentrosState {}

class CentrosLoaded extends CentrosState {
  final List<CentroDataModel> centros;

  const CentrosLoaded(this.centros);

  @override
  List<Object> get props => [centros];
}

class CentrosError extends CentrosState {
  final String errorMessage;

  const CentrosError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

// Define el cubit
class CentrosCubit extends Cubit<CentrosState> {
  final RepositorioDBSupabase repositorio;

  CentrosCubit(this.repositorio) : super(CentrosLoading());

  Future<void> getCentros(BuildContext context) async {
    try {
      final centros = await repositorio.getCentros();
      emit(CentrosLoaded(centros));
    } catch (e) {
      emit(CentrosError(S.of(context).cubitCentersError));
    }
  }
}
