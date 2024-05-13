import 'package:equatable/equatable.dart';

import 'imagen_dm.dart';

class EvaluacionDetailsDataModel extends Equatable {
  final int ideval;
  final int idinspector;
  final int idcentro; //TODO NO OBLIGATORIO??? COMO TE LO DEVVUELVE?? VER COMO ESTA GUARDADO
  final String nombreCentro;
  final DateTime fechaRealizacion;
  final DateTime fechaCaducidad;
  final DateTime? fechaModificacion;
  final int idmaquina;
  final String nombreMaquina;
  final int idtipoeval;
  final DateTime? fechaFabricacion;
  final DateTime? fechaPuestaServicio;
  final String? fabricante;
  final String numeroSerie;

  const EvaluacionDetailsDataModel({
    required this.ideval,
    required this.idinspector,
    required this.nombreCentro,
    required this.idcentro,
    required this.fechaRealizacion,
    required this.fechaCaducidad,
    this.fechaModificacion,
    required this.idmaquina,
    required this.nombreMaquina,
    required this.idtipoeval,
    this.fechaFabricacion,
    this.fechaPuestaServicio,
    this.fabricante,
    required this.numeroSerie
  });


  /*  otra forma de interntar convertir las imagenes
  factory ListEvaluacionDataModel.fromMap(Map<String, dynamic> json) {
    // Suponiendo que 'json['imagen']' contiene una cadena de bytes en formato base64
    Uint8List imagenBytes = base64.decode(json['imagen'] as String);

    return ListEvaluacionDataModel(
      ideval: json['ideval'] as int,
      fechaRealizacion: DateTime.parse(json['fecha_realizacion'] as String),
      fechaCaducidad: DateTime.parse(json['fecha_caducidad'] as String),
      nombreMaquina: json['nombre_maquina'] as String,
      imagen: imagenBytes, // Ahora asignamos los bytes decodificados
      centro: json['nombre_centro'] as String,
    );
  }*/


  factory EvaluacionDetailsDataModel.fromMap(Map<String, dynamic> json) {
    return EvaluacionDetailsDataModel(
      ideval: json['ideval'] as int,
      idinspector: json['idinspector'] as int,
      idcentro: json['idcentro'] as int,
      nombreCentro: json['nombre_centro'] as String,
      fechaRealizacion: DateTime.parse(json['fecha_realizacion'] as String),
      fechaCaducidad: DateTime.parse(json['fecha_caducidad'] as String),
      fechaModificacion: json['fecha_modificacion'] != null
          ? DateTime.parse(json['fecha_modificacion'] as String)
          : null,
      idmaquina: json['idmaquina'] as int,
      nombreMaquina: json['nombre_maquina'] as String,
      idtipoeval: json['idtipoeval'] as int,
      fechaFabricacion:  json['fecha_fabricacion'] != null
          ? DateTime.parse(json['fecha_fabricacion'] as String)
          : null,
      fechaPuestaServicio:   json['fecha_puesta_servicio'] != null
          ? DateTime.parse(json['fecha_puesta_servicio'] as String)
          : null,
      fabricante: json['fabricante'] as String,
      numeroSerie: json['numero_serie'] as String
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ideval': ideval,
      'idinspector': idinspector,
      'idcentro': idcentro,
      'nombre_centro': nombreCentro,
      'fecha_realizacion': fechaRealizacion.toIso8601String(),
      'fecha_caducidad': fechaCaducidad.toIso8601String(),
      'fecha_modificacion': fechaModificacion?.toIso8601String(),
      'idmaquina': idmaquina,
      'nombreMaquina': nombreMaquina,
      'idtipoeval': idtipoeval,
      'fecha_fabricacion': fechaFabricacion,
      'fecha_puesta_servicio': fechaPuestaServicio,
      'fabricante': fabricante,
      'numero_serie': numeroSerie
    };
  }

  @override
  List<Object?> get props => [
    ideval,
    idinspector,
    idcentro,
    nombreCentro,
    fechaRealizacion,
    fechaCaducidad,
    fechaModificacion,
    idmaquina,
    nombreMaquina,
    idtipoeval,
    fechaFabricacion,
    fechaPuestaServicio,
    fabricante,
    numeroSerie
  ];
}
