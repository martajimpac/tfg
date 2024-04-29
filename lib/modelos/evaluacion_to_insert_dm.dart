import 'package:equatable/equatable.dart';

class EvaluacionToInsertDataModel extends Equatable {
  final int ideval;
  final int idinspector;
  final int idcentro;
  final DateTime fechaRealizacion;
  final DateTime fechaCaducidad;
  final DateTime? fechaModificacion;
  final int idmaquina;
  final int idtipoeval;

  EvaluacionToInsertDataModel({
    required this.ideval,
    required this.idinspector,
    required this.idcentro,
    required this.fechaRealizacion,
    required this.fechaCaducidad,
    this.fechaModificacion,
    required this.idmaquina,
    required this.idtipoeval,
  });

  // Constructor adicional sin el parámetro 'ideval' y sin la fecha de caducidad
  const EvaluacionToInsertDataModel.fromRealizacion({
    required this.idinspector,
    required this.idcentro,
    required this.fechaRealizacion,
    required this.fechaCaducidad,
    required this.idmaquina,
    required this.idtipoeval,
  })  : ideval = 0, fechaModificacion = null;



  Map<String, dynamic> toMap() {
    return {
      'ideval': ideval,
      'idinspector': idinspector,
      'idcentro': idcentro,
      'fecha_realizacion': fechaRealizacion.toIso8601String(),
      'fecha_caducidad': fechaCaducidad?.toIso8601String(),
      'fecha_modificacion': fechaModificacion?.toIso8601String(),
      'idmaquina': idmaquina,
      'idtipoeval': idtipoeval,
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
  ];
}