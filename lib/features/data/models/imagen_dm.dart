import 'dart:typed_data';

import 'package:equatable/equatable.dart';

import '../../../core/utils/Utils.dart';


class ImagenDataModel extends Equatable {
  final int? idimg;
  final Uint8List? imagen;
  final String? image_url;

  const ImagenDataModel({
    this.idimg,
    this.imagen,
    this.image_url,
  });


  factory ImagenDataModel.fromMap(Map<String, dynamic> json) {

    var imagenJson = json['imagen'];
    Uint8List? listaBytes = Utils.convertImage(imagenJson);


    return ImagenDataModel(
      idimg: json['idimg'] as int,
      imagen: listaBytes!,
      image_url: json['image_url'] as String,
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'idimg': idimg,
      'imagen': imagen,
      'image_url': image_url
    };
  }

  @override
  List<Object?> get props => [idimg, imagen, image_url];
}
