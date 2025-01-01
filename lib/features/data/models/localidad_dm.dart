import 'dart:convert';

import 'package:equatable/equatable.dart';

class LocalidadDataModel extends Equatable {
  final int idpro;
  final int? idca;
  final String nombre;
  final int? dc;
  final int idloc;

  const LocalidadDataModel(
      {required this.idpro,
      this.idca,
      required this.nombre,
      this.dc,
      required this.idloc});

  factory LocalidadDataModel.fromMap(Map<String, dynamic> data) =>
      LocalidadDataModel(
        idpro: data['idpro'] as int,
        idca: data['idca'] as int?,
        nombre: data['nombre'] as String,
        dc: data['dc'] as int?,
        idloc: data['idloc'] as int,
      );

  Map<String, dynamic> toMap() => {
        'idpro': idpro,
        'idca': idca,
        'nombre': nombre,
        'dc': dc,
        'idloc': idloc,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [].
  factory LocalidadDataModel.fromJson(String data) {
    return LocalidadDataModel.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [] to a JSON string.
  String toJson() => json.encode(toMap());

  @override
  List<Object?> get props => [idpro, idca, nombre, dc, idloc];
}
