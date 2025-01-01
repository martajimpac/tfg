import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/utils/Utils.dart';
import '../../data/shared_prefs.dart';
import '../../../generated/l10n.dart';


abstract class ChangePasswordState extends Equatable {
  const ChangePasswordState();

  @override
  List<Object> get props => [];
}

class ChangePasswordInitial extends ChangePasswordState {
  final bool isEmailRed;
  final bool isPasswordRed;

  const ChangePasswordInitial(this.isEmailRed, this.isPasswordRed);

  @override
  List<Object> get props => [isEmailRed, isPasswordRed];
}

class ChangePasswordLoading extends ChangePasswordState {}

class ChangePasswordSuccess extends ChangePasswordState {}

class ChangePasswordError extends ChangePasswordState {
  final String message;
  final bool isCurrentPasswordRed;
  final bool isNewPasswordRed;
  final bool isConfirmPasswordRed;

  const ChangePasswordError(this.message, this.isCurrentPasswordRed, this.isNewPasswordRed, this.isConfirmPasswordRed);
}

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  final SupabaseClient supabase;

  ChangePasswordCubit(this.supabase) : super(ChangePasswordInitial(true, true));

  Future<void> changePassword(String currentPassword, String newPassword, String confirmPassword, BuildContext context) async {

    bool isCurrentPasswordRed = false;
    bool isNewPasswordRed = false;
    bool isConfirmPasswordRed = false;
    isCurrentPasswordRed = currentPassword.isEmpty;
    isNewPasswordRed = newPassword.isEmpty;
    isConfirmPasswordRed = confirmPassword.isEmpty;

    emit(ChangePasswordLoading());
    if (currentPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      var message = S.of(context).errorEmpty;
      emit(ChangePasswordError(message, isCurrentPasswordRed, isNewPasswordRed, isConfirmPasswordRed));
      return;
    }

    if (newPassword != confirmPassword) {
      isCurrentPasswordRed = false;
      isNewPasswordRed = true;
      isConfirmPasswordRed = true;
      var message = S.of(context).errorChangePasswordNoMatch;
      emit(ChangePasswordError(message, isCurrentPasswordRed, isNewPasswordRed, isConfirmPasswordRed));
      return;
    }
    if (newPassword.length < 6) {
      isCurrentPasswordRed = false;
      isNewPasswordRed = true;
      isConfirmPasswordRed = true;
      var message = S.of(context).errorChangePasswordLength;
      emit(ChangePasswordError(message, isCurrentPasswordRed, isNewPasswordRed, isConfirmPasswordRed));
      return;
    }

    try {
      // Autenticar al usuario con la contraseña actual
      await supabase.auth.signInWithPassword(
        email: supabase.auth.currentUser!.email!,
        password: currentPassword,
      );
      isConfirmPasswordRed = false;

    } catch (error) {
      isCurrentPasswordRed = true;
      var message = S.of(context).errorChangePasswordIncorrect;
      emit(ChangePasswordError(message, isCurrentPasswordRed, isNewPasswordRed, isConfirmPasswordRed));
      return;
    }

    try {
      // Si la autenticación es exitosa, cambiar la contraseña
      await supabase.auth.updateUser(
        UserAttributes(password: newPassword),
      );

      emit(ChangePasswordSuccess());

    } on AuthException catch (error) {
      var message = S.of(context).errorChangePasswordNoChange;
      emit(ChangePasswordError(message, isCurrentPasswordRed, isNewPasswordRed, isConfirmPasswordRed));

    } catch (error) {
      var message = S.of(context).errorChangePassword;
      emit(ChangePasswordError(message, isCurrentPasswordRed, isNewPasswordRed, isConfirmPasswordRed));
    }
  }


  Future<void> resetPassword(String newPassword, String confirmPassword, BuildContext context) async {

    bool isNewPasswordRed = newPassword.isEmpty;
    bool isConfirmPasswordRed = confirmPassword.isEmpty;

    emit(ChangePasswordLoading());
    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      var message = S.of(context).errorEmpty;
      emit(ChangePasswordError(message, false, isNewPasswordRed, isConfirmPasswordRed));
      return;
    }

    if (newPassword != confirmPassword) {
      isNewPasswordRed = true;
      isConfirmPasswordRed = true;
      var message = S.of(context).errorChangePasswordNoMatch;
      emit(ChangePasswordError(message, false, isNewPasswordRed, isConfirmPasswordRed));
      return;
    }
    if (newPassword.length < 6) {
      isNewPasswordRed = true;
      isConfirmPasswordRed = true;

      var message = S.of(context).errorChangePasswordLength;
      emit(ChangePasswordError(message, false, isNewPasswordRed, isConfirmPasswordRed));
      return;
    }

    try {
      // Usamos el método resetPassword de Supabase para resetear la contraseña usando el token
      final userRes = await Supabase.instance.client.auth.updateUser(
        UserAttributes(
          password: newPassword,
        ),
      );

      if(userRes.user != null){
        emit(ChangePasswordSuccess());
      }else{
        var message = S.of(context).errorChangePassword;
        emit(ChangePasswordError(message, false, isNewPasswordRed, isConfirmPasswordRed));
        return;
      }


    } catch (error) {
      var message = S.of(context).errorChangePassword;
      emit(ChangePasswordError(message, false, isNewPasswordRed, isConfirmPasswordRed));
      return;
    }
  }
}
