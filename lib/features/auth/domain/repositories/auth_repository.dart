import '../entities/user.dart';

abstract class AuthRepository {
  Future<User> login(String email, String password);
  Future<User> register(String nombre, String email, String password, {String? moneda});
  Future<void> logout();
  Future<String?> getToken();
  Future<void> saveToken(String token);
  Future<void> removeToken();
}