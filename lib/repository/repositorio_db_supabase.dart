
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:evaluacionmaquinas/modelos/evaluacion_details_dm.dart';
import 'package:evaluacionmaquinas/modelos/opcion_respuesta_dm.dart';
import 'package:evaluacionmaquinas/utils/Constants.dart';
import 'package:flutter/widgets.dart';
import 'package:logger/logger.dart';
import 'package:evaluacionmaquinas/modelos/categoria_pregunta_dm.dart';
import 'package:evaluacionmaquinas/modelos/centro_dm.dart';
import 'package:evaluacionmaquinas/modelos/evaluacion_list_dm.dart';
import 'package:evaluacionmaquinas/repository/repositorio_db.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../modelos/imagen_dm.dart';
import '../modelos/opcion_pregunta_dm.dart';
import '../modelos/pregunta_dm.dart';

class RepositorioDBSupabase extends RepositorioDB {
  final Supabase _supabase;

  Logger log = Logger();

  RepositorioDBSupabase(this._supabase);


  @override
  Future<List<CentroDataModel>> getCentros() async {
    try {
      var resConsulta = _supabase.client.rpc(
        'get_centros',
      );
      return resConsulta.then((value) => List<CentroDataModel>.from(
          value.map((e) => CentroDataModel.fromMap(e)).toList()));
    } catch (e) {
      log.e('Se ha producido un error al intentar obtener los datos de la base de datos: $e');
      rethrow;
    }
  }

 /*********************** ELIMINAR ****************************/

  @override
  Future<void> eliminarEvaluacion(int idEvaluacion) async {
    try {
      var resConsulta = _supabase.client.rpc(
        'eliminar_evaluacion',
        params: {'id_evaluacion': idEvaluacion},
      );
      await resConsulta;
    } catch (e) {
      log.e('Se ha producido un error al intentar eliminar la evaluación: $e');
      rethrow;
    }
  }

  @override
  Future<void> eliminarMaquina(int idMaquina) async {
    try {
      var resConsulta = _supabase.client.rpc(
        'eliminar_maquina',
        params: {'id_maquina': idMaquina},
      );
      await resConsulta;
    } catch (e) {
      log.e('Se ha producido un error al intentar eliminar la máquina: $e');
      rethrow;
    }
  }

  @override
  Future<void> eliminarImagenes(List<int> ids) async {
    try {
      for (var id in ids) {
        await _supabase.client.rpc('eliminar_imagen', params: {
          'id_img': id
        });
      }

    } catch (e) {
      debugPrint('Se ha producido un error al intentar eliminar las imagenes: $e');
      rethrow;
    }
  }
  /***************** GET EVALUACIONES *************************/

  @override
  Future<List<EvaluacionDataModel>> getListaEvaluaciones(String idInspector) async {
    try {
      var resConsulta = _supabase.client.rpc(
        'get_evaluaciones_sin_imagen',
        params: {'idinspector': idInspector},
      );
      return resConsulta.then((value) => List<EvaluacionDataModel>.from(
          value.map((e) => EvaluacionDataModel.fromMap(e)).toList()));
    } catch (e) {
      log.e('Se ha producido un error al intentar obtener las evaluaciones de la base de datos: $e');
      rethrow;
    }
  }

  @override
  Future<EvaluacionDetailsDataModel> getDetallesEvaluacion(int idEvaluacion) async {
    try {
      var resConsulta = await _supabase.client.rpc(
        'get_detalles_evaluacion',
        params: {'ideval': idEvaluacion}, // Corregido el nombre del parámetro
      );
      return EvaluacionDetailsDataModel.fromMap(resConsulta[0]); // Suponiendo que solo se espera un resultado
    } catch (e) {
      log.e('Se ha producido un error al obtener los datos de la evaluación: $e');
      rethrow;
    }
  }

  @override
  Future<List<ImagenDataModel>> getImagenesEvaluacion(int idEvaluacion) async {
    try {
      var resConsulta = _supabase.client.rpc(
        'get_imagenes_evaluacion',
        params: {'ideval': idEvaluacion},
      );
      return resConsulta.then((value) => List<ImagenDataModel>.from(
          value.map((e) => ImagenDataModel.fromMap(e)).toList()));
    } catch (e) {
      log.e('Se ha producido un error al obtener las imagenes de la evaluación: $e');
      rethrow;
    }
  }

