import 'package:equatable/equatable.dart';

class PreguntaDataModel extends Equatable {
  final int idpregunta;
  final String pregunta;
  final int? idCategoria;
  int? idRespuestaSeleccionada;
  bool isAnswered;
  bool tieneObservaciones;
  String? observaciones;
  int? idDefaultAnswer;

  PreguntaDataModel({
    required this.idpregunta,
    required this.pregunta,
    required this.idCategoria,
    this.idRespuestaSeleccionada,
    this.isAnswered = false,
    this.tieneObservaciones = false,
    this.observaciones,
    this.idDefaultAnswer,
  });

  factory PreguntaDataModel.fromMap(Map<String, dynamic> json) {
    return PreguntaDataModel(
      idpregunta: json['idpregunta'] as int,
      pregunta: json['pregunta'] as String,
      idCategoria: json['idcategoria'] as int?,
      idRespuestaSeleccionada: json['id_respuesta_selec'] as int?,
      isAnswered: json['respondida'] as bool? ?? false,
      tieneObservaciones: json['tiene_observaciones'] as bool? ?? false,
      observaciones: json['observaciones'] as String?,
      idDefaultAnswer: json['id_respuesta_por_defecto'] as int?
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idpregunta': idpregunta,
      'pregunta': pregunta,
      'idcategoria': idCategoria,
      'id_respuesta_selec': idRespuestaSeleccionada,
      'respondida': isAnswered,
      'tiene_observaciones': tieneObservaciones,
      'observaciones': observaciones,
      'id_respuesta_por_defecto': idDefaultAnswer
    };
  }

  @override
  List<Object?> get props => [idpregunta, pregunta, idCategoria, idRespuestaSeleccionada, isAnswered, tieneObservaciones, observaciones, idDefaultAnswer];
}
