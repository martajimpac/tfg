import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

import '../../data/repository/repositorio_autenticacion.dart';
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

  @override
  List<Object> get props => [isEmailRed, isPasswordRed];
}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {}

class LoginError extends LoginState {
  final String message;
  final bool isEmailRed;
  final bool isPasswordRed;


  const LoginError(this.message, this.isEmailRed, this.isPasswordRed);

  @override
  List<Object> get props => [message, isEmailRed, isPasswordRed];
}

class ConfirmationEmailSent extends LoginState {}

class LoginCubit extends Cubit<LoginState> {
  final SupabaseAuthRepository repositorio;

  LoginCubit(this.repositorio) : super(LoginInitial(false, false));

  Future<void> login(String email, String password, BuildContext context) async {
    final errorEmptyMessage = S.of(context).errorEmpty;
    final errorAuthMessage = S.of(context).errorAuthenticationCredentials;

    var isEmailRed = false;
    var isPasswordRed = false;

    emit(LoginLoading());

    if (email.isEmpty || password.isEmpty) {
      isEmailRed = email.isEmpty;
      isPasswordRed = password.isEmpty;

      // Verificar si el estado actual ya es el mismo error
      if (state is LoginError &&
          (state as LoginError).message == errorEmptyMessage &&
          (state as LoginError).isEmailRed == isEmailRed &&
          (state as LoginError).isPasswordRed == isPasswordRed) {
        return;
      }
      debugPrint("marta error 1");
      emit(LoginError(errorEmptyMessage, isEmailRed, isPasswordRed));
      return;
    }

    final errorMessage = await repositorio.signInWithEmailAndPassword(email, password, context);

    if (errorMessage == null) {
      emit(LoginSuccess());
      return;
    } else if (errorMessage == errorAuthMessage) {
      // Verificar si el estado actual ya es el mismo error
      if (state is LoginError &&
          (state as LoginError).message == errorAuthMessage &&
          (state as LoginError).isEmailRed == true &&
          (state as LoginError).isPasswordRed == true) {
        return;
      }
      emit(LoginError(errorMessage, true, true));
      return;
    } else {
      // Verificar si el estado actual ya es el mismo error
      if (state is LoginError &&
          (state as LoginError).message == errorMessage &&
          (state as LoginError).isEmailRed == false &&
          (state as LoginError).isPasswordRed == false) {
        return;
      }
      emit(LoginError(errorMessage, false, false));
      return;
    }
  }


  Future<void> resendConfirmationEmail(String email, String password, BuildContext context) async {
    final errorMesage = await repositorio.resendConfirmationEmail(email, password, context);
    if(errorMesage == null){
      emit(ConfirmationEmailSent());
    }else{
      emit(LoginError(errorMesage, false, false));
      return;
    }
  }
}
