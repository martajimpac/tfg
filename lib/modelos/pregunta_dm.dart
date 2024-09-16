import 'package:equatable/equatable.dart';

class PreguntaDataModel extends Equatable {
  final int idpregunta;
  final String pregunta;
  final int? idCategoria;
  int? idRespuestaSeleccionada;
  bool isAnswered;
  bool tieneObservaciones;
  late final String? observaciones;

  PreguntaDataModel({
    required this.idpregunta,
    required this.pregunta,
    required this.idCategoria,
    this.idRespuestaSeleccionada,
    this.isAnswered = false,
    this.tieneObservaciones = false,
    this.observaciones,
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
      'observaciones': observaciones
    };
  }

  @override
  List<Object?> get props => [idpregunta, pregunta, idCategoria, idRespuestaSeleccionada, isAnswered, tieneObservaciones, observaciones];
}
