import 'package:equatable/equatable.dart';

class MaquinaDataModel extends Equatable {
  final int idmaq;
  final String maquina;
  final String? fabricante;

  MaquinaDataModel({
    required this.idmaq,
    required this.maquina,
    this.fabricante,
  });

  factory MaquinaDataModel.fromMap(Map<String, dynamic> json) {
    return MaquinaDataModel(
      idmaq: json['idmaq'] as int,
      maquina: json['maquina'] as String,
      fabricante: json['fabricante'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idmaq': idmaq,
      'maquina': maquina,
      'fabricante': fabricante,
    };
  }

  @override
  List<Object?> get props => [idmaq, maquina, fabricante];
}
