import 'package:equatable/equatable.dart';

class TipoEvaluacionDataModel extends Equatable {
  final int idtipo;
  final String tipo;

  const TipoEvaluacionDataModel({
    required this.idtipo,
    required this.tipo,
  });

  factory TipoEvaluacionDataModel.fromMap(Map<String, dynamic> json) {
    return TipoEvaluacionDataModel(
      idtipo: json['idtipo'] as int,
      tipo: json['tipo'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idtipo': idtipo,
      'tipo': tipo,
    };
  }

  @override
  List<Object?> get props => [idtipo, tipo];
}