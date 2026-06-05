import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;
  const RegisterUseCase(this.repository);

  Future<User> execute(String nombre, String email, String password, {String? moneda}) async {
    if (nombre.length < 3) throw Exception('Nombre mínimo 3 caracteres');
    if (!email.contains('@')) throw Exception('Email inválido');
    if (password.length < 6) throw Exception('Contraseña mínimo 6 caracteres');
    return await repository.register(nombre, email, password, moneda: moneda);
  }
}