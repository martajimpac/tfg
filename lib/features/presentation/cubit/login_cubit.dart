import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

import '../../data/repository/auth_exceptions.dart';
import '../../data/repository/repositorio_autenticacion.dart';
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

  Future<void> login(
      String email, String password, BuildContext context) async {
    final errorEmptyMessage = S.of(context).errorEmpty;
    final errorAuthMessage = S.of(context).errorAuthenticationCredentials;

    var isEmailRed = false;
    var isPasswordRed = false;

    emit(LoginLoading());

    if (email.isEmpty || password.isEmpty) {
      isEmailRed = email.isEmpty;
      isPasswordRed = password.isEmpty;

      emit(LoginError(errorEmptyMessage, isEmailRed, isPasswordRed));
      return;
    }

    try {
      await repositorio.signInWithEmailAndPassword(email, password);
      emit(LoginSuccess());
      return;
    } on InvalidCredentialsException {

      emit(LoginError(S.of(context).errorAuthenticationCredentials, true, true));
      return;

    } on EmailNotConfirmedException {
      emit(LoginError(S.of(context).errorAuthenticationNotConfirmed, true, false));
      return;

    } on AuthenticationRepositoryException catch (e) {
      emit(LoginError(S.of(context).errorAuthentication,  false, false));
      return;

    } catch (e) {
      emit(LoginError(S.of(context).unknownError, false, false));
      return;
    }
  }

  Future<void> resendConfirmationEmail(String email, String password, BuildContext context) async {
    try {
      await repositorio.resendConfirmationEmail(email, password);
      emit(ConfirmationEmailSent());
    } catch (e) {
      emit(LoginError(S.of(context).errorEmailResent, false, false));
      return;
    }
  }
}
