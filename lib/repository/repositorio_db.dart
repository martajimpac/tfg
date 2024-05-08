import 'dart:typed_data';

import 'package:evaluacionmaquinas/modelos/categoria_pregunta_dm.dart';
import 'package:evaluacionmaquinas/modelos/evaluacion_list_dm.dart';

import '../modelos/centro_dm.dart';
import '../modelos/imagen_dm.dart';
import '../modelos/opcion_pregunta_dm.dart';
import '../modelos/pregunta_categoria_dm.dart';

abstract class RepositorioDBInspecciones {
  Future<List<CentroDataModel>> getCentros();
  Future<List<ImagenDataModel>> getImagenes();

  Future<List<ListEvaluacionDataModel>> getListaEvaluaciones();
  Future<void> eliminarEvaluacion(int idEvaluacion);

  Future<List<PreguntaDataModel>> getPreguntasPorCategoria(int idCategoria);
  Future<List<PreguntaDataModel>> getPreguntas();
  Future<List<CategoriaPreguntaDataModel>> getCategorias();

  Future<List<OpcionPreguntaDataModel>> getOpcionesPregunta();

  Future<int> insertarMaquina(String nombreMaquina, String fabricante, String numeroSerie);
  Future<int> insertarEvaluacion(int idMaquina,
      int idInspector,
      int idCentro,
      int idTipoEval,
      DateTime fechaRealizacion,
      DateTime fechaCaducidad,
      DateTime? fechaFabricacion,
      DateTime? fechaPuestaServicio
      );
  Future<void> insertarImagenes(List<Uint8List> imagenes, int idEvaluacion);
}