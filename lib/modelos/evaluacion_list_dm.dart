import 'dart:convert';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';

class ListEvaluacionDataModel extends Equatable {
  final int ideval;
  final DateTime fechaRealizacion;
  final DateTime fechaCaducidad;
  final String nombreMaquina;
  final Uint8List? imagen; // Cambio en el tipo de dato para manejar los bytes
  final String centro; //TODO: añadir fecha fabricacion y puesta en servicio y tipo evaluacion??

  const ListEvaluacionDataModel({
    required this.ideval,
    required this.fechaRealizacion,
    required this.fechaCaducidad,
    required this.nombreMaquina,
    this.imagen,
    required this.centro,
  });


  factory ListEvaluacionDataModel.fromMap(Map<String, dynamic> json) {
    Uint8List? listaBytes; // Lista de bytes para la imagen

    if (json['imagen'] != null) {
      final cadenaRecortada = json['imagen'].substring(4, json['imagen'].length - 2); //quitar "[" y "]" caracteres ascii

      List<String> listaString = cadenaRecortada.split('2c'); //quitar caracteres "," ascii

      List<int> listaDecimal = [];

      for (var it in listaString) {
        String numeroSinImpares = '';
        for (int i = 0; i < it.length; i++) {
          // Si la posición es par, agregar el dígito a la cadena resultante
          if (i % 2 != 0) {
            numeroSinImpares += it[i];
          }
        }
        listaDecimal.add(int.parse(numeroSinImpares));
      }
      listaBytes = Uint8List.fromList(listaDecimal);
    }

    return ListEvaluacionDataModel(
      ideval: json['ideval'] as int,
      fechaRealizacion: DateTime.parse(json['fecha_realizacion'] as String),
      fechaCaducidad: DateTime.parse(json['fecha_caducidad'] as String),
      nombreMaquina: json['nombre_maquina'] as String,
      imagen: listaBytes, // Ahora asignamos los bytes decodificados
      centro: json['nombre_centro'] as String,
    );
  }


/*  factory ListEvaluacionDataModel.fromMap(Map<String, dynamic> json) {
    // Suponiendo que 'json['imagen']' contiene una cadena de bytes en formato base64
    Uint8List imagenBytes = base64.decode(json['imagen'] as String);

    return ListEvaluacionDataModel(
      ideval: json['ideval'] as int,
      fechaRealizacion: DateTime.parse(json['fecha_realizacion'] as String),
      fechaCaducidad: DateTime.parse(json['fecha_caducidad'] as String),
      nombreMaquina: json['nombre_maquina'] as String,
      imagen: imagenBytes, // Ahora asignamos los bytes decodificados
      centro: json['nombre_centro'] as String,
    );
  }*/


  Map<String, dynamic> toMap() {
    return {
      'ideval': ideval,
      'fecha_realizacion': fechaRealizacion.toIso8601String(),
      'fecha_caducidad': fechaCaducidad.toIso8601String(),
      'nombre_maquina': nombreMaquina,
      'imagen': imagen, // No se necesita conversión ya que es Uint8List
      'nombre_centro': centro,
    };
  }

  @override
  List<Object?> get props => [
    ideval,
    fechaRealizacion,
    fechaCaducidad,
    nombreMaquina,
    imagen,
    centro
  ];
}