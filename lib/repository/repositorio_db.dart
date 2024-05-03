import 'dart:typed_data';

import 'package:evaluacionmaquinas/modelos/categoria_pregunta_dm.dart';
import 'package:evaluacionmaquinas/modelos/evaluacion_list_dm.dart';

import '../modelos/centro_dm.dart';
import '../modelos/evaluacion_details_dm.dart';
import '../modelos/evaluacion_to_insert_dm.dart';
import '../modelos/imagen_dm.dart';
import '../modelos/opcion_pregunta_dm.dart';
import '../modelos/pregunta_categoria_dm.dart';

abstract class RepositorioDBInspecciones {
  Future<List<CentroDataModel>> getCentros();
  Future<List<ImagenDataModel>> getImagenes();

  Future<List<ListEvaluacionDataModel>> getListaEvaluaciones();

  Future<List<PreguntaDataModel>> getPreguntasPorCategoria(int idCategoria);
  Future<List<PreguntaDataModel>> getPreguntas();
  Future<List<CategoriaPreguntaDataModel>> getCategorias();

  Future<List<OpcionPreguntaDataModel>> getOpcionesPregunta();

  Future<int> insertarEvaluacion(EvaluacionToInsertDataModel evaluacion);
  Future<void> insertarImagenes(List<Uint8List> imagenes, int idEvaluacion);
}