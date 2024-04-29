import 'package:equatable/equatable.dart';

class ImagenDataModel extends Equatable {
  final int idimg;
  final int ideval;
  final List<int> imagen;

  ImagenDataModel({
    required this.idimg,
    required this.ideval,
    required this.imagen,
  });

  factory ImagenDataModel.fromMap(Map<String, dynamic> json) {
    return ImagenDataModel(
      idimg: json['idimg'] as int,
      ideval: json['ideval'] as int,
      imagen: List<int>.from(json['imagen'] as List),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idimg': idimg,
      'ideval': ideval,
      'imagen': imagen,
    };
  }

  @override
  List<Object?> get props => [idimg, ideval, imagen];
}
