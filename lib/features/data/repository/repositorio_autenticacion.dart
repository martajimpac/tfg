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
  Future<String?> signInWithEmailAndPassword(String email, String password, BuildContext context);

  Future<String?> resendConfirmationEmail(String email, String password, BuildContext context);

  Future<String?> signUp(String name, String email, String password, BuildContext context);

  Future<String?> changePassword(String currentPassword, String newPassword, BuildContext context);

  Future<String?> resetPassword(String newPassword, BuildContext context);

  Future<String?> editProfile(String newName, BuildContext context);
}