import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/utils/Utils.dart';
import '../../data/shared_prefs.dart';
import '../../../generated/l10n.dart';


abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {
  final bool isEmailRed;
  final bool isPasswordRed;

  const LoginInitial(this.isEmailRed, this.isPasswordRed);
}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {}

class LoginError extends LoginState {
  final String message;
  final bool isEmailRed;
  final bool isPasswordRed;

  const LoginError(this.message, this.isEmailRed, this.isPasswordRed);
}

class ConfirmationEmailSent extends LoginState {}

class LoginCubit extends Cubit<LoginState> {
  final SupabaseClient supabase;

  LoginCubit(this.supabase) : super(LoginInitial(true, true));

  Future<void> login(String email, String password, BuildContext context) async {
    var isEmailRed = false;
    var isPasswordRed = false;

    emit(LoginLoading());

    if (email.isEmpty || password.isEmpty) {
      isEmailRed = email.isEmpty;
      isPasswordRed = password.isEmpty;

      emit(LoginError(S.of(context).errorEmpty, isEmailRed, isPasswordRed));
      return;
    }


    try {
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final user = response.user;

      if (user != null) {
        await SharedPrefs.saveUserPreferences(user, password);
        emit(LoginSuccess());
      } else {
        var message = S.of(context).errorAuthentication;
        emit(LoginError(message, false, false));
      }
    } on AuthException catch (error) {
      var message = "";
      switch (error.message) {
        case "Invalid login credentials":
          message = S.of(context).errorAuthenticationCredentials;
          emit(LoginError(message, true, true));
          break;
        case "Email not confirmed":
          message = S.of(context).errorAuthenticationNotConfirmed;
          emit(LoginError(message, false, false));
          break;
        default:
          message = S.of(context).errorAuthentication;
          emit(LoginError(message, false, false));
          break;
      }


    } catch (error) {
      var message = S.of(context).unknownError;
      emit(LoginError(message, false, false));
    }
  }

  Future<void> autologin(BuildContext context) async {
    // Obtener los datos del usuario
    Map<String, String> userData = await SharedPrefs.getUserData(); //TODO AQUI LO SUYO ES HACERLO CON EL ID

    // Obtener el email y la contraseña del mapa de datos
    String email = userData['email'] ?? '';
    String password = userData['password'] ?? '';

    if (email.isNotEmpty && password.isNotEmpty) {
      login(email, password, context);
    } else {
      emit(LoginError("", false, false));
    }
  }

  Future<void> resendConfirmationEmail(String email, String password, BuildContext context) async {
    try {
      final authResponse = await supabase.auth.signUp(password: password, email: email);
      if (authResponse.user != null) {
        emit(ConfirmationEmailSent());
      }
    } catch (error) {
      var message = S.of(context).errorEmailResent;
      emit(LoginError(message, false, false));
    }
  }
}
