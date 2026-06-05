import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;
  const LoginUseCase(this.repository);

  Future<User> execute(String email, String password) async {
    if (email.isEmpty) throw Exception('Email requerido');
    if (password.isEmpty) throw Exception('Contraseña requerida');
    return await repository.login(email, password);
  }
}