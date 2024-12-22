import 'dart:convert';

import 'package:equatable/equatable.dart';

class CentroDataModel {
  final int idCentro;
  final String denominacion;
  final int idLocalidad;
  final int idProvincia;
  final String idPais;

  CentroDataModel({
    required this.idCentro,
    required this.denominacion,
    required this.idLocalidad,
    required this.idProvincia,
    required this.idPais
  });

  factory CentroDataModel.fromMap(Map<String, dynamic> data) {
    return CentroDataModel(
      idCentro: data['idcentro'] as int,
      denominacion: data['denominacion'] as String,
      idLocalidad: data['idlocalidad'] as int,
      idProvincia: data['idprovincia'] as int,
      idPais: data['idpais'] as String
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idcentro': idCentro,
      'denominacion': denominacion,
      'idlocalidad': idLocalidad,
      'idprovincia': idProvincia,
      'idpais': idPais
    };
  }

  factory CentroDataModel.fromJson(String data) {
    return CentroDataModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  String toJson() {
    return json.encode(toMap());
  }
}
