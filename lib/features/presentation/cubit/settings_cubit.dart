import 'package:equatable/equatable.dart'; // Importar Equatable
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

// Heredar de Equatable
class SettingsState extends Equatable {
  final ThemeData theme;

  const SettingsState({
    required this.theme
  });

  // Definir propiedades para comparación
  @override
  List<Object> get props => [theme]; // Comparar por el tema
}

class SettingsCubit extends Cubit<SettingsState>{
  SettingsCubit(): super(SettingsState(theme: MyAppTheme.lightTheme));

  bool get isDarkMode => state.theme == MyAppTheme.darkTheme;

  void toggleTheme(){
    final newTheme = isDarkMode ? MyAppTheme.lightTheme : MyAppTheme.darkTheme;

    // Solo emitir si el tema cambió realmente
    if (newTheme != state.theme) {
      emit(SettingsState(theme: newTheme));
    }
  }
}