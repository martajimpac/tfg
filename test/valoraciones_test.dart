// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:prl_chcklst_23/env/env.dart';
import 'package:prl_chcklst_23/repositorios/repositorio_almacenamiento_local.dart';
import 'package:prl_chcklst_23/repositorios/repositorio_autenticacion.dart';
import 'package:prl_chcklst_23/repositorios/repositorio_db.dart';
import 'package:prl_chcklst_23/repositorios/repositorio_db_supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:test/test.dart';
import 'package:prl_chcklst_23/bloc/pvd/pvd_bloc.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  Supabase supabase =
      await Supabase.initialize(url: Env.urlSupa, anonKey: Env.keySupa);
  RepositorioAutenticacion supaRepo = SupabaseAuthRepository(supabase);
  RepositorioDBInspecciones repoDB = RepositorioDBSupabase(supabase);
  RepositorioLocalHive repoLocal = RepositorioLocalHive();

  PvdBloc pvdBloc = PvdBloc(repoDB, repoLocal);

  group('valoraTemperaturaPVD', () {
    test('1 cuando temp 22', () {
      final result = pvdBloc.valoraTemperaturaPVD(22);
      expect(result, equals(1));
    });

    test('3 temp 30', () {
      final result = pvdBloc.valoraTemperaturaPVD(30);
      expect(result, equals(3));
    });

    test('3 temp 10', () {
      final result = pvdBloc.valoraTemperaturaPVD(10);
      expect(result, equals(3));
    });
  });

  group('valoraHumedadPVD', () {
    test('returns "Humedad óptima" when humidity is between 40 and 65', () {
      final result = pvdBloc.valoraHumedadPVD(50);
      expect(result, equals(1));
    });

    test('returns "Humedad alta" when humidity is above 60', () {
      final result = pvdBloc.valoraHumedadPVD(70);
      expect(result, equals(3));
    });

    test('returns "Humedad baja" when humidity is below 40', () {
      final result = pvdBloc.valoraHumedadPVD(30);
      expect(result, equals(3));
    });
  });
}
