import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../../generated/l10n.dart';
import '../../data/repository/repositorio_autenticacion.dart';
import '../../data/shared_prefs.dart';

// Define el estado del cubit
abstract class EditProfileState extends Equatable {
  const EditProfileState();

  @override
  List<Object> get props => [];
}

class EditProfileLoading extends EditProfileState {}

class EditProfileLoaded extends EditProfileState {
  final String userName;
  const EditProfileLoaded(this.userName);

  @override
  List<Object> get props => [userName];
}

class EditProfileSuccess extends EditProfileState {
  final String newUserName;
  const EditProfileSuccess(this.newUserName);

  @override
  List<Object> get props => [newUserName];
}

class EditProfileError extends EditProfileState {
  final String errorMessage;
  final bool isNameRed;

  const EditProfileError(this.errorMessage, this.isNameRed);

  @override
  List<Object> get props => [errorMessage, isNameRed];
}



class EditProfileCubit extends Cubit<EditProfileState> {
  final RepositorioAutenticacion repositorio;

  EditProfileCubit(this.repositorio) : super(EditProfileLoading());

  Future<void> editProfile(String newUserName, BuildContext context) async {
    emit(EditProfileLoading());

    if (newUserName.isEmpty) {
      var message = S.of(context).errorEmpty;
      emit(EditProfileError(message, true));
      return;
    }

    final errorMessage = await repositorio.editProfile(newUserName, context);
    if(errorMessage == null){
      emit(EditProfileSuccess(newUserName));
    }else{
      emit(EditProfileError(errorMessage, false));
    }
  }

  Future<void> loadUserData() async {
    emit(EditProfileLoading());
    try {
      final userData = await SharedPrefs.getUserData();
      final name = userData['name'] ?? '';
      emit(EditProfileLoaded(name));
    } catch (e) {
      // Maneja errores si es necesario
      debugPrint('Error al cargar datos del usuario: $e');
    }
  }

 
}
