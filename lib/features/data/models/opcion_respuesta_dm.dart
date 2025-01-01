import 'package:equatable/equatable.dart';

class OpcionRespuestaDataModel extends Equatable {
  final int idopcion;
  final String opcion;

  OpcionRespuestaDataModel({
    required this.idopcion,
    required this.opcion,
  });

  factory OpcionRespuestaDataModel.fromMap(Map<String, dynamic> json) {
    return OpcionRespuestaDataModel(
      idopcion: json['idopcion'] as int,
      opcion: json['opcion'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idopcion': idopcion,
      'opcion': opcion,
    };
  }

  @override
  List<Object?> get props => [idopcion, opcion];
}