  @override
  Future<List<int>> getIdsImagenesEvaluacion(int idEvaluacion) async {
    try {
      var resConsulta = await _supabase.client.rpc(
        'get_ids_imagenes_evaluacion',
        params: {'ideval': idEvaluacion},
      );


      List<dynamic> data = resConsulta as List<dynamic>;

      return data.map((e) => e['idimg'] as int).toList();
    } catch (e) {
      log.e('Se ha producido un error al obtener los ids de las imagenes de la evaluación: $e');
      rethrow;
    }
  }

  /************** GET PREGUNTAS *******************/

  @override
  Future<List<PreguntaDataModel>> getPreguntas() async { //TODO NO SE USA ELIMINAR
    try {
      dynamic resConsulta;

      resConsulta = await _supabase.client.rpc('get_preguntas');


      if (resConsulta == null) {
        return [];
      }

      return List<PreguntaDataModel>.from(resConsulta.map((e) => PreguntaDataModel.fromMap(e)).toList());
    } catch (e) {
      log.e('Se ha producido un error al intentar obtener las preguntas de la base de datos: $e');
      rethrow;
    }
  }

  @override
  Future<List<PreguntaDataModel>> getPreguntasRespuesta(int idEvaluacion) async {
    try {
      dynamic resConsulta;

      resConsulta = await _supabase.client.rpc('get_preguntas_respuestas', params: {'ideval': idEvaluacion});

      if (resConsulta == null) {
        return [];
      }

      return List<PreguntaDataModel>.from(resConsulta.map((e) => PreguntaDataModel.fromMap(e)).toList());
    } catch (e) {
      log.e('Se ha producido un error al intentar obtener las preguntas de la base de datos: $e');
      rethrow;
    }
  }




  @override
  Future<List<OpcionRespuestaDataModel>> getRespuestas() async {
    try {
      var resConsulta = _supabase.client.rpc(
          'get_respuestas'
      );

      return resConsulta.then((value) => List<OpcionRespuestaDataModel>.from(
          value.map((e) => OpcionRespuestaDataModel.fromMap(e)).toList()));
    } catch (e) {
      log.e('Se ha producido un error al intentar obtener las respuestas de la base de datos: $e');
      rethrow;
    }
  }


  @override
  Future<List<CategoriaPreguntaDataModel>> getCategorias() async {
    try {
      var resConsulta = _supabase.client.rpc(
          'get_categorias'
      );

      return resConsulta.then((value) => List<CategoriaPreguntaDataModel>.from(
          value.map((e) => CategoriaPreguntaDataModel.fromMap(e)).toList()));
    } catch (e) {
      log.e('Se ha producido un error al intentar obtener las categorias de la base de datos: $e');
      rethrow;
    }
  }



/*  @override
  Future<List<OpcionPreguntaDataModel>> getRespuestasPregunta() async { //TODO, PARA CADA PREGUNTA?? METER IDPREGUNTA Y MODIFICAR
    try {
      var resConsulta = _supabase.client.rpc(
        'get_opciones_pregunta',
      );
      return resConsulta.then((value) => List<OpcionPreguntaDataModel>.from(
          value.map((e) => OpcionPreguntaDataModel.fromMap(e)).toList()));
    } catch (e) {
      log.e('Se ha producido un error al intentar obtener las opciones de las preguntas de la base de datos: $e');
      rethrow;
    }
  }*/


  /************** INSERTAR ******************/

  @override
  Future<int> insertarMaquina(String nombreMaquina, String? fabricante, String numeroSerie) async {
    try {

      var idMaq = await _supabase.client.rpc('insert_maquina', params: {
        'maquina': nombreMaquina,
        'fabricante': fabricante,
        'numero_serie': numeroSerie,
      });

      return idMaq as int;
    } catch (e) {
      debugPrint('Se ha producido un error al intentar almacenar el ítem en la base de datos: $e');
      rethrow;
    }
  }

