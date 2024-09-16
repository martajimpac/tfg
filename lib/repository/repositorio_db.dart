import 'dart:typed_data';

import 'package:evaluacionmaquinas/modelos/categoria_pregunta_dm.dart';
import 'package:evaluacionmaquinas/modelos/evaluacion_details_dm.dart';
import 'package:evaluacionmaquinas/modelos/evaluacion_list_dm.dart';
import 'package:evaluacionmaquinas/modelos/opcion_respuesta_dm.dart';

import '../modelos/centro_dm.dart';
import '../modelos/imagen_dm.dart';
import '../modelos/opcion_pregunta_dm.dart';
import '../modelos/pregunta_dm.dart';

abstract class RepositorioDB {

  Future<List<CentroDataModel>> getCentros();

  /***************** ELIMINAR **********************/

  Future<void> eliminarEvaluacion(int idEvaluacion);
  Future<void> eliminarMaquina(int idMaquina);
  Future<void> eliminarImagenes(List<int> ids);

  /***************** GET EVALUACIONES *************************/

  Future<List<EvaluacionDataModel>> getListaEvaluaciones(String idInspector);

  Future<EvaluacionDetailsDataModel> getDetallesEvaluacion(int idEvaluacion);
  Future<List<ImagenDataModel>> getImagenesEvaluacion(int idEvaluacion);
  Future<List<int>> getIdsImagenesEvaluacion(int idEvaluacion);

  /************** GET PREGUNTAS *******************/
  Future<List<PreguntaDataModel>> getPreguntas();
  Future<List<PreguntaDataModel>> getPreguntasRespuesta(int idEvaluacion);
  Future<List<OpcionRespuestaDataModel>> getRespuestas();
  Future<List<CategoriaPreguntaDataModel>> getCategorias();

  //Future<List<OpcionPreguntaDataModel>> getRespuestasPregunta(); /** obtener las respuestas para cada pregunta **/



  /************** INSERTAR ******************/
  Future<int> insertarMaquina(String nombreMaquina, String fabricante, String numeroSerie);
  Future<int> insertarEvaluacion(int idMaquina,
      String idInspector,
      int idCentro,
      int idTipoEval,
      DateTime fechaRealizacion,
      DateTime fechaCaducidad,
      DateTime? fechaFabricacion,
      DateTime? fechaPuestaServicio
      );
  Future<List<ImagenDataModel>> insertarImagenes(List<Uint8List> imagenes, int idEvaluacion);
  Future<void> insertarRespuestas(List<PreguntaDataModel> preguntas, int idEvaluacion);

  /**************  MODIFICAR ******************/

  Future<void> modificarMaquina(int idMaquina, String nombreMaquina, String? fabricante, String numeroSerie);
  Future<void> modificarEvaluacion(
      int idEvaluacion,
      int idCentro,
      int idTipoEval,
      DateTime fechaRealizacion,
      DateTime fechaCaducidad,
      DateTime? fechaFabricacion,
      DateTime? fechaPuestaServicio
      );

}