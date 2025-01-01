part of 'repositorio_autenticacion.dart';

///Clase encargada de geestionar todo lo relativo a al autenticación mediante Supabase

class SupabaseAuthRepository implements RepositorioAutenticacion {

  final Supabase supabase;
  SupabaseAuthRepository(this.supabase);

  final Logger log = Logger();


  //Funcion que inicia sesión y te devuelve el código de error
  @override
  Future<String?> signInEmailAndPassword(String email, String password, BuildContext context) async {
    try {
      final response = await supabase.client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final user = response.user;

      if (user != null) {
        await SharedPrefs.saveUserPreferences(user, password);
        return null;
      } else {
        var message = S.of(context).errorAuthentication;
        return message;
      }
    } on AuthException catch (error) {
      var message = "";
      switch (error.message) {
        case "Invalid login credentials":
          message = S.of(context).errorAuthenticationCredentials;
          return message;
          break;
        case "Email not confirmed":
          message = S.of(context).errorAuthenticationNotConfirmed;
          return message;
          break;
        default:
          message = S.of(context).errorAuthentication;
          return message;
          break;
      }
    } catch (error) {
      var message = S.of(context).unknownError;
      return message;
    }
  }

}