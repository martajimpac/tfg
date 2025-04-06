import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/repository/repositorio_autenticacion.dart';
import '../../data/shared_prefs.dart';
import '../../../generated/l10n.dart';

abstract class AutoLoginState {}
class AutoLoginInitial extends AutoLoginState {}
class AutoLoginLoading extends AutoLoginState {}
class AutoLoginSuccess extends AutoLoginState {}
class AutoLoginError extends AutoLoginState {}


class AutoLoginCubit extends Cubit<AutoLoginState> {

  final SupabaseAuthRepository repositorio;

  AutoLoginCubit(this.repositorio) : super(AutoLoginInitial());

  Future<void> autologin() async {
    emit(AutoLoginLoading());

    final userData = await SharedPrefs.getUserData();
    final email = userData['email'] ?? '';
    final password = userData['password'] ?? '';

    if (email.isEmpty || password.isEmpty) {
      emit(AutoLoginError());
      return;
    }

    final errorMessage = await repositorio.signInWithEmailAndPassword(email, password, null);

    if(errorMessage == null){
      emit(AutoLoginSuccess());
    }else{
      emit(AutoLoginError());
    }
  }
}
