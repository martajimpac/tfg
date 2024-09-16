import 'dart:convert';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:evaluacionmaquinas/utils/Utils.dart';

/***
 * DATOS BASICOS DE LA EVALUACIÓN, SIRVE PARA MOSTRAR LA LISTA DE LAS EVALUACIONES
 ***/
class EvaluacionDataModel extends Equatable {
  final int ideval;
  final DateTime fechaRealizacion;
  final DateTime fechaCaducidad;
  final int idMaquina;
  final String nombreMaquina;
  final int idCentro;
  final String centro;

  const EvaluacionDataModel({
    required this.ideval,
    required this.fechaRealizacion,
    required this.fechaCaducidad,
    required this.idMaquina,
    required this.nombreMaquina,
    required this.idCentro,
    required this.centro,
  });


  factory EvaluacionDataModel.fromMap(Map<String, dynamic> json) {

    return EvaluacionDataModel(
      ideval: json['ideval'] as int,
      fechaRealizacion: DateTime.parse(json['fecha_realizacion'] as String),
      fechaCaducidad: DateTime.parse(json['fecha_caducidad'] as String),
      idMaquina: json['idmaquina'] as int,
      nombreMaquina: json['nombre_maquina'] as String,
      idCentro: json['idcentro'] as int,
      centro: json['nombre_centro'] as String,
    );
  }





  Map<String, dynamic> toMap() {
    return {
      'ideval': ideval,
      'fecha_realizacion': fechaRealizacion.toIso8601String(),
      'fecha_caducidad': fechaCaducidad.toIso8601String(),
      'idmaquina': idMaquina,
      'nombre_maquina': nombreMaquina,
      'idcentro': idCentro,
      'nombre_centro': centro,
    };
  }

  @override
  List<Object?> get props => [
    ideval,
    fechaRealizacion,
    fechaCaducidad,
    idMaquina,
    nombreMaquina,
    idCentro,
    centro
  ];
}