  @override
  Future<int> insertarEvaluacion(
      int idMaquina,
      String idInspector,
      int idCentro,
      int idTipoEval,
      DateTime fechaRealizacion,
      DateTime fechaCaducidad,
      DateTime? fechaFabricacion,
      DateTime? fechaPuestaServicio
      ) async {
    try {

      var idEvaluacion = await _supabase.client.rpc('insert_evaluacion', params: {
        'idinspector': idInspector,
        'idcentro': idCentro,
        'fecha_realizacion': fechaRealizacion.toIso8601String(), //pasar a timestamp
        'fecha_caducidad': fechaCaducidad.toIso8601String(),
        'idmaquina': idMaquina,
        'idtipoeval': idTipoEval,
        'fecha_fabricacion': fechaFabricacion?.toIso8601String(),
        'fecha_puesta_servicio': fechaPuestaServicio?.toIso8601String(),
      });

      return idEvaluacion as int;
    } catch (e) {
      debugPrint('Se ha producido un error al intentar almacenar el ítem en la base de datos: $e');
      rethrow;
    }
  }

  @override
  Future<List<ImagenDataModel>> insertarImagenes(List<Uint8List> imagenes, int idEvaluacion) async {
    try {
      List<ImagenDataModel> listaImagenesIds  = [];
      for (var imagen in imagenes) {


        //Obtener el ide del usuario
        final userId = _supabase.client.auth.currentUser!.id;

        //Obtener el filePath del usario
        final filePath = '/$userId/profile';
        //subir la imagen a subase storage
        await _supabase.client.storage
            .from(bucketName)
            .uploadBinary(filePath, imagen);

        // Obtener URL pública
        final publicUrlResponse = _supabase.client.storage
            .from(bucketName)
            .getPublicUrl(filePath);

        //TODO AHORA PODEMOS GUARDAR LA URL PUBLICA... EN VEZ DE LA IMAGEN

        var idImagen = await _supabase.client.rpc('insert_imagen', params: {
          'ideval': idEvaluacion,
          'imagen': imagen
        });
        listaImagenesIds.add(ImagenDataModel(idimg: idImagen, imagen: imagen));
      }
      return listaImagenesIds;
    } catch (e) {
      debugPrint('Se ha producido un error al intentar almacenar el ítem en la base de datos: $e');
      rethrow;
    }
  }

  @override
  Future<void> insertarRespuestas(List<PreguntaDataModel> preguntas, int idEvaluacion) async {
    try {
      for (var pregunta in preguntas) {
        if(pregunta.idRespuestaSeleccionada != null){
          await _supabase.client.rpc('insert_respuesta', params: {
            'ideval': idEvaluacion,
            'idpregunta': pregunta.idpregunta,
            'id_respuesta_selec': pregunta.idRespuestaSeleccionada,
            'respondida': pregunta.isAnswered,
            'observaciones': pregunta.observaciones
          });
        }

      }
    } catch (e) {
      debugPrint('Se ha producido un error al intentar almacenar el ítem en la base de datos: $e');
      rethrow;
    }
  }


  /**************  MODIFICAR ******************/

  @override
  Future<void> modificarMaquina(int idMaquina, String nombreMaquina, String? fabricante, String numeroSerie) async {
    try {

      await _supabase.client.rpc('update_maquina', params: {
        'idmaq': idMaquina,
        'maquina': nombreMaquina,
        'fabricante': fabricante,
        'numero_serie': numeroSerie,
      });
    } catch (e) {
      debugPrint('Se ha producido un error al intentar modificar la maquina: $e');
      rethrow;
    }
  }

  @override
  Future<void> modificarEvaluacion(
      int idEvaluacion,
      int idCentro,
      int idTipoEval,
      DateTime fechaModificacion,
      DateTime fechaCaducidad,
      DateTime? fechaFabricacion,
      DateTime? fechaPuestaServicio
      ) async {
    try {

      await _supabase.client.rpc('update_evaluacion', params: {
        'ideval': idEvaluacion,
        'idcentro': idCentro,
        'fecha_modificacion': fechaModificacion.toIso8601String(),
        'fecha_caducidad': fechaCaducidad.toIso8601String(),
        'idtipoeval': idTipoEval,
        'fecha_fabricacion': fechaFabricacion?.toIso8601String(),
        'fecha_puesta_servicio': fechaPuestaServicio?.toIso8601String(),
      });

    } catch (e) {
      debugPrint('Se ha producido un error al intentar modificar la evaluación: $e');
      rethrow;
    }
  }
}


