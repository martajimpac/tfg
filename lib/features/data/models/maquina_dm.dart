import 'package:equatable/equatable.dart';

class MaquinaDataModel extends Equatable {
  final int idmaq;
  final String maquina;
  final String? fabricante;
  final String? numeroSerie;

  MaquinaDataModel({
    required this.idmaq,
    required this.maquina,
    this.fabricante,
    required this.numeroSerie
  });

  factory MaquinaDataModel.fromMap(Map<String, dynamic> json) {
    return MaquinaDataModel(
      idmaq: json['idmaq'] as int,
      maquina: json['maquina'] as String,
      fabricante: json['fabricante'] as String?,
      numeroSerie: json['numero_serie'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idmaq': idmaq,
      'maquina': maquina,
      'fabricante': fabricante,
      'numero_serie': numeroSerie,
    };
  }

  @override
  List<Object?> get props => [idmaq, maquina, fabricante, numeroSerie];
}
