import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modernlogintute/main.dart';

class ResponseCubit extends Cubit<List<Map<String, dynamic>>> {
  ResponseCubit() : super([]);

  Future<void> fetchResponses() async {

    final response = await supabase.from('maq_categroia').stream(primaryKey: ['idopcion']);

    // Escucha el stream de la respuesta
    response.listen((data) {
      // Emite los datos recibidos
      emit(data as List<Map<String, dynamic>>);
    }, onError: (error) {
      // Maneja cualquier error que ocurra en el stream
      debugPrint('Error en el stream de respuesta: $error');
    });
  }
}

/*class ResponseCubit extends Cubit<List<Map<String, dynamic>>> {
  ResponseCubit() : super([]);

  Future<void> fetchResponses() async {
    final response = supabase
        .from('maq_opcion_respuesta')
        .stream(primaryKey: ['maq_opcion_respuesta_pkey']); //idopcion
    emit(response as List<Map<String, dynamic>>);
  }
}*/

abstract class ResponseState{
}

class InitResponseState extends ResponseState{}

class LoadingResponses extends ResponseState{}

class ErrorResponses extends ResponseState{}

class ResponsesRetrieved extends ResponseState{}
