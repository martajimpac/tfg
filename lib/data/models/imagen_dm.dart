import 'dart:typed_data';

import 'package:equatable/equatable.dart';

import '../../core/utils/Utils.dart';


class ImagenDataModel extends Equatable {
  final int? idimg;
  final Uint8List imagen;

  const ImagenDataModel({
    this.idimg,
    required this.imagen,
  });


  factory ImagenDataModel.fromMap(Map<String, dynamic> json) {

    var imagenJson = json['imagen'];
    Uint8List? listaBytes = Utils.convertImage(imagenJson);


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
