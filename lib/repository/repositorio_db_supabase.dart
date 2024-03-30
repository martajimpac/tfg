/*
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:logger/logger.dart';
import 'package:prl_chcklst_23/bloc/maq/bloc/maquina_bloc.dart';
import 'package:prl_chcklst_23/modelos/accion_dm.dart';
import 'package:prl_chcklst_23/modelos/ca_dm.dart';
import 'package:prl_chcklst_23/modelos/checklist_data_model.dart';
import 'package:prl_chcklst_23/modelos/chequeoinicial_dm.dart';
import 'package:prl_chcklst_23/modelos/datos_pdf_checklist_data_model.dart';
import 'package:prl_chcklst_23/modelos/datos_resumen_acciones_dm.dart';
import 'package:prl_chcklst_23/modelos/datos_word_data_model.dart';
import 'package:prl_chcklst_23/modelos/datosexcel_dm.dart';
import 'package:prl_chcklst_23/modelos/datospdf_dm.dart';
import 'package:prl_chcklst_23/modelos/eval/categoria_factor_riesgo_dm.dart';
import 'package:prl_chcklst_23/modelos/eval/evaluacion_riesgo_dm.dart';
import 'package:prl_chcklst_23/modelos/eval/factor_riesgo_dm.dart';
import 'package:prl_chcklst_23/modelos/eval/tipo_factor_riesgo_dm.dart';
import 'package:prl_chcklst_23/modelos/exigencia_dm.dart';
import 'package:prl_chcklst_23/modelos/inspeccion_dm.dart';
import 'package:prl_chcklst_23/modelos/inspector_dm.dart';
import 'package:prl_chcklst_23/modelos/item_data_model.dart';
import 'package:prl_chcklst_23/modelos/lista_comprobacion_data_model.dart';
import 'package:prl_chcklst_23/modelos/localidad_dm.dart';
import 'package:prl_chcklst_23/modelos/maq/categoria_pregunta_maq_dm.dart';
import 'package:prl_chcklst_23/modelos/maq/centro_maq_dm.dart';
import 'package:prl_chcklst_23/modelos/maq/datos_evaluacion_dm.dart';
import 'package:prl_chcklst_23/modelos/maq/datos_resumen_eval_maq_dm.dart';
import 'package:prl_chcklst_23/modelos/maq/datospdf_maq_dm.dart';
import 'package:prl_chcklst_23/modelos/maq/evaluacion_maq_data_model.dart';
import 'package:prl_chcklst_23/modelos/maq/maquina_maq_dm.dart';
import 'package:prl_chcklst_23/modelos/maq/observacion_respuesta_data_model.dart';
import 'package:prl_chcklst_23/modelos/maq/opcion_pregunta_maq_dm.dart';
import 'package:prl_chcklst_23/modelos/maq/opcion_respuesta_maq_dm.dart';
import 'package:prl_chcklst_23/modelos/maq/pregunta_maq_dm.dart';
import 'package:prl_chcklst_23/modelos/maq/respuesta_pregunta_maq_data_model.dart';
import 'package:prl_chcklst_23/modelos/maq/tipo_evaluacion_maq_dm.dart';
import 'package:prl_chcklst_23/modelos/observacion_respuesta_data_model.dart';
import 'package:prl_chcklst_23/modelos/opcion_dm.dart';
import 'package:prl_chcklst_23/modelos/opciones_item_modelo_data_model.dart';
import 'package:prl_chcklst_23/modelos/pais_dm.dart';
import 'package:prl_chcklst_23/modelos/provincia_dm.dart';
import 'package:prl_chcklst_23/modelos/pvd/aspecto_dm.dart';
import 'package:prl_chcklst_23/modelos/pvd/condicion_dm.dart';
import 'package:prl_chcklst_23/modelos/pvd/datos_pdf_pvd_dm.dart';
import 'package:prl_chcklst_23/modelos/pvd/factor_dm.dart';
import 'package:prl_chcklst_23/modelos/pvd/nivel_riesgo_dm.dart';
import 'package:prl_chcklst_23/modelos/pvd/opcion_condicion_dm.dart';
import 'package:prl_chcklst_23/modelos/pvd/opcion_pvd_dm.dart';
import 'package:prl_chcklst_23/modelos/pvd/pvd_dm.dart';
import 'package:prl_chcklst_23/modelos/pvd/respuesta_dm.dart';
import 'package:prl_chcklst_23/modelos/pvd/subaspecto_dm.dart';
import 'package:prl_chcklst_23/modelos/pvd/texto_accion_data_model.dart';
import 'package:prl_chcklst_23/modelos/pvd/tipo_accion_data_model.dart';
import 'package:prl_chcklst_23/modelos/pvd/tipo_condicion_dm.dart';
import 'package:prl_chcklst_23/modelos/pvd/valoracion_dm.dart';
import 'package:prl_chcklst_23/modelos/responsable_accion_data_model.dart';
import 'package:prl_chcklst_23/modelos/responsable_dm.dart';
import 'package:prl_chcklst_23/modelos/respuesta_item_data_model.dart';
import 'package:prl_chcklst_23/modelos/situacion_dm.dart';
import 'package:prl_chcklst_23/repositorios/repositorio_db.dart';
import 'package:prl_chcklst_23/utils/secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RepositorioDBSupabase extends RepositorioDBInspecciones {
  final Supabase _supabase;

  Logger log = Logger();

  RepositorioDBSupabase(this._supabase);

  ///Se elimina un checklist (de cualquier modelo exceptodel modelo inicial)
  ///junto con sus respuestas y las observaciones a éstas
  @override
  Future<void> borrarChecklist(
      {required int idInspeccion, required int idListado}) async {
    Logger log = Logger();
    try {
      String? respuesta = await _supabase.client.rpc('f_elimina_checklist',
          params: {'p_idinsp': idInspeccion, 'p_idlista': idListado});

      log.d(respuesta);
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar eliminar un listado de comprobación y datos asociados: $e');
      rethrow;
    }
  }

  ///Se eliminan los datos almacenados en el chequeo incial de una inspección
  @override
  Future<void> borrarDatosChequeoInicial({required int idInspeccion}) async {
    Logger log = Logger();
    try {
      String? respuesta = await _supabase.client
          .rpc('f_elimina_chequeoinicial', params: {'p_idinsp': idInspeccion});

      log.d(respuesta);
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar eliminar chequeo inicial y datos asociados: $e');
      rethrow;
    }
  }

  ///Borrado de inspecciones
  ///Se llama al procedimiento almacenado que borra la inspección
  ///y todos los datos asociados a ella
  ///Se recibe como parámetro el id de la inspección a borrar y el id del usuario
  ///que la realiza
  @override
  Future<void> borrarInspeccion(
      {required int idInspeccion, required String usuarioAPP}) async {
    ///Se llama al procedimiento almacenado que borra la inspección
    ///y todos los datos asociados a ella
    /////TODO: registrar el usuario que borra la inspección
    Logger log = Logger();
    log.d('Borrado de la inspección');
    try {
      String? respuesta = await _supabase.client
          .rpc('f_elimina_inspeccion', params: {'p_idinsp': idInspeccion});

      log.d(respuesta);
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar eliminar los datos de la inspección: $e');
      rethrow;
    }
  }

  ///Borrado de items de checklist y datos asociados
  @override
  Future<void> borrarItemChecklist(
      {required int idItem, required String usuarioAPP}) async {
    ///Se llama al procedimiento almacenado que borra la inspección
    ///y todos los datos asociados a ella
    /////TODO: registrar el usuario que borra el ítem
    Logger log = Logger();
    log.d('Borrado del item');
    try {
      String? respuesta = await _supabase.client
          .rpc('f_elimina_item', params: {'p_iditem': idItem});

      log.d(respuesta);
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar eliminar el ítem y datos asociados: $e');
      rethrow;
    }
  }

  @override
  Future<void> borrarModeloChecklist(
      {required int idModelo, required String usuarioAPP}) async {
    ///Se llama al procedimiento almacenado que borra el modelo de checklist
    /////TODO: registrar el usuario que borra la el modelo
    Logger log = Logger();
    log.d('Borrado del modelo de checklist');
    try {
      String? respuesta = await _supabase.client
          .rpc('f_elimina_modelo', params: {'p_idmodelo': idModelo});

      log.d(respuesta);
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar eliminar los datos de la inspección: $e');
      rethrow;
    }
  }

  ///Borrado de opciones de respuesta de checklist y datos asociados
  @override
  Future<void> borrarOpcionRespuestaChecklist(
      {required int idOpcionRespuesta, required String usuarioAPP}) async {
    ///TODO: registrar el usuario que borra la opción de respuesta
    ///Se llama al procedimiento almacenado que borra la inspección
    ///y todos los datos asociados a ella
    Logger log = Logger();
    log.d('Borrado de la opción de respuesta');
    try {
      String? respuesta = await _supabase.client
          .rpc('f_elimina_opcion', params: {'p_idopcion': idOpcionRespuesta});

      log.d(respuesta);
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar eliminar la opción y datos asociados: $e');
      rethrow;
    }
  }

  @override
  Future<void> borrarPVD(
      {required int idPVD,
      required int idInspeccion,
      required String usuarioAPP}) async {
    ///Se llama al procedimiento almacenado que borra la PVD
    ///y todos los datos asociados a ella
    /////TODO: registrar el usuario que borra la inspección
    Logger log = Logger();
    log.d('Borrado de PVD');
    try {
      String? respuesta = await _supabase.client.rpc('f_elimina_pvd',
          params: {'p_idpvd': idPVD, 'p_idinsp': idInspeccion});

      log.d(respuesta);
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar eliminar los datos de la inspección: $e');
      rethrow;
    }
  }

  @override
  Future<bool> compruebaSiHayChecklistModelo({required int idModelo}) async {
    try {
      var resConsulta = await _supabase.client
          .rpc('hay_checklist_modelo', params: {'p_idmodelo': idModelo});
      var resultado = resConsulta.first['haydatos'];
      return resultado;
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar obtener los datos de la base de datos: $e');
      rethrow;
    }
  }

  ///Comprueba si hay datos de una acción en el chequeo inicial de una inspección
  @override
  Future<bool> compruebaSiHayDatosAccionEnChequeoInicial(
      int idInspeccion, int idAccion) async {
    try {
      var resConsulta = await _supabase.client.rpc('hay_datos_chequeoinicial',
          params: {'p_idinsp': idInspeccion, 'p_idaccion': idAccion});
      var resultado = resConsulta.first['haydatos'];
      return resultado;
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar obtener los datos de la base de datos: $e');
      rethrow;
    }
  }

  @override
  Future<bool> compruebaSiHayDatosChequeoInicialInspeccion(
      int idInspeccion) async {
    try {
      var resConsulta = await _supabase.client
          .rpc('hay_datos_chequeoinicial', params: {'p_idinsp': idInspeccion});
      var resultado = resConsulta.first['haydatos'];
      return resultado;
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar obtener los datos de la base de datos: $e');
      rethrow;
    }
  }

  ///Compribación de si hay ítems asociados a un modelo de checklist
  @override
  Future<bool> compruebaSiHayItemsModelo({required int idModelo}) {
    try {
      var resConsulta = _supabase.client
          .rpc('hay_item_modelo', params: {'p_idmodelo': idModelo});
      return resConsulta.then((value) => value.first['haydatos'] as bool);
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar obtener los datos de la base de datos: $e');

      rethrow;
    }
  }

  ///Comprueba si hay respuestas a un ítem
  @override
  Future<bool> compruebaSiHayRespuestasAItem({required int idItem}) async {
    try {
      var resConsulta = await _supabase.client
          .rpc('hay_respuestas_item', params: {'p_iditem': idItem});
      var resultado = resConsulta.first['haydatos'];
      return resultado;
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar obtener los datos de la base de datos: $e');
      rethrow;
    }
  }

  @override
  Future<List<AccionDataModel>> getAcciones() async {
    try {
      var resConsulta = _supabase.client.rpc(
        'listado_acciones',
      );
      return resConsulta.then((value) => List<AccionDataModel>.from(
          value.map((e) => AccionDataModel.fromMap(e)).toList()));
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar obtener los datos de la base de datos: $e');
      rethrow;
    }
  }

  ///Obtiene la lista de acciones corespondientes a una exigencia
  @override
  Future<List<AccionDataModel>> getAccionesPorExigencia(int idExigencia) async {
    try {
      var resConsulta = _supabase.client
          .rpc('listado_acciones_exigencia', params: {'p_idexi': idExigencia});
      return resConsulta.then((value) => List<AccionDataModel>.from(
          value.map((e) => AccionDataModel.fromMap(e)).toList()));
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar obtener los datos de la base de datos: $e');
      rethrow;
    }
  }

  ///Nos devuelve el listado de aspectos de una revisón de pantallas de visualización
  ///de datos
  @override
  Future<List<AspectoDataModel>> getAspectosPVD() async {
    try {
      var resConsulta = _supabase.client.rpc(
        'listado_pvd_aspectos',
      );
      return resConsulta.then((value) => List<AspectoDataModel>.from(
          value.map((e) => AspectoDataModel.fromMap(e)).toList()));
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar obtener los datos de la base de datos: $e');
      rethrow;
    }
  }

  //Obtenemos todos los checllists de un inspector
  @override
  Future<List<ChecklistDataModel>> getChecklistsInspector(int idInspector) {
    try {
      var resConsulta = _supabase.client
          .rpc('listado_checklist_inspector', params: {'p_idins': idInspector});
      return resConsulta.then((value) => List<ChecklistDataModel>.from(
          value.map((e) => ChecklistDataModel.fromMap(e)).toList()));
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar obtener los datos de la base de datos: $e');
      rethrow;
    }
  }

  //Obtenemos los cecklists creados por un isnpector enuns inspección concreta

  @override
  Future<List<ChecklistDataModel>> getChecklistsInspectorInspeccion(
      {required int idInspector, required int idInspeccion}) {
    try {
      var resConsulta = _supabase.client.rpc(
          'listado_checklist_inspector_inspeccion',
          params: {'p_idinsp': idInspector, 'p_idinspccn': idInspeccion});
      return resConsulta.then((value) => List<ChecklistDataModel>.from(
          value.map((e) => ChecklistDataModel.fromMap(e)).toList()));
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar obtener los datos de la base de datos: $e');
      rethrow;
    }
  }

  ///Devuelve la lista de comunidades autónomas que tenemos en la base de datos
  @override
  Future<List<ComunidadAutonomaDataModel>> getComunidadesAutonomas() async {
    try {
      var resConsulta = _supabase.client.rpc(
        'listado_ccaa',
      );
      return resConsulta.then((value) => List<ComunidadAutonomaDataModel>.from(
          value.map((e) => ComunidadAutonomaDataModel.fromMap(e)).toList()));
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar obtener los datos de la base de datos: $e');
      rethrow;
    }
  }

  @override
  Future<List<CondicionDataModel>> getCondicionesAspectoPVD(int idAspecto) {
    try {
      var resConsulta = _supabase.client.rpc(
        'listado_pvd_condiciones_aspecto',
        params: {'p_idasp': idAspecto},
      );
      return resConsulta.then((value) => List<CondicionDataModel>.from(
          value.map((e) => CondicionDataModel.fromMap(e)).toList()));
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar obtener los datos de la base de datos: $e');
      rethrow;
    }
  }

  @override
  Future<List<CondicionDataModel>> getCondicionesPVD() {
    try {
      var resConsulta = _supabase.client.rpc(
        'listado_pvd_condiciones',
      );
      return resConsulta.then((value) => List<CondicionDataModel>.from(
          value.map((e) => CondicionDataModel.fromMap(e)).toList()));
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar obtener los datos de la base de datos: $e');
      rethrow;
    }
  }

  @override
  Future<List<CondicionDataModel>> getCondicionesSubaspectoPVD(
      int idAspecto, int idSubaspecto) {
    try {
      var resConsulta = _supabase.client.rpc(
        'listado_pvd_condiciones_subaspecto',
        params: {'p_idasp': idAspecto, 'p_idsubasp': idSubaspecto},
      );
      return resConsulta.then((value) => List<CondicionDataModel>.from(
          value.map((e) => CondicionDataModel.fromMap(e)).toList()));
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar obtener los datos de la base de datos: $e');
      rethrow;
    }
  }

  ///Obtiene los datos de del chequeinciial de una acción de una inspección

  @override
  Future<ChequeoInicialDataModel?>? getDatosAccionEnChequeoInicial(
      int idInspeccion, int idAccion) async {
    try {
      var resConsulta = _supabase.client.rpc('datos_accion_chequeo_inicial',
          params: {'p_idinspeccion': idInspeccion, 'p_idaccion': idAccion});
      return resConsulta
          .then((value) => ChequeoInicialDataModel.fromMap(value.first));
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar obtener los datos de la base de datos: $e');
      rethrow;
    }
  }

  @override
  Future<List<ChequeoInicialDataModel>>
      getDatosAccionesExigenciaEnChequeoInicial(
          int idInspeccion, int idExigencia) {
    try {
      var resConsulta = _supabase.client
          .rpc('datos_acciones_exigencia_inspeccion', params: {
        'p_idinspeccion': idInspeccion,
        'p_idexigencia': idExigencia
      });
      return resConsulta.then((value) => List<ChequeoInicialDataModel>.from(
          value.map((e) => ChequeoInicialDataModel.fromMap(e)).toList()));
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar obtener los datos de la base de datos: $e');
      rethrow;
    }
  }

  @override
  Future<List<DatosExcelChecklistDataModel>> getDatosExcelChecklistPorId(
      int idLista) {
    log.d('Obtención de datos de la inspeción para el excel');

    ///Obtenemos los datos de la inspección para el excel
    try {
      var resConsulta = _supabase.client
          .rpc('datos_excel_checklist', params: {'p_idlista': idLista});

      return resConsulta.then((value) =>
          List<DatosExcelChecklistDataModel>.from(value
              .map((e) => DatosExcelChecklistDataModel.fromMap(e))
              .toList()));
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar obtener los datos de la base de datos: $e');
      rethrow;
    }
  }

  @override
  Future<List<DatosExcelChequeoInicialDataModel>>
      getDatosExcelChequeoPorInspeccion(int idInspeccion) async {
    log.d('Obtención de datos de la inspeción para el excel');

    ///Obtenemos los datos de la inspección para el excel
    try {
      var resConsulta = _supabase.client.rpc('datos_excel_chequeo_inicial',
          params: {'p_idins': idInspeccion});

      return resConsulta.then((value) =>
          List<DatosExcelChequeoInicialDataModel>.from(value
              .map((e) => DatosExcelChequeoInicialDataModel.fromMap(e))
              .toList()));
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar obtener los datos de la base de datos: $e');
      rethrow;
    }
  }

  @override
  Future<List<DatosPdfChecklistDataModel>> getDatosPdfChecklist(
      int idChecklist) async {
    log.d('Obtención de datos de la inspeción para el pdf');

    ///Obtenemos los datos de la inspección para el pdf
    try {
      var resConsulta = _supabase.client
          .rpc('datos_pdf_checklist', params: {'p_idchklst': idChecklist});

      return resConsulta.then((value) => List<DatosPdfChecklistDataModel>.from(
          value.map((e) => DatosPdfChecklistDataModel.fromMap(e)).toList()));
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar obtener los datos de la base de datos: $e');
      rethrow;
    }
  }

  @override
  Future<List<DatosPdfDataModel>> getDatosPdfModeloMinisdef(
      int idInspeccion) async {
    log.d('Obtención de datos de la inspeción para el pdf');

    ///Obtenemos los datos de la inspección para el pdf
    try {
      var resConsulta = _supabase.client
          .rpc('datos_pdf_inspeccion', params: {'p_idins': idInspeccion});

      return resConsulta.then((value) => List<DatosPdfDataModel>.from(
          value.map((e) => DatosPdfDataModel.fromMap(e)).toList()));
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar obtener los datos de la base de datos: $e');
      rethrow;
    }
  }

  @override
  Future<List<DatosPdfPvdDataModel>> getDatosPdfPvd(int idPvd) {
    ///Obtenemos los datos de la inspección para el pdf
    try {
      var resConsulta =
          _supabase.client.rpc('datos_pdf_pvd', params: {'p_idpvd': idPvd});

      return resConsulta.then((value) => List<DatosPdfPvdDataModel>.from(
          value.map((e) => DatosPdfPvdDataModel.fromMap(e)).toList()));
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar obtener los datos de la base de datos: $e');
      rethrow;
    }
  }

  @override
  Future<List<DatosWordDataModel>> getDatosWord(int idInspeccion) async {
    log.d('Obtención de datos de la inspeción para el word');

    ///Obtenemos los datos de la inspección para el pdf
    try {
      var resConsulta = _supabase.client
          .rpc('datos_word_inspeccion', params: {'p_idins': idInspeccion});

      return resConsulta.then((value) => List<DatosWordDataModel>.from(
          value.map((e) => DatosWordDataModel.fromMap(e)).toList()));
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar obtener los datos de la base de datos: $e');
      rethrow;
    }
  }

  ///Obtengo los datos de una exigencia a partir de su id
  @override
  Future<ExigenciaDataModel> getExigenciaPorId(int idExigencia) async {
    try {
      var resConsulta = _supabase.client
          .rpc('exigencia_por_id', params: {'p_idexi': idExigencia});
      return resConsulta
          .then((value) => ExigenciaDataModel.fromMap(value.first));
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar obtener los datos de la base de datos: $e');
      rethrow;
    }
  }

  //Obtiene la lista de exigencias de la BBDD
  @override
  Future<List<ExigenciaDataModel>> getExigencias() async {
    try {
      var resConsulta = _supabase.client.rpc(
        'listado_exigencias',
      );
      return resConsulta.then((value) => List<ExigenciaDataModel>.from(
          value.map((e) => ExigenciaDataModel.fromMap(e)).toList()));
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar obtener los datos de la base de datos: $e');
      rethrow;
    }
  }

  @override
  Future<List<FactorDataModel>> getFactoresPVD() {
    try {
      var resConsulta = _supabase.client.rpc(
        'listado_pvd_factores',
      );
      return resConsulta.then((value) => List<FactorDataModel>.from(
          value.map((e) => FactorDataModel.fromMap(e)).toList()));
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar obtener los datos de la base de datos: $e');
      rethrow;
    }
  }

  ///Obteien el listado de acciones de una inspección que tienen datos en el chequeo inicial
  @override
  Future<List<int>> getIdsAccionesConDatos(int idInspeccion) async {
    log.d('Obtención de ids de las acciones con datos en el chequeo inicial');

    ///Obtenemos la lista de acciones para las que hay datos almacenados en el chequeo inicial
    try {
      var resConsulta = await _supabase.client
          .rpc('lista_acciones_con_datos', params: {'p_idins': idInspeccion});

      List<int> listaAcciones =
          List<int>.from(resConsulta.map((e) => e['idaccion'] as int).toList());
      return listaAcciones;
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar obtener los datos de la base de datos: $e');
      rethrow;
    }
  }

  ///Devuelve el id del inspector a partir de su nombre de usuario
  @override
  Future<int?> getIdUsuarioPorNombre(String nombreUsuario) async {
    try {
      var resConsulta = await _supabase.client
          .rpc('idusuario_por_nombre', params: {'p_nombre': nombreUsuario});

      if (resConsulta.length == 0) {
        return null;
      } else {
        return resConsulta.first['id'] as int;
      }
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar obtener los datos de la base de datos: $e');
      rethrow;
    }
  }

  //Obtiene la información del inspector
  @override
  Future<InspectorDataModel> getInformacionInspector(int userId) {
    // TODO: implement getInformacionInspector
    throw UnimplementedError();
  }

  ///Obtiene la lista de inspecciones de la BBDD para el inspector indicado
  @override
  Future<List<InspeccionDataModel>> getInspeccionesPorInspector(
      int idInspector) async {
    try {
      var resConsulta = _supabase.client.rpc('listado_inspecciones_inspector',
          params: {'p_idins': idInspector});
      return resConsulta.then((value) => List<InspeccionDataModel>.from(
          value.map((e) => InspeccionDataModel.fromMap(e)).toList()));
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar obtener los datos de la base de datos: $e');
      rethrow;
    }
  }

  //Obtenemos los datos de una inspección a partir de su id
  @override
  Future<InspeccionDataModel> getInspeccionPorId(int idInspeccion) async {
    try {
      var resConsulta = await _supabase.client.rpc('datos_inspeccion_por_id',
          params: {'p_idinspeccion': idInspeccion});

      resConsulta.length != 1
          ? throw Exception(
              'No se ha encontrado ninguna inspección con el id $idInspeccion')
          : log.d(
              'Se ha encontrado una inspección con el id $idInspeccion: $resConsulta');

      InspeccionDataModel inspeccion =
          InspeccionDataModel.fromMap(resConsulta[0]);

      return inspeccion;
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar obtener los datos de la base de datos: $e');
      rethrow;
    }
  }

  @override
  Future<List<ItemDataModel>> getItems() async {
    try {
      var resConsulta = _supabase.client.rpc(
        'listado_items',
      );
      return resConsulta.then((value) => List<ItemDataModel>.from(
          value.map((e) => ItemDataModel.fromMap(e)).toList()));
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar obtener los datos de la base de datos: $e');
      rethrow;
    }
  }

  ///Devuelve el listado de items que un inspectr determinaod puede ver/editar
  ///TODO: por ahora cualquier inspector puede ver todos los items, pero en un futuro se deberá limitar
  @override
  Future<List<ItemDataModel>> getItemsInspector(int idInspector) async {
    try {
      var resConsulta = _supabase.client
          .rpc('listado_item_inspector', params: {'p_idins': idInspector});
      return resConsulta.then((value) => List<ItemDataModel>.from(
          value.map((e) => ItemDataModel.fromMap(e)).toList()));
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar obtener los datos de la base de datos: $e');
      rethrow;
    }
  }

  @override
  Future<List<ItemDataModel>> getItemsListaComprobacion(int idModelo) async {
    try {
      var resConsulta = _supabase.client
          .rpc('listado_item_modelo', params: {'p_idmodelo': idModelo});
      return resConsulta.then((value) => List<ItemDataModel>.from(
          value.map((e) => ItemDataModel.fromMap(e)).toList()));
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar obtener los datos de la base de datos: $e');
      rethrow;
    }
  }

  //Deveulve la lista de localidades que tenemos en la base de datos
  @override
  Future<List<LocalidadDataModel>> getLocalidades() async {
    try {
      var resConsulta = _supabase.client.rpc(
        'listado_localidades',
      );
      return resConsulta.then((value) => List<LocalidadDataModel>.from(
          value.map((e) => LocalidadDataModel.fromMap(e)).toList()));
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar obtener los datos de la base de datos: $e');
      rethrow;
    }
  }

  //Deveulve la lista de localidades de una provincia que tenemos en la base de datos
  @override
  Future<List<LocalidadDataModel>> getLocalidadesProvincia(
      int idProvincia) async {
    try {
      var resConsulta = _supabase.client.rpc('listado_localidades_provincia',
          params: {'p_idprov': idProvincia});
      return resConsulta.then((value) => List<LocalidadDataModel>.from(
          value.map((e) => LocalidadDataModel.fromMap(e)).toList()));
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar obtener los datos de la base de datos: $e');
      rethrow;
    }
  }

  @override
  Future<List<ListaComprobacionDataModel>>
      getModelosListasComprobacion() async {
    try {
      var resConsulta = _supabase.client.rpc('listado_modelo_lista');
      return resConsulta.then((value) => List<ListaComprobacionDataModel>.from(
          value.map((e) => ListaComprobacionDataModel.fromMap(e)).toList()));
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar obtener los datos de la base de datos: $e');
      rethrow;
    }
  }

  ///Obtengo el listado de chekclists creados por un inspecotr o que son generales y visbles para tods los inspectores
  //Si estrcto sólo mostramos los de ese inspector. Si no es estricto devuleve también los "públicos"

  @override
  Future<List<ListaComprobacionDataModel>>
      getModelosListasComprobacionInspector(int idInspector,
          {bool estricto = false}) async {
    try {
      var resConsulta = _supabase.client.rpc('listado_modelo_lista_inspector',
          params: {'p_idins': idInspector, 'p_estricto': estricto});
      return resConsulta.then((value) => List<ListaComprobacionDataModel>.from(
          value.map((e) => ListaComprobacionDataModel.fromMap(e)).toList()));
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar obtener los datos de la base de datos: $e');
      rethrow;
    }
  }

  ///Obtengo el listado de chekclists creados por un usuario o que son generales y visbles para tods los inspectores
  @override
  Future<List<ListaComprobacionDataModel>> getModelosListasComprobacionUsuario(
      String usuarioApp) async {
    try {
      //Obtengo el id de inspector
      int? idInspector = await getIdUsuarioPorNombre(usuarioApp);

      if (idInspector == null) {
        throw Exception(
            'No se ha encontrado ningún inspector con el nombre de usuario $usuarioApp');
      } else {
        return await getModelosListasComprobacionInspector(idInspector,
            estricto: false);
      }
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar obtener los datos de la base de datos: $e');
      rethrow;
    }
  }

  @override
  Future<List<ListaComprobacionDataModel>>
      getModelosListasComprobacionUsuarioSecureStorage() async {
    try {
      late String usuario;
      //Obtenemos el nombre del usuario del secure storage

      await getUsuarioAPPSecureStorage().then((usuarioSecureStorage) {
        usuario = usuarioSecureStorage;
      });
      //Obtengo el id de inspector
      int? idInspector = await getIdUsuarioPorNombre(usuario);

      if (idInspector == null) {
        throw Exception(
            'No se ha encontrado ningún inspector con el nombre de usuario $usuario');
      } else {
        return await getModelosListasComprobacionInspector(idInspector,
            estricto: true);
      }
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar obtener los datos de la base de datos: $e');
      rethrow;
    }
  }

  @override
  Future<List<NivelRiesgoPvdDataModel>> getNivelesRiesgoPVD() async {
    try {
      var resConsulta = _supabase.client.rpc('listado_pvd_nivel_riesgo');

      return resConsulta.then((value) => List<NivelRiesgoPvdDataModel>.from(
          value.map((e) => NivelRiesgoPvdDataModel.fromMap(e)).toList()));
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar obtener los datos de la base de datos: $e');
      rethrow;
    }
  }

  @override
  Future<NivelRiesgoPvdDataModel> getNivelRiesgoPvdPorId(
      int idNivelRiesgo) async {
    try {
      var resConsulta = await _supabase.client.rpc(
          'nivel_riesgo_pvd_por_valoracion',
          params: {'p_idnivel': idNivelRiesgo});

      resConsulta.length != 1
          ? throw Exception(
              'No se ha encontrado ningun dato con los parámetros indicados')
          : log.d('Se ha encontrado el nivel de riesgo');

      NivelRiesgoPvdDataModel nivelRiesgo =
          NivelRiesgoPvdDataModel.fromMap(resConsulta[0]);

      return nivelRiesgo;
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar obtener los datos de la base de datos: $e');
      rethrow;
    }
  }

  ///Obtenemos e nombre dle inspector a partir de su id

  @override
  Future<String> getNombreInspectorPorId(int idInspector) async {
    try {
      var resConsulta = await _supabase.client
          .rpc('nombre_inspector_por_id', params: {'p_idusu': idInspector});
      return resConsulta.first['usuario'] as String;
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar obtener los datos de la base de datos: $e');
      rethrow;
    }
  }

  @override
  Future<String> getNombreModeloPorId(int idModelo) async {
    try {
      var resConsulta = await _supabase.client
          .rpc('nombre_modelo_por_id', params: {'p_idmod': idModelo});
      return resConsulta.first['descripcion'] as String;
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar obtener los datos de la base de datos: $e');
      rethrow;
    }
  }

  ///Obtiene el número de acciones de una exigencia que tienen datos en el chequeo inicial de una inspección

  @override
  Future<int> getNumAccionesPorExigencia(int idExigencia) async {
    try {
      int resConsulta = await _supabase.client
          .rpc('num_acciones_exigencia', params: {'p_idexi': idExigencia});

      return resConsulta;
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar obtener los datos de la base de datos: $e');
      rethrow;
    }
  }

  ///Obtiene el número de acciones de una exigencia que tienen datos en el chequeo inicial de una inspección
  @override
  Future<int> getNumAccionesPorExigenciaConDatos(
      int idExigencia, int idInspeccion) async {
    ///Para obtener el número de acciones de una exigencia que tienen datos en el chequeo inicial de una inspección
    ///Como supabase complica muhco el realizar joins, lo que hacemos es crear una función en postgresql
    ///que nos devuleve ese dato. La función se llama  num_acciones_exigencia_con_datos(p_idexi int, p_idins int)
    try {
      int resConsulta = await _supabase.client.rpc(
          'num_acciones_exigencia_con_datos',
          params: {'p_idexi': idExigencia, 'p_idins': idInspeccion});

      return resConsulta;
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar obtener los datos de la base de datos: $e');
      rethrow;
    }
  }

  @override
  Future<List<OpcionCondicionDataModel>> getOpcionesCondicionesPVD() async {
    try {
      var resConsulta = _supabase.client.rpc('listado_pvd_opcion_condicion');
      return resConsulta.then((value) => List<OpcionCondicionDataModel>.from(
          value.map((e) => OpcionCondicionDataModel.fromMap(e)).toList()));
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar obtener los datos de la base de datos: $e');
      rethrow;
    }
  }

  @override
  Future<List<OpcionCondicionDataModel>> getOpcionesCondicionPvd(
      int idCondicion) {
    try {
      var resConsulta = _supabase.client.rpc(
        'listado_pvd_vw_opcion_condicion',
        params: {'p_idcond': idCondicion},
      );
      return resConsulta.then((value) => List<OpcionCondicionDataModel>.from(
          value.map((e) => OpcionCondicionDataModel.fromMap(e)).toList()));
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar obtener los datos de la base de datos: $e');
      rethrow;
    }
  }

  ////Listado de opciones de un item
  @override
  Future<List<OpcionDataModel>> getOpcionesItem(int idItem) async {
    try {
      var resConsulta = _supabase.client
          .rpc('opciones_por_item', params: {'p_iditem': idItem});
      return resConsulta.then((value) => List<OpcionDataModel>.from(
          value.map((e) => OpcionDataModel.fromMap(e)).toList()));
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar obtener los datos de la base de datos: $e');
      rethrow;
    }
  }

  @override
  Future<List<OpcionesItemModeloDataModel>> getOpcionesItemModelo(
      int idModelo) {
    try {
      var resConsulta = _supabase.client
          .rpc('opciones_por_modelo', params: {'p_idmodelo': idModelo});
      return resConsulta.then((value) => List<OpcionesItemModeloDataModel>.from(
          value.map((e) => OpcionesItemModeloDataModel.fromMap(e)).toList()));
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar obtener los datos de la base de datos: $e');
      rethrow;
    }
  }

  @override
  Future<List<OpcionPvdDataModel>> getOpcionesPVD() async {
    try {
      var resConsulta = _supabase.client.rpc(
        'listado_pvd_opcion',
      );
      return resConsulta.then((value) => List<OpcionPvdDataModel>.from(
          value.map((e) => OpcionPvdDataModel.fromMap(e)).toList()));
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar obtener los datos de la base de datos: $e');
      rethrow;
    }
  }

  ///Obtenemos el listado total de respuestas en tre las que podemos elegir a la hora de ccera un modelo de ckecklist
  @override
  Future<List<OpcionDataModel>> getOpcionesRespuestas() async {
    try {
      var resConsulta = _supabase.client.rpc('listado_opciones_respuesta');
      return resConsulta.then((value) => List<OpcionDataModel>.from(
          value.map((e) => OpcionDataModel.fromMap(e)).toList()));
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar obtener los datos de la base de datos: $e');
      rethrow;
    }
  }

  @override
  Future<List<OpcionDataModel>> getOpcionesRespuestasInspector(
      {required int idInspector}) {
    try {
      var resConsulta = _supabase.client.rpc(
          'listado_opciones_respuesta_inspector',
          params: {'p_idins': idInspector});
      return resConsulta.then((value) => List<OpcionDataModel>.from(
          value.map((e) => OpcionDataModel.fromMap(e)).toList()));
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar obtener los datos de la base de datos: $e');
      rethrow;
    }
  }

  @override
  Future<List<OpcionDataModel>> getOpcionesRespuestasInspectorPorNombre(
      {required String nombreInspector}) async {
    try {
      //Obtengo el idInspector por le nombre
      int? idInspector = await getIdUsuarioPorNombre(nombreInspector);

      if (idInspector == null) {
        throw Exception(
            'No se ha encontrado ningún inspector con el nombre de usuario $nombreInspector');
      } else {
        var resConsulta = _supabase.client.rpc(
            'listado_opciones_respuesta_inspector',
            params: {'p_idins': idInspector});
        return resConsulta.then((value) => List<OpcionDataModel>.from(
            value.map((e) => OpcionDataModel.fromMap(e)).toList()));
      }
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar obtener los datos de la base de datos: $e');
      rethrow;
    }
  }

  @override
  Future<OpcionPvdDataModel> getOpcionPVDPorId(int idOpcion) async {
    try {
      var resConsulta = await _supabase.client.rpc(
        'opcion_pvd_por_id',
        params: {'p_idopcion': idOpcion},
      );
      resConsulta.length != 1
          ? throw Exception(
              'No se ha encontrado ninguna opción con los parámetros indicados')
          : log.d('Se ha encontrado una opcion: $resConsulta');

      OpcionPvdDataModel opcion = OpcionPvdDataModel.fromMap(resConsulta[0]);

      return opcion;
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar obtener los datos de la base de datos: $e');
      rethrow;
    }
  }

  ///Devuelve la lista de países que tenemos en la base de datos
  @override
  Future<List<PaisDataModel>> getPaises() async {
    try {
      var resConsulta = _supabase.client.rpc(
        'listado_paises',
      );
      return resConsulta.then((value) => List<PaisDataModel>.from(
          value.map((e) => PaisDataModel.fromMap(e)).toList()));
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar obtener los datos de la base de datos: $e');
      rethrow;
    }
  }

  ///Devuelva la lista de provincias que tenemos en la base de datos
  @override
  Future<List<ProvinciaDataModel>> getProvincias() async {
    try {
      var resConsulta = _supabase.client.rpc(
        'listado_provincias',
      );
      return resConsulta.then((value) => List<ProvinciaDataModel>.from(
          value.map((e) => ProvinciaDataModel.fromMap(e)).toList()));
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar obtener los datos de la base de datos: $e');
      rethrow;
    }
  }

  ///Devuelve la lista de provincias que tenemos en la base de datos
  @override
  Future<List<ProvinciaDataModel>> getProvinciasCA(int idCA) async {
    try {
      var resConsulta = _supabase.client
          .rpc('listado_provincias_CA', params: {'p_idca': idCA});
      return resConsulta.then((value) => List<ProvinciaDataModel>.from(
          value.map((e) => ProvinciaDataModel.fromMap(e)).toList()));
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar obtener los datos de la base de datos: $e');
      rethrow;
    }
  }

  @override
  Future<List<PvdDataModel>> getPVDsPorInspeccion(int idInspeccion) {
    try {
      var resConsulta = _supabase.client.rpc('listado_pvd_inspeccion',
          params: {'p_idinspeccion': idInspeccion});
      return resConsulta.then((value) => List<PvdDataModel>.from(
          value.map((e) => PvdDataModel.fromMap(e)).toList()));
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar obtener los datos de la base de datos: $e');
      rethrow;
    }
  }

  ///Obtiene los datos de un responsable a partir de su id
  ///TODO. Creo que esto actualamnete no lo estoy usando en ningún sitio
  ///LO dejo porque la sintaxis del join es bastnate compleja y para me sirva de ejemplo,
  ///pero si quisieramos hacer como en el restyo de casos y consultar
  ///una función posgres, la función qu etengo cera y que devulve estos resultados es
  ///listado_responsables_por_accion(p_idaccion integer)
  @override
  Future<List<ResponsableDataModel>> getResponsableAccion(int idAccion) async {
    try {
      ///Obtengo los datos de los responsables de la acción
      ///Esa sintaxis tan extrña es la que me  indicaban el texto del error que
      ///daba cuando trataba de hacer el join de otra manera
      var resConsulta = await _supabase.client
          .from('responsablesaccion')
          .select('''
              idresponsable,
              responsable(denominacion) 
              ''')
          .eq('idaccion', idAccion)
          .order('idresponsable', ascending: true);
      return List<ResponsableDataModel>.from(resConsulta
          .map((e) => ResponsableDataModel.fromMapJoinResponsablesAccion(e))
          .toList());
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar obtener los datos de la base de datos: $e');
      rethrow;
    }
  }

  @override
  Future<List<ResponsableDataModel>> getResponsables() async {
    try {
      var resConsulta = _supabase.client.rpc(
        'listado_responsables',
      );
      return resConsulta.then((value) => List<ResponsableDataModel>.from(
          value.map((e) => ResponsableDataModel.fromMap(e)).toList()));
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar obtener los datos de la base de datos: $e');
      rethrow;
    }
  }

  @override
  Future<List<ResponsableAccionDataModel>> getResponsablesAcciones() {
    try {
      var resConsulta = _supabase.client.rpc(
        'listado_responsables_acciones',
      );
      return resConsulta.then((value) => List<ResponsableAccionDataModel>.from(
          value.map((e) => ResponsableAccionDataModel.fromMap(e)).toList()));
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar obtener los datos de la base de datos: $e');
      rethrow;
    }
  }

  @override
  Future<List<RespuestaOpcionPVDDataModel>> getRespuestasPVD(int idPVD) {
    try {
      var resConsulta = _supabase.client.rpc(
        'listado_pvd_respuestas',
        params: {'p_idpvd': idPVD},
      );
      return resConsulta.then((value) => List<RespuestaOpcionPVDDataModel>.from(
          value.map((e) => RespuestaOpcionPVDDataModel.fromMap(e)).toList()));
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar obtener los datos de la base de datos: $e');
      rethrow;
    }
  }

  ///Obtiene el resumen de datos de las acciones de una inspección

  @override
  Future<List<ResumenAccionesDataModel>> getResumenDatosAcciones(
      int idInspeccion) async {
    log.d('Obtención de resumen de datos de las acciones de la inspección');

    ///Obtenemos los datos de la inspección para el pdf
    try {
      var resConsulta = _supabase.client
          .rpc('resumen_datos_acciones', params: {'p_idins': idInspeccion});

      return resConsulta.then((value) => List<ResumenAccionesDataModel>.from(
          value.map((e) => ResumenAccionesDataModel.fromMap(e)).toList()));
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar obtener los datos de la base de datos: $e');
      rethrow;
    }
  }

  ///Obtenemos la lista de situaciones posibles para una acción

  @override
  Future<List<SituacionDataModel>> getSituaciones() {
    try {
      var resConsulta = _supabase.client.rpc(
        'listado_situaciones',
      );
      return resConsulta.then((value) => List<SituacionDataModel>.from(
          value.map((e) => SituacionDataModel.fromMap(e)).toList()));
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar obtener los datos de la base de datos: $e');
      rethrow;
    }
  }

  @override
  Future<List<SubaspectoDataModel>> getSubaspectoPorAspecto(int idAspecto) {
    try {
      var resConsulta = _supabase.client.rpc(
        'listado_pvd_subaspectos_aspecto',
        params: {'p_idasp': idAspecto},
      );
      return resConsulta.then((value) => List<SubaspectoDataModel>.from(
          value.map((e) => SubaspectoDataModel.fromMap(e)).toList()));
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar obtener los datos de la base de datos: $e');
      rethrow;
    }
  }

  @override
  Future<List<SubaspectoDataModel>> getSubaspectosPVD() async {
    try {
      var resConsulta = _supabase.client.rpc(
        'listado_pvd_subaspectos',
      );
      return resConsulta.then((value) => List<SubaspectoDataModel>.from(
          value.map((e) => SubaspectoDataModel.fromMap(e)).toList()));
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar obtener los datos de la base de datos: $e');
      rethrow;
    }
  }

  @override
  Future<List<TextoAccionDataModel>> getTextosAccionPVD() {
    try {
      var resConsulta = _supabase.client.rpc(
        'listado_pvd_textoaccion',
      );
      return resConsulta.then((value) => List<TextoAccionDataModel>.from(
          value.map((e) => TextoAccionDataModel.fromMap(e)).toList()));
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar obtener los datos de la base de datos: $e');
      rethrow;
    }
  }

  @override
  Future<List<TextoAccionDataModel>> getTextosAccionPVDPorNivelYTipo(
      {required int idTipoAccion, required int idNivelRiesgo}) async {
    try {
      var resConsulta = await _supabase.client
          .rpc('listado_pvd_textoaccion_por_tipoynivel', params: {
        'p_idtipoaccion': idTipoAccion,
        'p_idnivelriesgo': idNivelRiesgo
      });

      return resConsulta;
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar obtener los datos de la base de datos: $e');
      rethrow;
    }
  }

  @override
  Future<List<TipoCondicionDataModel>> getTipoCondicionesPVD() async {
    try {
      var resConsulta = _supabase.client.rpc(
        'listado_pvd_tipocondicion',
      );
      return resConsulta.then((value) => List<TipoCondicionDataModel>.from(
          value.map((e) => TipoCondicionDataModel.fromMap(e)).toList()));
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar obtener los datos de la base de datos: $e');
      rethrow;
    }
  }

  @override
  Future<List<TipoAccionDataModel>> getTiposAccionPVD() {
    try {
      var resConsulta = _supabase.client.rpc(
        'listado_pvd_tipoaccion',
      );
      return resConsulta.then((value) => List<TipoAccionDataModel>.from(
          value.map((e) => TipoAccionDataModel.fromMap(e)).toList()));
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar obtener los datos de la base de datos: $e');
      rethrow;
    }
  }

  @override
  Future<List<ValoracionDataModel>> getValoracionesPVD(int idPVD) {
    try {
      var resConsulta = _supabase.client
          .rpc('listado_pvd_valoraciones_por_pvd', params: {'p_idpvd': idPVD});
      return resConsulta.then((value) => List<ValoracionDataModel>.from(
          value.map((e) => ValoracionDataModel.fromMap(e)).toList()));
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar obtener los datos de la base de datos: $e');
      rethrow;
    }
  }

  @override
  Future<int> guardaItemModeloChecklist(
      int idInspector, ItemDataModel item) async {
    try {
      var response = await _supabase.client.rpc('insert_item', params: {
        'p_descripcion': item.descripcion,
        'p_idmodelo': item.idmodelo,
        'p_idinspector': item.idinspector,
        'p_modificable': item.modificable,
        'p_fecha_creacion': item.fechaCreacion!.toIso8601String(),
        'p_visible': item.visible,
        'p_predefinido': item.predefinido,
      });

      log.d(
          'EL inspector $idInspector ha insertado el ítem en la base de datos: $response');

      return response as int;
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar almacenar el ítem en la base de datos: $e');
      rethrow;
    }
  }

  @override
  Future<int> guardaModeloChecklist(
      int idInspector, ListaComprobacionDataModel modelo) async {
    try {
      var response = await _supabase.client.rpc('insert_modelo', params: {
        'p_descripcion': modelo.descripcion,
        'p_idinspector': idInspector,
        'p_modificable': modelo.modificable,
        'p_fecha_creacion': modelo.fechaCreacion!.toIso8601String(),
        'p_visible': modelo.visible,
        'p_predefinido': modelo.predefinido,
      });

      log.d(
          'EL inspector $idInspector ha insertado el modelo de checklist en la base de datos: $response');

      return response as int;
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar almacenar el modelo de checklist en la base de datos: $e');
      rethrow;
    }
  }

  @override
  Future<void> guardaOpcionesItemChecklist(int idInspector, int idItem,
      List<OpcionDataModel> opcionesRespuesta) async {
    try {
      OpcionDataModel opcion;

      for (opcion in opcionesRespuesta) {
        ///Obtengo el json de la inspección para insertarla en la bbdd
        var jsonInspeccion = opcion.toJson();

////TODO- Comprobar si se puede hacer un insert masivo y que sea más eficiente y atomico
        var response = await _supabase.client.from('opciones_item').insert({
          'iditem': idItem,
          'idopcion': jsonInspeccion['idopcion'],
        });

        log.d(
            'Se ha insertado la opción del ítem en la base de datos: $response');
      }
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar almacenar las opciones del ítem  del modelo checklist en la base de datos: $e');
      rethrow;
    }
  }

  /// Se almacena en Postgre una opción de respuesta
  @override
  Future<int> guardaOpcionRespuesta(
      int idInspector, OpcionDataModel opcionRespuesta) async {
    try {
      var resConsulta =
          await _supabase.client.rpc('inserta_opcion_respuesta', params: {
        'p_texto': opcionRespuesta.textoOpcion,
        'p_modificable': opcionRespuesta.modificable,
        'p_idinspector': opcionRespuesta.idinspector,
        'p_visible': opcionRespuesta.visible,
        'p_predefinido': opcionRespuesta.predefinido,
      });

      return resConsulta;
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar almacenar los datos de la base de datos: $e');
      rethrow;
    }
  }

  ////Se almacenan los datos del cchecklist (sin las respuestas, de esas se encarga el método guardarRespuestasChecklist
  ///Devuelve el id del checklist insertado
  @override
  Future<int?> guardarChecklist(ChecklistDataModel checklist) async {
    try {
      var resConsulta = await _supabase.client.rpc('insert_checklist', params: {
        'p_idmodelo': checklist.idmodelo,
        'p_idinspector': checklist.idinspector,
        'p_fecha_creacion': checklist.fechaCreacion,
        'p_idinspeccion': checklist.idinspeccion,
        'p_descripcion': checklist.descripcion
      });

      return resConsulta as int;
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar obtener los datos de la base de datos: $e');
      rethrow;
    }
  }

  ///Guarda/Actualiza los datos de una acción en el chequeo inicial de una inspección
  @override
  Future<void> guardarDatosAccionEnChequeoInicial(
      ChequeoInicialDataModel datosAccion) async {
    try {
      ///Obtengo el json de la inspección para insertarla en la bbdd
      var jsonAccion = datosAccion.toJson();

      ///Inserto los datos de la inspección en la bbdd. Es un upsert de modo
      ///que realizamos un insert si no existe y un update si ya existe
      var response = await _supabase.client.from('chequeoinicial').upsert({
        'idinspeccion': jsonAccion['idinspeccion'],
        'idaccion': jsonAccion['idaccion'],
        'idsituacion': jsonAccion['idsituacion'],
        'observaciones': jsonAccion['observaciones'],
        'fechaprev': jsonAccion['fechaprev'],
        'fechareal': jsonAccion['fechareal'],
      });

      log.d(
          'Se han los datos del chequeo  la acción en la base de datos: $response');
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar almacenar los datos del chequeo de la acción en la base de datos: $e');
      rethrow;
    }
  }

  ///Guarda/Actualiza los datos de una acción en el chequeo inicial de una inspección
  @override
  Future<void> guardarDatosAccionEnChequeoInicialRPC(
      ChequeoInicialDataModel datosAccion) async {
    try {
      ///Obtengo el json de los datos de la acción para insertarlos en la bbdd
      var jsonDatosAccion = datosAccion.toJson();

      var resConsulta =
          await _supabase.client.rpc('upsert_chequeo_inicial', params: {
        'p_chequeo_inicial': jsonDatosAccion,
      });

      log.d(
          'Se han insertado $jsonDatosAccion  datos de acción en  la base de datos. Id que se le ha dado es $resConsulta');
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar guardar los datos de la base de datos: $e');
      rethrow;
    }
  }

  ///Guarda los datos de una inspección llamando directamnet a insert en la bbdd
  ///usando la sintaxis propia de Supabase

  @override
  Future<void> guardarInspeccion(InspeccionDataModel inspeccion) async {
    try {
      ///Obtengo el json de la inspección para insertarla en la bbdd
      var jsonInspeccion = inspeccion.toJson();

      var response = await _supabase.client.from('inspeccion').insert({
        'fechainicio': jsonInspeccion['fechainicio'],
        'fechafin': jsonInspeccion['fechafin'],
        'direccion': jsonInspeccion['direccion'],
        'idprovincia': jsonInspeccion['idprovincia'],
        'idpais': jsonInspeccion['idpais'],
        'idlocalidad': jsonInspeccion['idlocalidad'],
        'idinspector': jsonInspeccion['idinspector'],
        'comentarios': jsonInspeccion['comentarios'],
      });

      log.d('objeto insertado: $jsonInspeccion');

      log.d('Se ha insertado la inspección en la base de datos: $response');
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar almacenar la inspección en la base de datos: $e');
      rethrow;
    }
  }

  ///Guarda los datos de una inspección llamando a uun función de Postgres mediate RPC
  ///Así evito usar la sintaxis propietaria de Suoabase/flutter para insertar datos
  ///y hacerlo más fácilmente portable para su uso en otras plataformas o en nuestro postgres propietario

  @override
  Future<void> guardarInspeccionRPC(InspeccionDataModel inspeccion) async {
    try {
      ///Obtengo el json de la inspección para insertarla en la bbdd
      var jsonInspeccion = inspeccion.toJson();

      var resConsulta =
          await _supabase.client.rpc('inserta_inspeccion', params: {
        'p_inspeccion': jsonInspeccion,
      });

      log.d(
          'Se ha insertado la inspección $jsonInspeccion la base de datos. Id que se le ha dado es $resConsulta');
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar obtener los datos de la base de datos: $e');
      rethrow;
    }
  }

  ///Se almacenan los datos del inspector en la tabla de base de datos
  @override
  Future<void> guardarInspector(InspectorDataModel inspector) async {
    try {
      ///Inserto el inspector
      ///No paso contraseña porque la contraseña que se usa es la de supabase
      ///no la de la tabla inspectores.
      var resConsulta = await _supabase.client.rpc('inserta_inspector',
          params: {'p_usuario': inspector.usuario, 'p_contrasena': null});
      log.d('Se ha insertado el inspector en la base de datos: $resConsulta');
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar almacenar los datos del inspector en la base de datos: $e');
      rethrow;
    }
  }

  @override
  Future<void> guardarPVD(PvdDataModel pvd, String usuarioAPP) async {
    try {
      ///Obtengo el json de la inspección para insertarla en la bbdd
      var jsonPVD = pvd.toJson();

      log.d('Se va a insertar PVD en la base de datos: $jsonPVD');

      var resConsulta = await _supabase.client.rpc('inserta_pvd', params: {
        'p_pvd': jsonPVD,
      });

      log.d(
          'Se ha insertado la PVD $jsonPVD la base de datos. Id que se le ha dado es $resConsulta');
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar obtener los datos de la base de datos: $e');
      rethrow;
    }
  }

  ///Se almacenan las respuestas de un checklist
  @override
  Future<void> guardarRespuestasChecklist(
      List<RespuestaItemDataModel> respuestasChecklist,
      List<ObservacionRespuestaDataModel> observacionesChecklist) async {
    try {
      RespuestaItemDataModel respuesta;
      ObservacionRespuestaDataModel observacion;

      for (respuesta in respuestasChecklist) {
        ///Obtengo el json de la inspección para insertarla en la bbdd
        var jsonInspeccion = respuesta.toJson();

////TODO- Comprobar si se puede hacer un insert masivo y que sea más eficiente y atomico
        var response = await _supabase.client.from('respuesta').insert({
          'idlista': jsonInspeccion['idlista'],
          'iditem': jsonInspeccion['iditem'],
          'idopcion': jsonInspeccion['idopcion'],
        });

        log.d('Se ha insertado la respuesta en la base de datos: $response');
      }

      //Obtengo el json de las observaciones para insertarla en la bbdd

      for (observacion in observacionesChecklist) {
        var jsonInspeccion = observacion.toJson();
        var response =
            await _supabase.client.from('observacion_respuesta').insert({
          'idlista': jsonInspeccion['idlista'],
          'iditem': jsonInspeccion['iditem'],
          'observacion': jsonInspeccion['observacion'],
        });
      }
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar almacenar los datos del checklist en la base de datos: $e');
      rethrow;
    }
  }

  ///Se almacenan las respuestas de un checklist.
  ///En vez de usar la sistaxis supabase uso llamada a funciones de postgres
  ///mediante RPC que evitan el tener que haver el buvcle loop de  insertando con supabase resuesta a respuesta
  @override
  Future<void> guardarRespuestasChecklistRPC(
      List<RespuestaItemDataModel> respuestasChecklist,
      List<ObservacionRespuestaDataModel> observacionesChecklist) async {
    try {
      var jsonListaRespuestas =
          respuestasChecklist.map((e) => e.toJson()).toList();

      var jsonListaObservaciones =
          observacionesChecklist.map((e) => e.toJson()).toList();

      ///Inserto las respuestas y las observaciones
      var resConsulta = await _supabase.client
          .rpc('inserta_respuestas_y_observaciones', params: {
        'p_respuestas': jsonListaRespuestas,
        'p_observaciones': jsonListaObservaciones
      });

      log.d(
          'Se han insertado las respuestas con sus observaciones en la base de datos: $resConsulta');
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar almacenar los datos del checklist en la base de datos: $e');
      rethrow;
    }
  }

  //Se encarga de insertar los datos de las respuestas de un PVD
  @override
  Future<void> guardarRespuestasPVD(
      List<RespuestaOpcionPVDDataModel> respuestasPVD) async {
    try {
      var jsonListaRespuestas = respuestasPVD.map((e) => e.toJson()).toList();

      ///Inserto las respuestas y las observaciones
      var resConsulta = await _supabase.client.rpc('inserta_respuestas_pvd',
          params: {'p_respuestaspvd': jsonListaRespuestas});

      log.d(
          'Se han insertado las respuestas con sus observaciones en la base de datos: $resConsulta');
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar almacenar los datos del PVD en la base de datos: $e');
      rethrow;
    }
  }

  @override
  Future<void> guardarValoracionesPVD(
      List<ValoracionDataModel> valoracionesPVD) async {
    try {
      var jsonListaValoraciones =
          valoracionesPVD.map((e) => e.toJson()).toList();

      ///Inserto las respuestas y las observaciones
      var resConsulta = await _supabase.client.rpc(
          'inserta_valoraciones_aspectos_pvd',
          params: {'p_valoracionespvd': jsonListaValoraciones});

      log.d(
          'Se han insertado las valoracions de los PVD en la base de datos: $resConsulta');
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar almacenar los datos del PVD en la base de datos: $e');
      rethrow;
    }
  }

  ///Obtenemos los datos de la categorías de los factores de riesgo de una Evaluación
  @override
  Future<List<CategoriaFactorRiesgoDataModel>>
      getCategoriasFactoresRiesgoEval() async {
    ///Obtenemos los datos de las categorías de factores de riesgo
    try {
      var resConsulta = _supabase.client.rpc('listado_eval_categoria_factor');

      return resConsulta.then((value) =>
          List<CategoriaFactorRiesgoDataModel>.from(value
              .map((e) => CategoriaFactorRiesgoDataModel.fromMap(e))
              .toList()));
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar obtener los datos de la base de datos: $e');
      rethrow;
    }
  }

  ///Obtenemos los datos de las factores de riesgo de una Evaluación
  @override
  Future<List<FactorRiesgoDataModel>> getFactoresRiesgoEval() async {
    try {
      var resConsulta = _supabase.client.rpc('listado_eval_factor_riesgo');

      return resConsulta.then((value) => List<FactorRiesgoDataModel>.from(
          value.map((e) => FactorRiesgoDataModel.fromMap(e)).toList()));
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar obtener los datos de la base de datos: $e');
      rethrow;
    }
  }

  //Obtenemos los datos de los factores de riesgo de unna ategoría en concreto de una evaluación
  @override
  Future<List<FactorRiesgoDataModel>> getFactoresRiesgoPorCategoriaEval(
      int idCategoria) async {
    try {
      var resConsulta = _supabase.client.rpc(
          'listado_eval_factores_por_categoria',
          params: {'p_idcat': idCategoria});
      return resConsulta.then((value) => List<FactorRiesgoDataModel>.from(
          value.map((e) => FactorRiesgoDataModel.fromMap(e)).toList()));
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar obtener los datos de la base de datos: $e');
      rethrow;
    }
  }

  //Obtenemos los datos de evaluaciones de una inspección

  @override
  Future<List<EvaluacionRiesgoDataModel>> getEvaluacionRiesgoPorInspeccionEval(
      int idInspeccion) async {
    try {
      var resConsulta = _supabase.client.rpc(
          'listado_eval_evaluacion_por_inspeccion',
          params: {'p_idinsp': idInspeccion});
      return resConsulta.then((value) => List<EvaluacionRiesgoDataModel>.from(
          value.map((e) => EvaluacionRiesgoDataModel.fromMap(e)).toList()));
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar obtener los datos de la base de datos: $e');
      rethrow;
    }
  }

//Obtenemos la lista de tipos de factores de riesgo de una evaluación (en principio son potencial y existente)
  @override
  Future<List<TipoFactorRiesgoDataModel>> getTiposFactoresRiesgoEval() async {
    try {
      var resConsulta = _supabase.client.rpc('listado_eval_tipo_factor');

      return resConsulta.then((value) => List<TipoFactorRiesgoDataModel>.from(
          value.map((e) => TipoFactorRiesgoDataModel.fromMap(e)).toList()));
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar obtener los datos de la base de datos: $e');
      rethrow;
    }
  }

  //Se almacenan los datos de la evaluación de un factor de riesgo
  //asociado a una inspección (insert o update en fucnión del caso)
  @override
  Future<void> guardarEvaluacionRiesgoEval(evaluacionRiesgo) async {
    try {
      var jsonEvaluacion = evaluacionRiesgo.toJson();
      log.d(
          'Se va a insertar la evaluación de un factor de riesgo en la base de datos: $jsonEvaluacion');

      ///Inserto las respuestas y las observaciones
      var resConsulta = await _supabase.client.rpc(
          'insert_evaluacion_factor_riesgo',
          params: {'p_evaluacioneval': jsonEvaluacion});

      log.d('Se ha insertado la evaluación en la base de datos: $resConsulta');
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar almacenar los datos de la evaluación en la base de datos: $e');
      rethrow;
    }
  }

  @override
  Future<void> actualizarEvaluacionRiesgoEval(
      EvaluacionRiesgoDataModel evaluacionRiesgo) async {
    try {
      var jsonEvaluacion = evaluacionRiesgo.toJson();
      log.d(
          'Se va a modificar la evaluación de un factor de riesgo en la base de datos: $jsonEvaluacion');

      ///Inserto las respuestas y las observaciones
      var resConsulta = await _supabase.client.rpc(
          'update_evaluacion_factor_riesgo',
          params: {'p_evaluacioneval': jsonEvaluacion});

      log.d(
          'Se ha actualizado la evaluación en la base de datos: $resConsulta');
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar almacenar los datos de la evaluación en la base de datos: $e');
      rethrow;
    }
  }

  @override
  Future<FactorRiesgoDataModel> getFactorRiesgoPorId(int idFactorRiesgo) async {
    try {
      var resConsulta = await _supabase.client.rpc(
        'factor_riesgo_por_id',
        params: {'p_idfactor': idFactorRiesgo},
      );
      resConsulta.length != 1
          ? throw Exception(
              'No se ha encontrado ningún factor con los parámetros indicados')
          : log.d('Se ha encontrado un factor: $resConsulta');

      FactorRiesgoDataModel opcion =
          FactorRiesgoDataModel.fromMap(resConsulta[0]);

      return opcion;
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar obtener los datos de la base de datos: $e');
      rethrow;
    }
  }

  @override
  Future<void> borrarEvaluacionRiesgoEval(
      {required int idInspeccion, required int idEvaluacionRiesgo}) async {
    Logger log = Logger();
    log.d('Borrado de Evaluación de Riesgo');
    try {
      String? respuesta = await _supabase.client.rpc('f_elimina_evaluacion',
          params: {'p_ideval': idEvaluacionRiesgo, 'p_idinsp': idInspeccion});

      log.d(respuesta);
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar eliminar los datos de la evaluación de riesgo: $e');
      rethrow;
    }
  }

  @override
  Future<bool> compruebaExisteUsuarioInspector(String usuario) async {
    try {
      var resConsulta = await _supabase.client
          .rpc('existe_inspector', params: {'usuario': usuario});
      var resultado = resConsulta.first['haydatos'];
      return resultado;
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar obtener los datos de la base de datos: $e');
      rethrow;
    }
  }

  @override
  Future<List<CategoriaPreguntaMaqDataModel>>
      getCategoriasPreguntasMaq() async {
    try {
      var resConsulta = _supabase.client.rpc(
        'listado_maq_categoria_preguntas',
      );
      return resConsulta.then((value) =>
          List<CategoriaPreguntaMaqDataModel>.from(value
              .map((e) => CategoriaPreguntaMaqDataModel.fromMap(e))
              .toList()));
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar obtener los datos de la base de datos: $e');
      rethrow;
    }
  }

  //Se obtienen los datos de los centros de trabajo pata evalauciones de máquinas
  @override
  Future<List<CentroMaqDataModel>> getCentrosMaq() async {
    try {
      var resConsulta = _supabase.client.rpc(
        'listado_maq_centro',
      );
      return resConsulta.then((value) => List<CentroMaqDataModel>.from(
          value.map((e) => CentroMaqDataModel.fromMap(e)).toList()));
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar obtener los datos de la base de datos: $e');
      rethrow;
    }
  }

  @override
  Future<List<MaquinaMaqDataModel>> getMaquinasMaq() {
    // TODO: implement getMaquinasMaq
    throw UnimplementedError();
  }

  @override
  Future<List<MaquinaMaqDataModel>> getMaquinasMaqInspector(int idInspector) {
    // TODO: implement getMaquinasMaqInspector
    throw UnimplementedError();
  }

  @override
  Future<List<OpcionPreguntaMaqDataModel>> getOpcionesPreguntaMaq() async {
    try {
      var resConsulta = _supabase.client.rpc(
        'listado_maq_opciones_pregunta',
      );
      return resConsulta.then((value) => List<OpcionPreguntaMaqDataModel>.from(
          value.map((e) => OpcionPreguntaMaqDataModel.fromMap(e)).toList()));
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar obtener los datos de la base de datos: $e');
      rethrow;
    }
  }

  @override
  Future<List<OpcionPreguntaMaqDataModel>> getOpcionesPreguntaPorPreguntaMaq(
      int idPregunta) {
    // TODO: implement getOpcionesPreguntaPorPreguntaMaq
    throw UnimplementedError();
  }

  @override
  Future<List<OpcionRespuestaMaqDataModel>> getOpcionesRespuestaMaq() async {
    try {
      var resConsulta = _supabase.client.rpc(
        'listado_maq_opcion_respuesta',
      );
      return resConsulta.then((value) => List<OpcionRespuestaMaqDataModel>.from(
          value.map((e) => OpcionRespuestaMaqDataModel.fromMap(e)).toList()));
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar obtener los datos de la base de datos: $e');
      rethrow;
    }
  }

  @override
  Future<List<PreguntaMaqDataModel>> getPreguntasMaq() async {
    try {
      var resConsulta = _supabase.client.rpc(
        'listado_maq_pregunta',
      );
      return resConsulta.then((value) => List<PreguntaMaqDataModel>.from(
          value.map((e) => PreguntaMaqDataModel.fromMap(e)).toList()));
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar obtener los datos de la base de datos: $e');
      rethrow;
    }
  }

  @override
  Future<List<PreguntaMaqDataModel>> getPreguntasMaqPorCategoria(
      int idCategoria) {
    // TODO: implement getPreguntasMaqPorCategoria
    throw UnimplementedError();
  }

  @override
  Future<List<TipoEvaluacionMaqDataModel>> getTiposEvaluacionesMaq() async {
    // Obtiene los datos de la RPC listado_maq_tipo_evaluacion
    try {
      var resConsulta = _supabase.client.rpc(
        'listado_maq_tipo_evaluacion',
      );
      return resConsulta.then((value) => List<TipoEvaluacionMaqDataModel>.from(
          value.map((e) => TipoEvaluacionMaqDataModel.fromMap(e)).toList()));
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar obtener los datos de la base de datos: $e');
      rethrow;
    }
  }

  //Listado de evaluaciones de maquina
  @override
  Future<List<EvaluacionMaqDataModel>> getEvaluacionesMaq() async {
    try {
      var resConsulta = await _supabase.client.rpc('listado_maq_evaluacion');
      return List<EvaluacionMaqDataModel>.from(
          resConsulta.map((e) => EvaluacionMaqDataModel.fromMap(e)).toList());
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar obtener los datos de la base de datos: $e');
      rethrow;
    }
  }

  //Listado de evaluaciones de maquina por inspector
  @override
  Future<List<EvaluacionMaqDataModel>> getEvaluacionesPorInspectorMaq(
      int idInspector) async {
    try {
      var resConsulta = await _supabase.client.rpc(
          'listado_maq_evaluaciones_inspector',
          params: {'p_idins': idInspector});
      return List<EvaluacionMaqDataModel>.from(
          resConsulta.map((e) => EvaluacionMaqDataModel.fromMap(e)).toList());
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar obtener los datos de la base de datos: $e');
      rethrow;
    }
  }

  @override
  Future<MaquinaMaqDataModel> getMaquinaPorId(int idMaquina) async {
    try {
      var resConsulta = await _supabase.client
          .rpc('maquina_por_id', params: {'p_idmaq': idMaquina});
      return MaquinaMaqDataModel.fromMap(resConsulta.first);
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar obtener los datos de la base de datos: $e');
      rethrow;
    }
  }

  @override
  Future<CentroMaqDataModel> getCentroPorId(int idCentro) async {
    try {
      var resConsulta = await _supabase.client
          .rpc('centro_por_id', params: {'p_idcen': idCentro});
      if (resConsulta.length != 1) {
        throw Exception(
            'Se ha producido un error al intentar obtener los datos de la base de datos: No se ha encontrado el centro');
      }
      return CentroMaqDataModel.fromMap(resConsulta.first);
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar obtener los datos de la base de datos: $e');
      rethrow;
    }
  }

  @override
  Future<MaquinaMaqDataModel> getMaquinaPorIdEvaluacion(
      int idEvaluacion) async {
    try {
      var resConsulta = await _supabase.client
          .rpc('listado_maq_evaluacion', params: {'p_ideval': idEvaluacion});
      if (resConsulta.length != 1) {
        throw Exception(
            'Se ha producido un error al intentar obtener los datos de la base de datos: No se ha encontrado el centro');
      }
      return MaquinaMaqDataModel.fromMap(resConsulta.first);
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar obtener los datos de la base de datos: $e');
      rethrow;
    }
  }

  //Devuelve los datos de la evaluación de una máquinan alamacenados en BBDD
  //Ejemplo de datos devueltos:
  //Columans: "idmaq"	"maquina"	"fabricante"	"numserie"	"fecha_fabricacion"	"fecha_servicio"	"ideval"	"idinspector"	"fecha_realizacion"	"fecha_caducidad"	"idcentro"	"denominacion"	"idpregunta"	"idrespuesta"	"observacion"
  //Fila: 1	"nombre mñaquina"	"fabricante maq"	"#ewewewe"	"2024-02-06"	"2024-02-07"	6	1	"2024-02-08"	"2024-05-18"	1	"DDCyL"	null	null	null

  @override
  Future<DatosFormularioMaquina?> getDatosFormularioMaquina(
      int idEvaluacion) async {
    try {
      DatosFormularioMaquina datosFormularioMaquina;

      var resConsulta = await _supabase.client
          .rpc('datos_form_maq_en_bbdd', params: {'p_ideval': idEvaluacion});

      //Si me devuleve al menos un resultado, lo mapeo a un objeto de tipo DatosFormularioMaquina
      //Estos datos generales son los mismos en todas las filas, así  que cojo el primero

      if (resConsulta.isNotEmpty) {
        //Tomo los datos generales de la evaluación : evaluacion, maquina, centro, inspector
        datosFormularioMaquina =
            DatosFormularioMaquina.datosGeneralesFromMap(resConsulta.first);

        //Ahora tomo los datos de las preguntas y respuestas y las observaciones
        List<RespuestaPreguntaMaqDataModel?>? respuestasPreguntasenBBDD = [];
        List<ObservacionRespuestaMaqDataModel?>? observacionesRespuestasenBBDD =
            [];

        for (var fila in resConsulta) {
          RespuestaPreguntaMaqDataModel respuestaEnFila =
              RespuestaPreguntaMaqDataModel.fromMap(fila);
          ObservacionRespuestaMaqDataModel observacionEnFila =
              ObservacionRespuestaMaqDataModel.fromMapDatosFormMaqEnBBDD(fila);

          //Sólo la añado si el id de la pregunta y de la respuesta no son nulos
          if (respuestaEnFila.idpregunta != null &&
              respuestaEnFila.idrespuesta != null) {
            respuestasPreguntasenBBDD.add(respuestaEnFila);
          }
          //Sui hay algo en la observación, la añado
          if (observacionEnFila.observacion != null) {
            observacionesRespuestasenBBDD.add(observacionEnFila);
          }
        }

        datosFormularioMaquina.respuestasPreguntas = respuestasPreguntasenBBDD;
        datosFormularioMaquina.observacionesPreguntas =
            observacionesRespuestasenBBDD;

        return datosFormularioMaquina;
      } else {
        return null;
      }
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar obtener los datos de la base de datos: $e');
      rethrow;
    }
  }

  @override
  Future<List<CentroMaqDataModel>> getCentrosConEvalMaqInspector(
      int idInspector) async {
    try {
      var resConsulta = await _supabase.client
          .rpc('listado_maq_centro_insp', params: {'p_idinsp': idInspector});
      return List<CentroMaqDataModel>.from(
          resConsulta.map((e) => CentroMaqDataModel.fromMap(e)).toList());
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar obtener los datos de la base de datos: $e');
      rethrow;
    }
  }

  @override
  Future<List<CentroMaqDataModel>> getCentrosMasFrecuentesMaqInspector(
      int idInspector) async {
    try {
      var resConsulta = _supabase.client.rpc('listado_maq_centro_habitual_insp',
          params: {'p_idinsp': idInspector});
      return resConsulta.then((value) => List<CentroMaqDataModel>.from(
          value.map((e) => CentroMaqDataModel.fromMap(e)).toList()));
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar obtener los datos de la base de datos: $e');
      rethrow;
    }
  }

  @override
  Future<List<CentroMaqDataModel>> getCentrosMasRecientesMaqInspector(
      int idInspector) async {
    try {
      var resConsulta = _supabase.client.rpc(
          'listado_maq_centro_eval_reciente_insp',
          params: {'p_idinsp': idInspector});
      return resConsulta.then((value) => List<CentroMaqDataModel>.from(
          value.map((e) => CentroMaqDataModel.fromMap(e)).toList()));
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar obtener los datos de la base de datos: $e');
      rethrow;
    }
  }

  @override
  Future<void> guardaCentroMaq(CentroMaqDataModel centro) async {
    //Inserta un centro de trabajo en la base de datos
    try {
      var jsonMaq = centro.toJson();

      var resConsulta =
          await _supabase.client.rpc('inserta_centro_maq', params: {
        'p_centro': jsonMaq,
      });

      log.d(
          'Se ha insertado la PVD $jsonMaq la base de datos. Id que se le ha dado es $resConsulta');
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar obtener los datos de la base de datos: $e');
      rethrow;
    }
  }

  @override
  Future<void> eliminaCentroMaq(int idCentro) {
    // TODO: implement eliminaCentroMaq
    //OJO: hay que tener en cuenta que si hay máquinas asociadas a este centro, no se podrá eliminar
    throw UnimplementedError();
  }

  @override
  Future<List<ResumenEvalMaqDataModel>> getDatosResumenEvalMaq(
      int idEval) async {
    ///Obtenemos los datos de la inspección para el pdf
    try {
      var resConsulta = _supabase.client
          .rpc('datos_resumen_eval_maq', params: {'p_ideval': idEval});

      return resConsulta.then((value) => List<ResumenEvalMaqDataModel>.from(
          value.map((e) => ResumenEvalMaqDataModel.fromMap(e)).toList()));
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar obtener los datos de la base de datos: $e');
      rethrow;
    }
  }

  @override
  Future<List<DatosEvaluacionMaquinaDataModel>>
      getDatosListadoEvaluacionesMaquinas(int idInspector) async {
    try {
      var resConsulta = await _supabase.client.rpc('datos_listado_eval_maq',
          params: {'p_idinspector': idInspector});

      return List<DatosEvaluacionMaquinaDataModel>.from(resConsulta
          .map((e) => DatosEvaluacionMaquinaDataModel.fromMap(e))
          .toList());
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar obtener los datos de la base de datos: $e');
      rethrow;
    }
  }

  @override
  Future<int> guardaEvaluacionMaquina(
      DatosFormularioMaquina datosFormularioMaquina) async {
    try {
      //Obtengo los diferenets objetso a inserta a partir del objeto de datosFormularioEvaluacion
      var jsonEvaluacion = datosFormularioMaquina.evaluacion?.toJson();
      var jsonCentro = datosFormularioMaquina.centro?.toJson();
      var jsonMaquina = datosFormularioMaquina.maquina?.toJson();

//Filtro la lista de respuestas y observaciones para que no haya nulos
      List<RespuestaPreguntaMaqDataModel?> respuestasSinNulos =
          datosFormularioMaquina.respuestasPreguntas!.where((item) {
        return item!.idrespuesta != null;
      }).toList();
      List<ObservacionRespuestaMaqDataModel?> observacionesSinNulos =
          datosFormularioMaquina.observacionesPreguntas!.where((item) {
        return item!.observacion != null;
      }).toList();
      var jsonListaRespuestas =
          respuestasSinNulos.map((e) => e?.toJson()).toList();
      var jsonListaObservaciones =
          observacionesSinNulos.map((e) => e?.toJson()).toList();

      log.d(
          'Se va a insertar la evaluación de una evaluación de máquina en la base de datos');
      ;

      ///Inserto las respuestas y las observaciones
      var resConsulta =
          await _supabase.client.rpc('inserta_maq_datos_evaluacion', params: {
        'p_evaluacion': jsonEvaluacion,
        'p_centro': jsonCentro,
        'p_maquina': jsonMaquina,
        'p_respuestas': jsonListaRespuestas,
        'p_observaciones': jsonListaObservaciones
      });

      log.d('Se ha insertado la evaluación en la base de datos: $resConsulta');
      return resConsulta as int;
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar almacenar los datos de la evaluación en la base de datos: $e');
      rethrow;
    }
  }

  @override
  Future<List<CentroMaqDataModel>> getCentrosVisiblesInspectorMaq(
      {required int idInspector, required bool estricto}) async {
    try {
      var resConsulta = _supabase.client.rpc('listado_maq_centro_inspector',
          params: {
            'p_idinsp': idInspector,
            'p_ver_centros_comunes': !estricto
          });
      return resConsulta.then((value) => List<CentroMaqDataModel>.from(
          value.map((e) => CentroMaqDataModel.fromMap(e)).toList()));
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar obtener los datos de la base de datos: $e');
      rethrow;
    }
  }

  @override
  Future<List<DatosPdfMaqDataModel>> getDatosPdfEvaluacionMaquina(
      int idEvaluacion) async {
    ///Obtenemos los datos de la inspección para el pdf
    try {
      var resConsulta = _supabase.client
          .rpc('datos_pdf_maq', params: {'p_ideval': idEvaluacion});

      return resConsulta.then((value) => List<DatosPdfMaqDataModel>.from(
          value.map((e) => DatosPdfMaqDataModel.fromMap(e)).toList()));
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar obtener los datos de la base de datos: $e');
      rethrow;
    }
  }

  //Comprobamos si una evaluación de maquina pertenece a un inspector
  @override
  Future<bool> compruebaEvalMaqEsDeInsp(
      {required int idinps, required int idEvalMaq}) async {
    try {
      var resConsulta = await _supabase.client.rpc('es_evalmaq_de_inspector',
          params: {'p_idinsp': idinps, 'p_idevalmaq': idEvalMaq});
      var resultado = resConsulta.first['esdeelinsp'];
      return resultado;
    } catch (e) {
      log.e(
          'Se ha producido un error al intentar obtener los datos de la base de datos: $e');
      rethrow;
    }
  }
}
*/
