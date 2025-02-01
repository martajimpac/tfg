import 'package:equatable/equatable.dart';

class CategoriaPreguntaDataModel extends Equatable {
  final int idcat;
  final String categoria;
  bool isExpanded;
  bool tieneObservaciones;
  String? observaciones;

  CategoriaPreguntaDataModel({
    required this.idcat,
    required this.categoria,
    this.isExpanded = false,
    this.tieneObservaciones = false,
    this.observaciones,
  });

  factory CategoriaPreguntaDataModel.fromMap(Map<String, dynamic> json) {
    return CategoriaPreguntaDataModel(
      idcat: json['idcat'] as int,
      categoria: json['categoria'] as String,
      tieneObservaciones: json['tiene_observaciones'] as bool? ?? false,
      observaciones: json['observaciones'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idcat': idcat,
      'categoria': categoria,
      'tiene_observaciones': tieneObservaciones,
      'observaciones': observaciones
    };
  }

  @override
  List<Object?> get props => [idcat, categoria, isExpanded, tieneObservaciones, observaciones];
}
