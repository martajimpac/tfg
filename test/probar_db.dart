//unit test de la clase SupabaseAuthRepository

import 'package:flutter/material.dart';
import 'package:prl_chcklst_23/bloc/maq/bloc/maquina_bloc.dart';
import 'package:prl_chcklst_23/env/env.dart';
import 'package:prl_chcklst_23/repositorios/repositorio_db_supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  Supabase supabase =
      await Supabase.initialize(url: Env.urlSupa, anonKey: Env.keySupa);
  RepositorioDBSupabase supaRepo = RepositorioDBSupabase(supabase);

  //Vamos a probar el funcionamiento de getDatosFormularioMaquina(5)

  DatosFormularioMaquina? pruebaDatos =
      await supaRepo.getDatosFormularioMaquina(5);

  if (pruebaDatos != null) {
    print(pruebaDatos.dameloComoCadena());
  } else {
    print('No se han encontrado datos');
  }

  //Prueba de la función de getCentrosVisiblesInspectorMaqConEvaluaciones
  Map<int, bool> centros =
      await supaRepo.getCentrosVisiblesInspectorMaqConEvaluaciones(
          idInspector: 1, estricto: false);

//Prueba de la función de elimar evalauciones de máquina

  // await supaRepo.borrarEvaluacionMaq(idEval: 1, idInspector: 4);
  /* var resultado = await supabase.client.schema('prl').from('prueba').select();
  bool kDebugMode = false;
  if (kDebugMode) {
    print(resultado[0]);
  }*/
  /*List<ResponsableDataModel> responsables =
      await supaRepo.getResponsableAccion(32);

  //Hago un print de los responsables para ver si se han cargado bien
  for (var element in responsables) {
    print(element.denominacion);
  }

  List<ResumenAccionesDataModel> listaResumen =
      await supaRepo.getResumenDatosAcciones(25);
  //25 es el id de la inspección

  for (var element in listaResumen) {
    print(element.idinsp);
    print(element.idexi);
    print(element.accionesDatos);
    print(element.accionesTotales);
  }
*/
  /* List<int> listaAccionesConDatos =
      await supaRepo.getIdsAccionesConDatos(25);
  for (var element in listaAccionesConDatos) {
    print('Id Acción con dato $element');
  }*/

  ///Ejecutamos la creación del documento word

  /*String pathFicheroGenerado =
      await GenerarWord.generarInformeWord(25, supaRepo);
  print('Se ha generado el fichero $pathFicheroGenerado');*/

  /*List<ChequeoInicialDataModel> listaChequeoInicial =
      await supaRepo.getDatosAccionesExigenciaEnChequeoInicial(100, 1);

  for (var element in listaChequeoInicial) {
    print(element.toString());
  }*/

  /*bool hayDatos =
      await supaRepo.compruebaSiHayDatosChequeoInicialInspeccion(32);
  print(hayDatos);*/
}
