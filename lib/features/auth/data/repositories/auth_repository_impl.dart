import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/remote/mapper/user_mapper.dart';
import '../datasources/remote/model/auth_response.dart';
import '../datasources/remote/model/login_request.dart';
import '../datasources/remote/model/register_request.dart';

class AuthRepositoryImpl implements AuthRepository {
  final http.Client client;
  final SharedPreferences prefs;

  AuthRepositoryImpl({required this.client, required this.prefs});

  @override
  Future<User> login(String email, String password) async {
    final request = LoginRequest(email: email, password: password);
    final response = await client.post(
      Uri.parse('${AppConstants.baseUrl}/api/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );
    if (response.statusCode == 200) {
      final authRes = AuthResponse.fromJson(jsonDecode(response.body));
      await saveToken(authRes.token);
      return UserMapper.toEntity(authRes.user);
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['error'] ?? 'Error en login');
    }
  }

  @override
  Future<User> register(String nombre, String email, String password, {String? moneda}) async {
    final request = RegisterRequest(nombre: nombre, email: email, password: password, moneda: moneda);
    final response = await client.post(
      Uri.parse('${AppConstants.baseUrl}/api/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );
    if (response.statusCode == 201) {
      final authRes = AuthResponse.fromJson(jsonDecode(response.body));
      await saveToken(authRes.token);
      return UserMapper.toEntity(authRes.user);
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['error'] ?? 'Error en registro');
    }
  }

  @override
  Future<void> logout() => removeToken();

  @override
  Future<String?> getToken() async => prefs.getString('auth_token');

  @override
  Future<void> saveToken(String token) => prefs.setString('auth_token', token);

  @override
  Future<void> removeToken() => prefs.remove('auth_token');
}