import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modernlogintute/cubit/counter_cubir.dart';
import 'views/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CounterCubit(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: LoginPage(),
        theme:
        ThemeData(
            primarySwatch: Colors.yellow,
          appBarTheme: const AppBarTheme(
            elevation: 0,
            color: Colors.blue, // Color de fondo de la AppBar
            iconTheme: IconThemeData(
              color: Colors.white, // Color de los iconos en la AppBar
            ),
          ),

        ),
      ),
    );
  }
}
