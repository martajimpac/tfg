import 'package:equatable/equatable.dart';

class OpcionPreguntaDataModel extends Equatable {
  final int idpreg;
  final int idopcresp;
  final String idrespuesta;

  OpcionPreguntaDataModel({
    required this.idpreg,
    required this.idopcresp,
    required this.idrespuesta
  });

  factory OpcionPreguntaDataModel.fromMap(Map<String, dynamic> json) {
    return OpcionPreguntaDataModel(
      idpreg: json['idpreg'] as int,
      idopcresp: json['idopcresp'] as int,
      idrespuesta: json['idrespuesta'] as String
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idpreg': idpreg,
      'idopcresp': idopcresp,
      'idrespuesta': idrespuesta
    };
  }

  @override
  List<Object?> get props => [idpreg, idopcresp, idrespuesta];
}
