import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/goal.dart';
import '../../domain/repositories/goal_repository.dart';
import '../datasources/remote/model/goal_dto.dart';
import '../datasources/remote/model/create_goal_request.dart';
import '../datasources/remote/model/update_goal_request.dart';
// import '../datasources/remote/model/update_progress_request.dart';

class GoalRepositoryImpl implements GoalRepository {
  final http.Client client;
  final String Function() getToken;

  GoalRepositoryImpl({required this.client, required this.getToken});

  Future<Map<String, String>> _authHeaders() async {
    final token = getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  @override
  Future<List<Goal>> getGoals(String usuarioId, {String? estado, int? prioridad}) async {
    final queryParams = <String, String>{};
    if (estado != null) queryParams['estado'] = estado;
    if (prioridad != null) queryParams['prioridad'] = prioridad.toString();
    queryParams['usuario_id'] = usuarioId;

    final uri = Uri.parse('${AppConstants.baseUrl}/api/goals/').replace(queryParameters: queryParams);
    final response = await client.get(uri, headers: await _authHeaders());

    if (response.statusCode == 200) {
      final List<dynamic>? data = jsonDecode(response.body)['data'];
      final List<dynamic> list = data ?? [];
      return list.map((e) => GoalDto.fromJson(e).toEntity()).toList();
    }
    throw Exception('Error al obtener metas: ${response.statusCode}');
  }

  @override
  Future<Goal> createGoal(String usuarioId, String nombre, double montoObjetivo, double montoActual, DateTime fechaLimite, int prioridad) async {
    final request = CreateGoalRequest(
      nombre: nombre,
      montoObjetivo: montoObjetivo,
      montoActual: montoActual,
      fechaLimite: fechaLimite.toIso8601String().split('T').first,
      prioridad: prioridad,
    );
    final response = await client.post(
      Uri.parse('${AppConstants.baseUrl}/api/goals/'),
      headers: await _authHeaders(),
      body: jsonEncode(request.toJson()),
    );
    if (response.statusCode == 201) {
      final data = jsonDecode(response.body)['data'];
      return GoalDto.fromJson(data).toEntity();
    }
    throw Exception('Error al crear meta');
  }

  @override
  Future<Goal> updateGoal(String usuarioId, String goalId, {String? nombre, double? montoObjetivo, DateTime? fechaLimite, int? prioridad, String? estado}) async {
    final request = UpdateGoalRequest(
      nombre: nombre,
      montoObjetivo: montoObjetivo,
      fechaLimite: fechaLimite?.toIso8601String().split('T').first,
      prioridad: prioridad,
      estado: estado,
    );
    final response = await client.put(
      Uri.parse('${AppConstants.baseUrl}/api/goals/$goalId'),
      headers: await _authHeaders(),
      body: jsonEncode(request.toJson()),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      return GoalDto.fromJson(data).toEntity();
    }
    throw Exception('Error al actualizar meta');
  }

  @override
  Future<void> deleteGoal(String usuarioId, String goalId) async {
    final response = await client.delete(
      Uri.parse('${AppConstants.baseUrl}/api/goals/$goalId'),
      headers: await _authHeaders(),
    );
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Error al eliminar meta');
    }
  }

  @override
  Future<Goal> updateProgress(String usuarioId, String goalId, double nuevoMontoActual) async {
    final response = await client.post(
      Uri.parse('${AppConstants.baseUrl}/api/goals/$goalId/progress'),
      headers: await _authHeaders(),
      body: jsonEncode({'monto_actual': nuevoMontoActual}),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      return GoalDto.fromJson(data).toEntity();
    }
    throw Exception('Error al actualizar progreso');
  }
}