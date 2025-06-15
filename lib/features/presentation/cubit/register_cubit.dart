import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

import '../../data/repository/auth_exceptions.dart';
import '../../data/repository/repositorio_autenticacion.dart';
import '../../../generated/l10n.dart';

abstract class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object> get props => [];
}

class RegisterInitial extends RegisterState {
  final bool isEmailRed;
  final bool isPasswordRed;
  final String name;
  final String email;
  final String password;
  final String repeatPassword;

  const RegisterInitial(this.isEmailRed, this.isPasswordRed, {this.name = '', this.email = '', this.password = '', this.repeatPassword = ''});

  @override
  List<Object> get props => [isEmailRed, isPasswordRed, name, email, password, repeatPassword];
}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {}

class RegisterError extends RegisterState {
  final String message;
  final bool isEmailRed;
  final bool isPasswordRed;
  final bool isRepeatPasswordRed;
  final String name;
  final String email;
  final String password;
  final String repeatPassword;

  const RegisterError(this.message, this.isEmailRed, this.isPasswordRed, this.isRepeatPasswordRed, {this.name = '', this.email = '', this.password = '', this.repeatPassword = ''});

  @override
  List<Object> get props => [message, isEmailRed, isPasswordRed, name, email, password, repeatPassword];
}

class RegisterCubit extends Cubit<RegisterState> {
  final SupabaseAuthRepository repositorio;

  RegisterCubit(this.repositorio) : super(RegisterInitial(true, true));

  Future<void> register(String name, String email, String password, String repeatPassword, BuildContext context) async {
    var isEmailRed = false;
    var isPasswordRed = false;
    var isRepeatPasswordRed = false;

    emit(RegisterLoading());

    if (email.isEmpty || password.isEmpty || repeatPassword.isEmpty || name.isEmpty) {
      isEmailRed = email.isEmpty;
      isPasswordRed = password.isEmpty;
      isRepeatPasswordRed = repeatPassword.isEmpty;

      emit(RegisterError(S.of(context).errorEmpty, isEmailRed, isPasswordRed, isRepeatPasswordRed, name: name, email: email, password: password, repeatPassword: repeatPassword));
      return;
    } else if (password != repeatPassword) {
      isRepeatPasswordRed = true;
      isPasswordRed = true;
      isEmailRed = false;

      emit(RegisterError(S.of(context).errorPasswordsDontMatch, isEmailRed, isPasswordRed, isRepeatPasswordRed, name: name, email: email, password: password, repeatPassword: repeatPassword));
      return;
    }

    isEmailRed = false;
    isPasswordRed = false;
    isRepeatPasswordRed = false;

    try{
      await repositorio.signUp(name, email, password);
      emit(RegisterSuccess());
    } on InvalidEmailFormatException{
      emit(RegisterError(
        S.of(context).errorEmailNotValid,
        true,
        isPasswordRed,
        isRepeatPasswordRed,
        name: name,
      ));
    }on PasswordTooShortException{
      emit(RegisterError(
        S.of(context).errorRegisterPasswordMin,
        isEmailRed,
        true,
        isRepeatPasswordRed,
        name: name,
      ));
    }on EmailAlreadyRegisteredException{
      emit(RegisterError(
          S.of(context).emailAlredyRegistered,
          true,
          isPasswordRed,
          isRepeatPasswordRed,
          name: name,
        )
      );
    } on RateLimitExceededException {
      emit(
          RegisterError(
              S.of(context).errorRegisterLimit,
              isEmailRed,
              isPasswordRed,
              isRepeatPasswordRed, name: name,
              email: email,
              password: password,
              repeatPassword: repeatPassword
          ));
      return;
    } catch (e) {
      emit(
          RegisterError(
              S.of(context).unknownError,
              false,
              false,
              false,
              name: name,
              email: email,
              password: password,
              repeatPassword: repeatPassword
          ));
      return;
    }
  }
}
