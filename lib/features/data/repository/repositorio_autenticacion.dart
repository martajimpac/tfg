import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:logger/logger.dart';

import '../shared_prefs.dart';
import '../../../generated/l10n.dart';

part 'repositorio_autenticacion_supabase.dart';

abstract class RepositorioAutenticacion {
  Future<String?> signInEmailAndPassword(String email, String password, BuildContext context);
}