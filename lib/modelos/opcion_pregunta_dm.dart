import 'package:equatable/equatable.dart';

class OpcionPreguntaDataModel extends Equatable {
  final int idpreg;
  final int idopcresp;

  OpcionPreguntaDataModel({
    required this.idpreg,
    required this.idopcresp,
  });

  factory OpcionPreguntaDataModel.fromMap(Map<String, dynamic> json) {
    return OpcionPreguntaDataModel(
      idpreg: json['idpreg'] as int,
      idopcresp: json['idopcresp'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idpreg': idpreg,
      'idopcresp': idopcresp,
    };
  }

  @override
  List<Object?> get props => [idpreg, idopcresp];
}
