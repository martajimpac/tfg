import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modernlogintute/main.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:equatable/equatable.dart';


abstract class CategoriesState extends Equatable {
  final int pageIndex;
  final List<Map<String, dynamic>> preguntas;

  const CategoriesState({
    required this.pageIndex,
    required this.preguntas,
  });

  @override
  List<Object?> get props => [pageIndex, preguntas]; // Cambiado a List<Object?>
}

class CategoriesInitial extends CategoriesState {
  const CategoriesInitial() : super(pageIndex: 1, preguntas: const []);
}

class CategoriesLoaded extends CategoriesState {
  const CategoriesLoaded(List<Map<String, dynamic>> dropdownValues, int pageIndex)
      : super(pageIndex: pageIndex, preguntas: dropdownValues);
}


class CategoriesCubit extends Cubit<CategoriesState> {
  CategoriesCubit() : super(const CategoriesInitial());

  Future<void> loadData() async {
    emit(const CategoriesInitial());
    try {
      final preguntas = await supabase.from("maq_categoria_regunta")
          .stream(primaryKey: ["idcat"]);

    /*  final preguntas = await supabase.from("maq_categoria_regunta")
          .select("*, maq_pregunta(*)")
          .eq('id_categoria', state.pageIndex);// Filtrar por una fila concreta*/

      emit(CategoriesLoaded(preguntas as List<Map<String, dynamic>>, state.pageIndex));

    } catch (e) {
      // Maneja el error
    }
  }

  Future<void> selectedPage(int pageIndex) async {
    final preguntas = await supabase.from("maq_categoria_regunta")
        .stream(primaryKey: ["idcat"]); //"*, maq_pregunta(*)"
        //.eq('id_categoria', pageIndex);// Filtrar por una fila concreta

    emit(CategoriesLoaded(preguntas as List<Map<String, dynamic>>, pageIndex));
  }
}

/*
Future<List<dynamic>> getDataFromTable(String tableName) async {

  final response = await supabase.from(tableName).select();
  return response;

}*/
