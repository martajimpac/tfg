import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../../core/utils/pdf.dart';
import '../../../generated/l10n.dart';
import '../../data/models/evaluacion_details_dm.dart';
import '../../data/models/imagen_dm.dart';
import '../../data/repository/repositorio_autenticacion.dart';
import '../../data/repository/repositorio_db_supabase.dart';

// Define el estado del cubit
abstract class EditProfileState extends Equatable {
  const EditProfileState();

  @override
  List<Object> get props => [];
}

class EditProfileLoading extends EditProfileState {}

class EditProfileSuccess extends EditProfileState {
  const EditProfileSuccess();
}

class EditProfileError extends EditProfileState {
  final String errorMessage;
  final bool isNameRed;

  const EditProfileError(this.errorMessage, this.isNameRed);

  @override
  List<Object> get props => [errorMessage];
}



class EditProfileCubit extends Cubit<EditProfileState> {
  final RepositorioAutenticacion repositorio;

  EditProfileCubit(this.repositorio) : super(EditProfileLoading());

  Future<void> editProfile(String nombre, BuildContext context) async {
    emit(EditProfileLoading());

    if (nombre.isEmpty) {
      var message = S.of(context).errorEmpty;
      emit(EditProfileError(message, true));
      return;
    }

    final errorMessage = await repositorio.editProfile(nombre, context);
    if(errorMessage == null){
      emit(EditProfileSuccess());
    }else{
      emit(EditProfileError(errorMessage, false));
    }
  }

 
}
