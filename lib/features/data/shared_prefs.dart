

import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SharedPrefs{
  static Future<void> saveUserPreferences(User user, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', user.email ?? "");
    await prefs.setString('password', password);
    await prefs.setString('id', user.id ?? "");
    await prefs.setString('name', user.userMetadata?['username'] ?? "");
  }

  static Future<void> deleteUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('email');
    await prefs.remove('password');
    await prefs.remove('id');
    await prefs.remove('name');
  }

  static Future<String> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('name') ?? '';
  }

  static Future<String> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('id') ?? '';
  }

  static Future<Map<String, String>> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Obtener los datos del usuario guardados
    String email = prefs.getString('email') ?? '';
    String password = prefs.getString('password') ?? '';
    String id = prefs.getString('id') ?? '';
    String name = prefs.getString('name') ?? '';

    // Devolver los datos en un mapa
    return {
      'email': email,
      'password': password,
      'id': id,
      'name': name
    };
  }

}