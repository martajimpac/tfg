part of 'repositorio_autenticacion.dart';

///Clase encargada de geestionar todo lo relativo a al autenticación mediante Supabase

class SupabaseAuthRepository implements RepositorioAutenticacion {
  final Supabase supabase;
  SupabaseAuthRepository(this.supabase);

  final Logger log = Logger();


  @override
  Future<String> signInEmailAndPassword(String email, String password, BuildContext context) async {
    return "";
    /*try {
      final authResponse = await supabase.client.auth.signInWithPassword(password: password, email: email);

      final user = authResponse.user;
      if (user != null && user.userMetadata != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('email', user.email.toString());
        prefs.setString('id', user.id.toString());
        prefs.setString('name',  user.userMetadata!['username'].toString());
        return "";
      } else {
        return  S.of(context).errorAuthentication;
        Utils.showMyOkDialog(context, S.of(context).error, S.of(context).errorAuthentication, () {
          Navigator.of(context).pop();
        });
      }
    } on AuthException catch (error) {
      // Manejar errores de autenticación
      if (error.statusCode == "400") {
        if (error.message == "Invalid login credentials") {
          // Credenciales de inicio de sesión inválidas
          return S.of(context).errorAuthenticationCredentials;
          Utils.showMyOkDialog(context, S.of(context).error, S.of(context).errorAuthenticationCredentials, () {
            Navigator.of(context).pop();
          });
        } else if (error.message == "Email not confirmed") {
          // Correo electrónico no confirmado
          return S.of(context).errorAuthenticationNotConfirmed;
          Utils.showMyOkDialog(context, S.of(context).error, S.of(context).errorAuthenticationNotConfirmed, () {
            Navigator.of(context).pop();
          });
        } else {
          // Otro error de autenticación
          return  S.of(context).errorAuthentication;
          Utils.showMyOkDialog(context, S.of(context).error, S.of(context).errorAuthentication, () {
            Navigator.of(context).pop();
          });
        }
      } else {
        // Otro error de autenticación
        return  S.of(context).errorAuthentication;
        Utils.showMyOkDialog(context, S.of(context).error, S.of(context).errorAuthentication, () {
          Navigator.of(context).pop();
        });
      }
    } catch (error) {
      // Otro error de autenticación
      return  S.of(context).errorAuthentication;
      Utils.showMyOkDialog(context, S.of(context).error, "error 4", () {
        Navigator.of(context).pop();
      });
    }*/
  }

}
