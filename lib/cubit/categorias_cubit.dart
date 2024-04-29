import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:modernlogintute/modelos/categoria_pregunta_dm.dart';
import 'package:modernlogintute/repository/repositorio_db_supabase.dart';

// Define el estado del cubit
abstract class CategoriasState extends Equatable {
  const CategoriasState();

  @override
  List<Object> get props => [];
}

class CategoriasLoading extends CategoriasState {}

class CategoriasLoaded extends CategoriasState {
  final List<CategoriaPreguntaDataModel> categorias;

  const CategoriasLoaded(this.categorias);

  @override
  List<Object> get props => [categorias];
}

class CategoriasError extends CategoriasState {
  final String errorMessage;

  const CategoriasError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

// Define el cubit
class CategoriasCubit extends Cubit<CategoriasState> {
  final RepositorioDBSupabase repositorio;

  CategoriasCubit(this.repositorio) : super(CategoriasLoading());

  Future<void> getCategorias() async {
    try {
      final categorias = await repositorio.getCategorias();
      emit(CategoriasLoaded(categorias));
    } catch (e) {
      emit(CategoriasError('Error al obtener las categorías: $e'));
    }
  }
}