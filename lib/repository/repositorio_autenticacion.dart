import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:logger/logger.dart';

import '../generated/l10n.dart';
import '../utils/Utils.dart';
import '../views/my_home_page.dart';
part 'repositorio_autenticacion_supabase.dart';

abstract class RepositorioAutenticacion {
  Future<String> signInEmailAndPassword(String email, String password, BuildContext context);
}
