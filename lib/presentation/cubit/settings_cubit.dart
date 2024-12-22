import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

class SettingsState{
  final ThemeData theme;
  SettingsState({
    required this.theme
  });
}
class SettingsCubit extends Cubit<SettingsState>{
  SettingsCubit(): super(SettingsState(theme: MyAppTheme.lightTheme));

  bool isDarkMode() => state.theme == MyAppTheme.lightTheme ? false : true;

  void toggleTheme(){
    if(state.theme == MyAppTheme.lightTheme){
      final updatedState = SettingsState(theme: MyAppTheme.darkTheme);
      emit(updatedState);
    }else{
      final updatedState = SettingsState(theme: MyAppTheme.lightTheme);
      emit(updatedState);
    }
  }
}
