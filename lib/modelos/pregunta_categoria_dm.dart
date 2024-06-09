import 'package:equatable/equatable.dart';

class PreguntaDataModel extends Equatable {
  final int idpregunta;
  final String pregunta;
  final int idCategoria;
  final int idRespuestaSeleccionada;

  PreguntaDataModel({
    required this.idpregunta,
    required this.pregunta,
    required this.idCategoria,
    required this.idRespuestaSeleccionada
  });

  factory PreguntaDataModel.fromMap(Map<String, dynamic> json) {
    return PreguntaDataModel(
      idpregunta: json['idpregunta'] as int,
      pregunta: json['pregunta'] as String,
      idCategoria: json['idcategoria'] as int,
      idRespuestaSeleccionada: json['id_respuesta_selec']
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idpregunta': idpregunta,
      'pregunta': pregunta,
      'idcategoria': idCategoria,
      'id_respuesta_selec': idRespuestaSeleccionada
    };
  }

  @override
  List<Object?> get props => [idpregunta, pregunta, idCategoria, idRespuestaSeleccionada];
}
