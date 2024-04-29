part of 'repositorio_autenticacion.dart';

///Clase encargada de geestionar todo lo relativo a al autenticación mediante Supabase

class SupabaseAuthRepository implements RepositorioAutenticacion {
  final Supabase supabase;
  SupabaseAuthRepository(this.supabase);

  final Logger log = Logger();

  @override
  Future<String> signInEmailAndPassword(String email, String password) {
    // TODO: implement signInEmailAndPassword
    throw UnimplementedError();
  }

}
