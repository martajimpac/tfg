import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modernlogintute/cubit/categories_cubit.dart';
import 'package:modernlogintute/cubit/response_cubit.dart';
import 'package:modernlogintute/cubit/settings_cubit.dart';
import 'package:modernlogintute/cubit/settings_state.dart';
import 'package:modernlogintute/views/login_page.dart';
import 'package:modernlogintute/views/my_home_page.dart';
import 'cubit/page_cubit.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://mhxryaquargzfumndwgq.supabase.co',
    anonKey:
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1oeHJ5YXF1YXJnemZ1bW5kd2dxIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTk2NTc0NjgsImV4cCI6MjAxNTIzMzQ2OH0.zuNF8ECVgZPasigxX0cxT1bph-NueCGaJA9kDTPmdZ8',
  );

  runApp(const MyApp());
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ResponseCubit()),
        BlocProvider(create: (context) => CategoriesCubit()),
        BlocProvider(create: (context) => SettingsCubit()),
      ],
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: ((context, state){
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: state.theme,
            home: LoginPage(),
          );
        }),
      )
    );
  }
}
