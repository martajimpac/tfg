import 'package:evaluacionmaquinas/core/utils/Constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../shared_prefs.dart';
import 'auth_exceptions.dart';

part 'repositorio_autenticacion_supabase.dart';

abstract class RepositorioAutenticacion {
  Future<void> signInWithEmailAndPassword(String email, String password);

  Future<void> resendConfirmationEmail(String email, String password);

  Future<void> signUp(String name, String email, String password);

  Future<void> changePassword(String currentPassword, String newPassword);

  Future<void> resetPassword(String newPassword);

  Future<void> editProfile(String newName);

  Future<void> sendResetPasswordEmail(String email);
}