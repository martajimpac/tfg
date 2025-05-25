import 'package:flutter/material.dart';
import 'package:prl_chcklst_23/modelos/inspeccion_dm.dart';
import 'package:prl_chcklst_23/repositorios/repositorio_db_supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:prl_chcklst_23/utils/excel.dart';
import 'package:prl_chcklst_23/env/env.dart';

///Creo prueba para la generación del excel

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  Supabase supabase =
      await Supabase.initialize(url: Env.urlSupa, anonKey: Env.keySupa);

  await GenerarExcel.generarExcelChequeoInicialMinisdef(
      //
      InspeccionDataModel(fechainicio: DateTime.now(), idinspector: 23),
      RepositorioDBSupabase(supabase));
}
