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
  final SupabaseAuthRepository repositorio;

  LoginCubit(this.repositorio) : super(LoginInitial(true, true));

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


    final errorMessage = await repositorio.signInWithEmailAndPassword(email, password, context);

    if(errorMessage == null){
      emit(LoginSuccess());
    }else if(errorMessage == S.of(context).errorAuthenticationCredentials){
      emit(LoginError(errorMessage, true, true));
    }else{
      emit(LoginError(errorMessage, false, false));
    }
  }

  Future<void> autologin(BuildContext context) async {
    // Obtener los datos del usuario
    Map<String, String> userData = await SharedPrefs.getUserData();

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
    final errorMesage = await repositorio.resendConfirmationEmail(email, password, context);
    if(errorMesage == null){
      emit(ConfirmationEmailSent());
    }else{
      emit(LoginError(errorMesage, false, false));
    }
  }
}
