import 'package:equatable/equatable.dart';

import 'imagen_dm.dart';

class EvaluacionDataModel extends Equatable {
  final int ideval;
  final int idinspector;
  final int idcentro; //TODO CENTRO, NOMBRE MAQUINA, ....
  final DateTime fechaRealizacion;
  final DateTime fechaCaducidad;
  final DateTime? fechaModificacion;
  final int idmaquina;
  final int idtipoeval;
  final List<ImagenDataModel> imagenes; // Lista de imágenes

  EvaluacionDataModel({
    required this.ideval,
    required this.idinspector,
    required this.idcentro,
    required this.fechaRealizacion,
    required this.fechaCaducidad,
    this.fechaModificacion,
    required this.idmaquina,
    required this.idtipoeval,
    required this.imagenes,
  });

  // Constructor adicional sin el parámetro 'ideval' y sin la fecha de caducidad
  const EvaluacionDataModel.fromRealizacion(this.imagenes, {
    required this.idinspector,
    required this.idcentro,
    required this.fechaRealizacion,
    required this.fechaCaducidad,
    required this.idmaquina,
    required this.idtipoeval,
  })  : ideval = 0, fechaModificacion = null;

  factory EvaluacionDataModel.fromMap(Map<String, dynamic> json) {
    return EvaluacionDataModel(
      ideval: json['ideval'] as int,
      idinspector: json['idinspector'] as int,
      idcentro: json['idcentro'] as int,
      fechaRealizacion: DateTime.parse(json['fecha_realizacion'] as String),
      fechaCaducidad: DateTime.parse(json['fecha_caducidad'] as String),
      fechaModificacion: json['fecha_modificacion'] != null
          ? DateTime.parse(json['fecha_modificacion'] as String)
          : null,
      idmaquina: json['idmaquina'] as int,
      idtipoeval: json['idtipoeval'] as int,
      imagenes: (json['imagenes'] as List<dynamic>).map((e) => ImagenDataModel.fromMap(e as Map<String, dynamic>)).toList(), // Mapeo de la lista de imágenes
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ideval': ideval,
      'idinspector': idinspector,
      'idcentro': idcentro,
      'fecha_realizacion': fechaRealizacion.toIso8601String(),
      'fecha_caducidad': fechaCaducidad.toIso8601String(),
      'fecha_modificacion': fechaModificacion?.toIso8601String(),
      'idmaquina': idmaquina,
      'idtipoeval': idtipoeval,
      'imagenes': imagenes.map((e) => e.toMap()).toList(), // Mapeo de la lista de imágenes
    };
  }

  @override
  List<Object?> get props => [
    ideval,
    idinspector,
    idcentro,
    fechaRealizacion,
    fechaCaducidad,
    fechaModificacion,
    idmaquina,
    idtipoeval,
    imagenes,
  ];
}
