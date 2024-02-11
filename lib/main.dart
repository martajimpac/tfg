import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modernlogintute/cubit/counter_cubit.dart';
import 'package:modernlogintute/cubit/settings_cubit.dart';
import 'package:modernlogintute/cubit/settings_state.dart';
import 'package:modernlogintute/theme/app_theme.dart';
import 'package:modernlogintute/views/my_home_page.dart';
import 'cubit/page_cubit.dart';
import 'views/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => PageCubit()),
        BlocProvider(create: (context) => SettingsCubit()),
      ],
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: ((context, state){
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: state.theme,
            home: const MyHomePage(),
          );
        }),
      )
    );
  }
}
