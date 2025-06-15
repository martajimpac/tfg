part of 'repositorio_autenticacion.dart';

///Clase encargada de geestionar toodo lo relativo a al autenticación mediante Supabase

class SupabaseAuthRepository implements RepositorioAutenticacion {

  final Supabase supabase;
  SupabaseAuthRepository(this.supabase);



  //Funcion que inicia sesión y te devuelve el código de error
  @override
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      final response = await supabase.client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final user = response.user;

      if (user != null) {
        await SharedPrefs.saveUserPreferences(user, password);
        // Éxito, no se devuelve nada o Future.value()
      } else {
        // Este caso es inusual si signInWithPassword no lanza AuthException
        // Podrías lanzar una excepción genérica aquí si es un estado inesperado.
        throw AuthenticationRepositoryException('');
      }
    } on AuthException catch (error) {
      throw AuthenticationRepositoryException(error.message);
    } catch (error) { // Errores genéricos de red, etc.
      throw AuthenticationRepositoryException('$error');
    }
  }


  @override
  Future<void> resendConfirmationEmail(String email, String password) async {
    try {
      final authResponse = await supabase.client.auth.signUp(
        password: password,
        email: email,
        emailRedirectTo: emailConfirmationPage,
      );
      if (authResponse.user == null) { // O si hay algún otro indicador de que no se reenvió
        throw AuthenticationRepositoryException('auth_resend_email_failed');
      }
      // Éxito
    } catch (error) {
      // Aquí podrías ser más específico si Supabase da errores distinguibles para reenvío
      throw AuthenticationRepositoryException('$error');
    }
  }


  @override
  Future<void> signUp(String name, String email, String password) async {
    try {
      final authResponse = await supabase.client.auth.signUp(
        password: password,
        email: email,
        data: {'username': name},
        emailRedirectTo: emailConfirmationPage,
      );

      //  Comprobamos si el correo ya estaba registrado
      final user = authResponse.user;
      final identities = user?.identities;

      if (user != null && identities != null && identities.isEmpty) {
        // El email ya está registrado -> Lanzamos solo esta excepción
        throw EmailAlreadyRegisteredException();
      }

      if (user == null || user.userMetadata == null) {
        throw AuthenticationRepositoryException('Fallo en metadatos de usuario');
      }

    } on EmailAlreadyRegisteredException {
      rethrow; // Deja pasar esta excepción tal cual, no la envuelvas ni bloquees
    } on AuthException catch (error) {
      if (error.statusCode == "429") {
        throw RateLimitExceededException('rate_limit_exceeded');
      } else if (error.statusCode == "422") {
        throw PasswordTooShortException();
      } else if (error.statusCode == "400") {
        throw InvalidEmailFormatException();
      } else {
        throw AuthenticationRepositoryException(error.message);
      }
    } catch (error) {
      throw AuthenticationRepositoryException('$error');
    }
  }


  @override
  Future<void> changePassword(String currentPassword, String newPassword) async {
    try {
      await supabase.client.auth.signInWithPassword(
        email: supabase.client.auth.currentUser!.email!,


        password: currentPassword,
      );
    } on AuthException catch (e) {
      // Si signInWithPassword falla por credenciales inválidas
      if (e.message == "Invalid login credentials") {
        throw ChangePasswordIncorrectException();
      }
      rethrow; // Relanza otros errores de autenticación del signIn
    } catch (error) {
      throw ChangePasswordIncorrectException(); // Error genérico para el primer paso
    }

    // Si el paso anterior tuvo éxito (o lo omites y confías en updateUser)
    try {
      await supabase.client.auth.updateUser(
        UserAttributes(password: newPassword),
      );
      // Éxito
    } on AuthException {
      throw ChangePasswordNoChangedException();
    } catch (error) {
      throw AuthenticationRepositoryException('generic_change_password_error');
    }
  }


  @override
  Future<void> resetPassword(String newPassword) async {
    try {
      final userRes = await Supabase.instance.client.auth.updateUser(
        UserAttributes(
          password: newPassword,
        ),
      );
      if(userRes.user == null) {
         throw AuthenticationRepositoryException('reset_password_failed_no_user');
      }
    } catch (error) {
      throw AuthenticationRepositoryException('reset_password_error');
    }
  }

  @override
  Future<void> editProfile(String newName) async {
    try {
      await Supabase.instance.client.auth.updateUser(
        UserAttributes(
          data: {'username': newName},
        ),
      );
      // Éxito
    } catch (error) {
      throw AuthenticationRepositoryException('edit_profile_error');
    }
  }

  @override
  Future<void> sendResetPasswordEmail(String email) async {
    try {
      await supabase.client.auth.resetPasswordForEmail(email);
      // Éxito
    } on AuthException catch (error) {
      if (error.statusCode == "429") {
        throw RateLimitExceededException('reset_password_email');
      }
      // "Email rate limit exceeded" o "No user found with this email" pueden ser otros errores.
      // Necesitas ver qué errores específicos devuelve Supabase aquí.
      throw AuthenticationRepositoryException('send_reset_email_auth_error: ${error.message}');
    } catch (error) {
      throw AuthenticationRepositoryException('generic_send_reset_email_error');
    }
  }
}