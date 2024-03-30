import 'package:flutter_bloc/flutter_bloc.dart';

class CounterCubit extends Cubit<int> {
  CounterCubit() : super(0);

  void increment() {
    final updatedValue = state + 1;
    emit(updatedValue);
  }
}
