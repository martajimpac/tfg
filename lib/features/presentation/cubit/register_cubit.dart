import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/utils/Utils.dart';
import '../../data/repository/repositorio_autenticacion.dart';
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
  final SupabaseAuthRepository repositorio;

  RegisterCubit(this.repositorio) : super(RegisterInitial(true, true));


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

    final errorMessage = await repositorio.signUp(name, email, password, context);

    if(errorMessage == null){
      emit(RegisterSuccess());
    }else if(errorMessage == S.of(context).errorRegisterPasswordMin){
      emit(RegisterError(errorMessage, isEmailRed, true, true));
    }else if(errorMessage == S.of(context).errorEmailNotValid){
      emit(RegisterError(errorMessage, true, isPasswordRed, isRepeatPasswordRed));
    }else{
      emit(RegisterError(errorMessage, isEmailRed, isPasswordRed, isRepeatPasswordRed));
    }
  }
}
