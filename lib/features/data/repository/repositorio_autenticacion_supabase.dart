part of 'repositorio_autenticacion.dart';

///Clase encargada de geestionar toodo lo relativo a al autenticación mediante Supabase

class SupabaseAuthRepository implements RepositorioAutenticacion {

  final Supabase supabase;
  SupabaseAuthRepository(this.supabase);


  //Funcion que inicia sesión y te devuelve el código de error
  @override
  Future<String?> signInWithEmailAndPassword(String email, String password, BuildContext context) async {
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

  @override
  Future<String?> resendConfirmationEmail(String email, String password, BuildContext context) async {
    try {
      final authResponse = await supabase.client.auth.signUp(
          password: password,
          email: email,
          emailRedirectTo: emailConfirmationPage,
      );
      if (authResponse.user != null) {
        return null;
      }else{
        return S.of(context).errorEmailResent;
      }
    } catch (error) {
      return S.of(context).errorEmailResent;
    }
  }

  @override
  Future<String?> signUp(String name, String email, String password, BuildContext context) async {
    try {
      // Proceder con el registro
      final authResponse = await supabase.client.auth.signUp(
        password: password,
        email: email,
        data: {'username': name},
        emailRedirectTo: emailConfirmationPage,
      );

      // Verificar si el usuario existe, pero no tiene identidades (usuario "falso")
      if (authResponse.user != null &&
          authResponse.user!.identities != null &&
          authResponse.user!.identities!.isEmpty) //todo con marta@yopmail.com problema ...
      {

        return "YA REGISTRADO ${authResponse.user == null} IDENTITIS ${authResponse.user?.identities}"; //S.of(context).errorRegister
      }else{
        //si el usuario no existe procedemos a crear la cuenta

        final user = authResponse.user;
        if (user != null && user.userMetadata != null) {
          return null;
        } else {
          return "error raro"; //S.of(context).errorRegister TODO REVISA ESTO
        }
      }


    } on AuthException catch (error) {
      if (error.statusCode == "429") {
        return S.of(context).errorRegisterLimit;
      } else if (error.statusCode == "422") {
        return S.of(context).errorRegisterPasswordMin;
      } else if (error.statusCode == "400") {
        return S.of(context).errorEmailNotValid;
      }else {
        return S.of(context).errorRegister;
      }
    } catch (error) {
      return "Excepcion"; //S.of(context).errorRegister
    }
  }

  @override
  Future<String?> changePassword(String currentPassword, String newPassword, BuildContext context) async {
    try {
      // Autenticar al usuario con la contraseña actual
      await supabase.client.auth.signInWithPassword(
        email: supabase.client.auth.currentUser!.email!,
        password: currentPassword,
      );

    } catch (error) {
      return S.of(context).errorChangePasswordIncorrect;
    }

    try {
      // Si la autenticación es exitosa, cambiar la contraseña
      await supabase.client.auth.updateUser(
        UserAttributes(password: newPassword),
      );

      return null;

    } on AuthException {
      return S.of(context).errorChangePasswordNoChange;
    } catch (error) {
      return S.of(context).errorChangePassword;
    }
  }

  @override
  Future<String?> resetPassword(String newPassword, BuildContext context) async {
    try {
      // Usamos el método resetPassword de Supabase para resetear la contraseña usando el token
      final userRes = await Supabase.instance.client.auth.updateUser(
        UserAttributes(
          password: newPassword,
        ),
      );

      if(userRes.user != null){
        return null;
      }else{
        return S.of(context).errorChangePassword;
      }
    } catch (error) {
      return  S.of(context).errorChangePassword;
    }
  }

  @override
  Future<String?> editProfile(String newName, BuildContext context) async {
    try {
      // Usamos el método resetPassword de Supabase para resetear la contraseña usando el token
      await Supabase.instance.client.auth.updateUser(
        UserAttributes(
          data: {'username': newName},
        ),
      );

      return null;
    } catch (error) {
      return  S.of(context).errorChangeUserData;
    }
  }

  @override
  @override
  Future<String?> sendResetPasswordEmail(String email, BuildContext context) async {
    try {
      await supabase.client.auth.resetPasswordForEmail(email);
      return null;

    } on AuthException catch (error) {
      // Manejar errores de autenticación
      if (error.statusCode == "429") {
        return S.of(context).errorRecoverPasswordLimit;

      } else { //Email rate limit exceeded
        return S.of(context).errorRecoverPasswordEmail;
      }
    } catch (error) {
      return S.of(context).errorRecoverPassword;
    }
  }
}