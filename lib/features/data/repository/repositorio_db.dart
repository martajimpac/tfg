import 'dart:typed_data';

import '../models/categoria_pregunta_dm.dart';
import '../models/centro_dm.dart';
import '../models/evaluacion_details_dm.dart';
import '../models/evaluacion_list_dm.dart';
import '../models/imagen_dm.dart';
import '../models/opcion_respuesta_dm.dart';
import '../models/pregunta_dm.dart';



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
  Future<List<ImagenDataModel>> insertarImagenes(List<Uint8List> imagenes, int idEvaluacion); //TODO USAR CUADNO SE ACABE ESPACIO
  Future<List<ImagenDataModel>> insertarImagenesUrl(List<Uint8List> imagenes, int idEvaluacion);
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