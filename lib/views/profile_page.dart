import 'package:evaluacionmaquinas/components/my_button.dart';
import 'package:evaluacionmaquinas/views/forgot_password_page.dart';
import 'package:evaluacionmaquinas/views/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; // Necesitas importar Cupertino para usar CupertinoSwitch
import 'package:flutter_bloc/flutter_bloc.dart'; // Necesitas importar flutter_bloc para usar BlocBuilder
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../components/my_button_card.dart';
import '../cubit/settings_cubit.dart';
import '../theme/app_theme.dart'; // Asumiendo que tienes un archivo settings_cubit.dart

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    return PopScope(
        canPop: false,
        onPopInvoked: (bool didPop){

      }, child:
      Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: FutureBuilder<String>(
          future: _getUserName(), // Obtener el nombre del usuario de SharedPreferences
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(); // Muestra un indicador de progreso mientras se carga el nombre
            } else {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}'); // Manejar errores si los hay
              } else {
                final userName = snapshot.data ?? 'Nombre desconocido'; // Obtener el nombre del usuario del snapshot
                return Column(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: [
                        Container(
                          height: h / 3,
                          color: Theme.of(context).colorScheme.primaryContainer,
                        ),
                        Positioned(
                          bottom: -40,
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: Theme.of(context).colorScheme.background,
                            backgroundImage: const AssetImage('lib/images/default_user.png'),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 50),
                    Column(
                      children: [
                        Text(userName), // Mostrar el nombre del usuario aquí
                      ],
                    ),
                    BlocBuilder<SettingsCubit, SettingsState>(
                      builder: (context, state) {
                        return ListTile(
                          title: Text('Modo oscuro', style: Theme.of(context).textTheme.bodyMedium),
                          trailing: CupertinoSwitch(
                            activeColor: Colors.grey.shade400,
                            value: state.theme == MyAppTheme.darkTheme, // Corrección aquí
                            onChanged: (value) {
                              context.read<SettingsCubit>().toggleTheme();
                              // switchChanged(value); // No está definido switchChanged, ¿es necesario aquí?
                            },
                          ),
                        );
                      },
                    ),
                    MyButton(adaptableWidth: true, onTap:() async {
                      try {
                        await Supabase.instance.client.auth.signOut();
                        Fluttertoast.showToast(
                          msg: 'Sesión cerrada exitosamente.',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          backgroundColor: Colors.grey,
                          textColor: Colors.white,
                        );
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()),);
                      } catch (error) {
                        Fluttertoast.showToast(
                          msg:  "Ocurrió un error al cerrar la sesión.",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          backgroundColor: Colors.grey,
                          textColor: Colors.white,
                        );
                      }
                    }, text: "Cerrar sesión"),
                    MyButtonCard(
                        onTap:() async {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const ForgotPasswordPage()),);
                        },
                        text: "Cambiar constraseña",
                        icon: Icon(Icons.lock, color: Colors.white)
                    ),
                  ]
                );
              }
            }
          },
        ),
      ),
    );
  }

  Future<String> _getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('name') ?? ''; // Obtener el nombre del usuario guardado, o un valor predeterminado si no existe
  }
}
