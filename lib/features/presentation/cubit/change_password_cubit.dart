import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

import '../../data/repository/auth_exceptions.dart';
import '../../data/repository/repositorio_autenticacion.dart';
import '../../../generated/l10n.dart';


abstract class ChangePasswordState extends Equatable {
  const ChangePasswordState();

  @override
  List<Object> get props => [];
}

class ChangePasswordInitial extends ChangePasswordState {
  final bool isEmailRed;
  final bool isPasswordRed;
  final String currentPassword;
  final String newPassword;
  final String repeatPassword;

  const ChangePasswordInitial(this.isEmailRed, this.isPasswordRed, {this.currentPassword = '', this.newPassword = '', this.repeatPassword = ''});

  @override
  List<Object> get props => [isEmailRed, isPasswordRed, currentPassword, newPassword, repeatPassword];
}

class ChangePasswordLoading extends ChangePasswordState {}

class ChangePasswordSuccess extends ChangePasswordState {}

class ChangePasswordError extends ChangePasswordState {
  final String message;
  final bool isCurrentPasswordRed;
  final bool isNewPasswordRed;
  final bool isConfirmPasswordRed;
  final String currentPassword;
  final String newPassword;
  final String repeatPassword;

  const ChangePasswordError(this.message, this.isCurrentPasswordRed, this.isNewPasswordRed, this.isConfirmPasswordRed, this.currentPassword, this.repeatPassword, this.newPassword);

  @override
  List<Object> get props => [message, isCurrentPasswordRed, isNewPasswordRed, isConfirmPasswordRed, currentPassword, newPassword, repeatPassword];
}

class SendPasswordResetEmailError extends ChangePasswordState {
  final String message;
  final bool isEmailRed;

  const SendPasswordResetEmailError(this.message, this.isEmailRed);

  @override
  List<Object> get props => [message, isEmailRed];
}

class SendPasswordResetEmailSuccess extends ChangePasswordState {}

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  final SupabaseAuthRepository repositorio;

  ChangePasswordCubit(this.repositorio) : super(ChangePasswordInitial(true, true));

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
      emit(ChangePasswordError(message, isCurrentPasswordRed, isNewPasswordRed, isConfirmPasswordRed, currentPassword, newPassword, confirmPassword));
      return;
    }

    if (newPassword != confirmPassword) {
      isCurrentPasswordRed = false;
      isNewPasswordRed = true;
      isConfirmPasswordRed = true;
      var message = S.of(context).errorChangePasswordNoMatch;
      emit(ChangePasswordError(message, isCurrentPasswordRed, isNewPasswordRed, isConfirmPasswordRed, currentPassword, newPassword, confirmPassword));
      return;
    }
    if (newPassword.length < 6) {
      isCurrentPasswordRed = false;
      isNewPasswordRed = true;
      isConfirmPasswordRed = true;
      var message = S.of(context).errorChangePasswordLength;
      emit(ChangePasswordError(message, isCurrentPasswordRed, isNewPasswordRed, isConfirmPasswordRed, currentPassword, newPassword, confirmPassword));
      return;
    }

    try{
      await repositorio.changePassword(currentPassword, newPassword);
      emit(ChangePasswordSuccess());
    } on ChangePasswordIncorrectException{
      emit(ChangePasswordError(S.of(context).errorChangePasswordIncorrect, true, false, false, currentPassword, newPassword, confirmPassword));
    } on ChangePasswordNoChangedException{
      emit(ChangePasswordError(S.of(context).errorChangePasswordNoChange, false, false, false, currentPassword, newPassword, confirmPassword));
    } catch(e){
      emit(ChangePasswordError(S.of(context).errorChangePassword, false, false, false, currentPassword, newPassword, confirmPassword));
    }
  }


  Future<void> resetPassword(String newPassword, String confirmPassword, BuildContext context) async {

    bool isNewPasswordRed = newPassword.isEmpty;
    bool isConfirmPasswordRed = confirmPassword.isEmpty;


    emit(ChangePasswordLoading());
    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      var message = S.of(context).errorEmpty;
      emit(ChangePasswordError(message, false, isNewPasswordRed, isConfirmPasswordRed, "", newPassword, confirmPassword));
      return;
    }

    if (newPassword != confirmPassword) {
      isNewPasswordRed = true;
      isConfirmPasswordRed = true;
      var message = S.of(context).errorChangePasswordNoMatch;
      emit(ChangePasswordError(message, false, isNewPasswordRed, isConfirmPasswordRed, "", newPassword, confirmPassword));
      return;
    }
    if (newPassword.length < 6) {
      isNewPasswordRed = true;
      isConfirmPasswordRed = true;

      var message = S.of(context).errorChangePasswordLength;
      emit(ChangePasswordError(message, false, isNewPasswordRed, isConfirmPasswordRed, "", newPassword, confirmPassword));
      return;
    }

    try{
      await repositorio.resetPassword(newPassword);
      emit(ChangePasswordSuccess());
    }catch(e){
      emit(ChangePasswordError(S.of(context).errorChangePassword, false, false, false, "", newPassword, confirmPassword));
      return;
    }
  }

  Future<void> sendResetPasswordEmail(String email, BuildContext context) async {

    emit(ChangePasswordLoading());
    if (email.isEmpty) {
      emit(SendPasswordResetEmailError(S.of(context).errorEmpty, true));
      return;
    }

    try{
      await repositorio.sendResetPasswordEmail(email);
      emit(SendPasswordResetEmailSuccess());
    } on RateLimitExceededException catch(e){
      emit(SendPasswordResetEmailError(S.of(context).errorRecoverPasswordLimit, false));
    } on InvalidEmailFormatException catch(e){
      emit(SendPasswordResetEmailError(S.of(context).errorRecoverPasswordEmail, false));
    } catch(e){
      emit(SendPasswordResetEmailError(S.of(context).errorRecoverPassword, false));
    }
  }
}
