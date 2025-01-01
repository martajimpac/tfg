import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/utils/Utils.dart';
import '../../data/shared_prefs.dart';
import '../../../generated/l10n.dart';


abstract class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object> get props => [];
}

class RegisterInitial extends RegisterState {
  final bool isEmailRed;
  final bool isPasswordRed;

  const RegisterInitial(this.isEmailRed, this.isPasswordRed);

  @override
  List<Object> get props => [isEmailRed, isPasswordRed];
}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {}

class RegisterError extends RegisterState {
  final String message;
  final bool isEmailRed;
  final bool isPasswordRed;
  final bool isRepeatPasswordRed;

  const RegisterError(this.message, this.isEmailRed, this.isPasswordRed, this.isRepeatPasswordRed);
}

class RegisterCubit extends Cubit<RegisterState> {
  final SupabaseClient supabase;

  RegisterCubit(this.supabase) : super(RegisterInitial(true, true));


  Future<void> register(String name, String email, String password, String repeatPassword, BuildContext context) async {
    var isEmailRed = false;
    var isPasswordRed = false;
    var isRepeatPasswordRed = false;

    emit(RegisterLoading());

    if (email.isEmpty || password.isEmpty || repeatPassword.isEmpty) {

      isEmailRed = email.isEmpty;
      isPasswordRed = password.isEmpty;
      isRepeatPasswordRed = repeatPassword.isEmpty;

      emit(RegisterError(S.of(context).errorEmpty, isEmailRed, isPasswordRed, isRepeatPasswordRed));
      return;

    } else if (password != repeatPassword) {
      isRepeatPasswordRed = true;
      isPasswordRed = true;
      isEmailRed = false;

      emit(RegisterError(S.of(context).errorEmpty, isEmailRed, isPasswordRed, isRepeatPasswordRed));
      return;
    }

    isEmailRed = false;
    isPasswordRed = false;
    isRepeatPasswordRed = false;

    try {
      // Proceder con el registro
      final authResponse = await supabase.auth.signUp(
        password: password,
        email: email,
        data: {'username': name},
      );

      // Verificar si el usuario existe, pero no tiene identidades (usuario "falso")
      if (authResponse.user != null &&
          authResponse.user!.identities != null &&
          authResponse.user!.identities!.isEmpty)
      {

        emit(RegisterError(S.of(context).errorEmpty, isEmailRed, isPasswordRed, isRepeatPasswordRed));
      }else{

        //si el usuario no existe procedemos a crear la cuenta

        final user = authResponse.user;
        if (user != null && user.userMetadata != null) {
          await SharedPrefs.saveUserPreferences(user, password);

          emit(RegisterSuccess());
        } else {
          emit(RegisterError(S.of(context).errorEmpty, isEmailRed, isPasswordRed, isRepeatPasswordRed));
        }

      }


    } on AuthException catch (error) {
      if (error.statusCode == "429") {
        emit(RegisterError(S.of(context).errorRegisterLimit, isEmailRed, isPasswordRed, isRepeatPasswordRed));
      } else if (error.statusCode == "422") {
        emit(RegisterError(S.of(context).errorRegisterPasswordMin, isEmailRed, true, true));
      } else if (error.statusCode == "400") {
        emit(RegisterError(S.of(context).errorEmailNotValid, true, isPasswordRed, isRepeatPasswordRed));
      }else {
        emit(RegisterError(S.of(context).errorRegister, isEmailRed, isPasswordRed, isRepeatPasswordRed));
      }
    } catch (error) {
      emit(RegisterError("$error", true, isPasswordRed, isRepeatPasswordRed));
    }
  }
}
