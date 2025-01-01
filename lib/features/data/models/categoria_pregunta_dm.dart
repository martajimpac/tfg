import 'package:equatable/equatable.dart';

class CategoriaPreguntaDataModel extends Equatable {
  final int idcat;
  final String categoria;
  bool isExpanded;

  CategoriaPreguntaDataModel({
    required this.idcat,
    required this.categoria,
    this.isExpanded = false,
  });

  factory CategoriaPreguntaDataModel.fromMap(Map<String, dynamic> json) {
    return CategoriaPreguntaDataModel(
      idcat: json['idcat'] as int,
      categoria: json['categoria'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idcat': idcat,
      'categoria': categoria,
    };
  }

  @override
  List<Object?> get props => [idcat, categoria, isExpanded];
}
