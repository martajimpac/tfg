import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:logger/logger.dart';
part 'repositorio_autenticacion_supabase.dart';

abstract class RepositorioAutenticacion {
  Future<String> signInEmailAndPassword(String email, String password);
}
