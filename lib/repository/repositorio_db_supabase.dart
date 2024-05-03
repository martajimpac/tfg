
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:logger/logger.dart';
import 'package:evaluacionmaquinas/modelos/categoria_pregunta_dm.dart';
import 'package:evaluacionmaquinas/modelos/centro_dm.dart';
import 'package:evaluacionmaquinas/modelos/evaluacion_list_dm.dart';
import 'package:evaluacionmaquinas/repository/repositorio_db.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../modelos/evaluacion_details_dm.dart';
import '../modelos/evaluacion_to_insert_dm.dart';
import '../modelos/imagen_dm.dart';
import '../modelos/opcion_pregunta_dm.dart';
import '../modelos/pregunta_categoria_dm.dart';

class RepositorioDBSupabase extends RepositorioDBInspecciones {
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

  /***************** GET EVALUACIONES *************************/

  @override
  Future<List<ImagenDataModel>> getImagenes() async {
    try {
      var resConsulta = _supabase.client.rpc(
        'get_imagenes',
      );
      return resConsulta.then((value) => List<ImagenDataModel>.from(
          value.map((e) => ImagenDataModel.fromMap(e)).toList()));
    } catch (e) {
      log.e('Se ha producido un error al intentar obtener los datos de la base de datos: $e');
      rethrow;
    }
  }

  @override
  Future<List<ListEvaluacionDataModel>> getListaEvaluaciones() async { //TODO GET LISTA EVALUACIONES Y GETDETALLES EVALUACION!!
    try {
      var resConsulta = _supabase.client.rpc(
        'get_evaluaciones',
      );
      return resConsulta.then((value) => List<ListEvaluacionDataModel>.from(
          value.map((e) => ListEvaluacionDataModel.fromMap(e)).toList()));
    } catch (e) {
      log.e('Se ha producido un error al intentar obtener las evaluaciones de la base de datos: $e');
      rethrow;
    }
  }


  /************** GET PREGUNTAS *******************/
  @override
  Future<List<PreguntaDataModel>> getPreguntasPorCategoria(int idCategoria) async { //TODO QUITAR
    try {
      var resConsulta = _supabase.client.rpc(
        'get_preguntas',
        params: {'id_categoria': idCategoria}
      );
      return resConsulta.then((value) => List<PreguntaDataModel>.from(
          value.map((e) => PreguntaDataModel.fromMap(e)).toList()));
    } catch (e) {
      log.e('Se ha producido un error al intentar obtener las preguntas de la base de datos: $e');
      rethrow;
    }
  }
  @override
  Future<List<PreguntaDataModel>> getPreguntas() async {
    try {
      var resConsulta = await _supabase.client.rpc('get_preguntas');

      debugPrint("respuesta $resConsulta");

      return List<PreguntaDataModel>.from(resConsulta.map((e) => PreguntaDataModel.fromMap(e)).toList());
    } catch (e) {
      log.e('Se ha producido un error al intentar obtener las preguntas de la base de datos: $e');
      rethrow;
    }
  }

  @override
  Future<List<CategoriaPreguntaDataModel>> getCategorias() async { //todo quitar
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



  @override
  Future<List<OpcionPreguntaDataModel>> getOpcionesPregunta() async { //TODO, PARA CADA PREGUNTA?? METER IDPREGUNTA Y MODIFICAR
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
  }


  /************** INSERTAR ******************/
  @override
  Future<int> insertarEvaluacion(
      EvaluacionToInsertDataModel evaluacion
      ) async {
    try {
      debugPrint('Evaluacion: $evaluacion');

      var idEvaluacion = await _supabase.client.rpc('insert_evaluacion', params: {
        'idinspector': evaluacion.idinspector,
        'idcentro': evaluacion.idcentro,
        'fecha_realizacion': evaluacion.fechaRealizacion.toIso8601String(), //pasar a timestamp
        'fecha_caducidad': evaluacion.fechaCaducidad.toIso8601String(),
        'idmaquina': evaluacion.idmaquina,
        'idtipoeval': evaluacion.idtipoeval
      });

      return idEvaluacion as int;
    } catch (e) {
      debugPrint('Se ha producido un error al intentar almacenar el ítem en la base de datos: $e');
      rethrow;
    }
  }

  @override
  Future<void> insertarImagenes(List<Uint8List> imagenes, int idEvaluacion) async {
    try {
      for (var imagen in imagenes) {
        await _supabase.client.rpc('insert_imagen', params: {
          'ideval': idEvaluacion,
          'imagen': imagen
        });
      }
    } catch (e) {
      debugPrint('Se ha producido un error al intentar almacenar el ítem en la base de datos: $e');
      rethrow;
    }
  }

}

