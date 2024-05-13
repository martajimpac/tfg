import 'dart:typed_data';

import 'package:equatable/equatable.dart';

import '../helpers/ConstantsHelper.dart';

class ImagenDataModel extends Equatable {
  final int idimg;
  final Uint8List imagen;

  ImagenDataModel({
    required this.idimg,
    required this.imagen,
  });


  factory ImagenDataModel.fromMap(Map<String, dynamic> json) {

    var imagenJson = json['imagen'];
    Uint8List? listaBytes = ConstantsHelper.convertImage(imagenJson);


    return ImagenDataModel(
      idimg: json['idimg'] as int,
      imagen: listaBytes!,
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'idimg': idimg,
      'imagen': imagen,
    };
  }

  @override
  List<Object?> get props => [idimg, imagen];
}
