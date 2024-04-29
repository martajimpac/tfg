import 'package:equatable/equatable.dart';

class PreguntaDataModel extends Equatable {
  final int idpregunta;
  final String pregunta;
  final int idCategoria;

  PreguntaDataModel({
    required this.idpregunta,
    required this.pregunta,
    required this.idCategoria
  });

  factory PreguntaDataModel.fromMap(Map<String, dynamic> json) {
    return PreguntaDataModel(
      idpregunta: json['idpregunta'] as int,
      pregunta: json['pregunta'] as String,
      idCategoria: json['idcategoria'] as int
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idpregunta': idpregunta,
      'pregunta': pregunta,
      'idcategoria': idCategoria
    };
  }

  @override
  List<Object?> get props => [idpregunta, pregunta, idCategoria];
}
