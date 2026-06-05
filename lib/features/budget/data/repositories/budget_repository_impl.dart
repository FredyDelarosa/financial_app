import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/budget.dart';
import '../../domain/repositories/budget_repository.dart';
import '../datasources/remote/model/budget_dto.dart';
import '../datasources/remote/model/create_budget_request.dart';
import '../datasources/remote/model/update_budget_request.dart';

class BudgetRepositoryImpl implements BudgetRepository {
  final http.Client client;
  final String Function() getToken;

  BudgetRepositoryImpl({required this.client, required this.getToken});

  Future<Map<String, String>> _authHeaders() async {
    final token = getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  @override
  Future<List<Budget>> getBudgets(String usuarioId, {int? mes, int? anio, String? categoriaId}) async {
    final queryParams = <String, String>{};
    if (mes != null) queryParams['mes'] = mes.toString();
    if (anio != null) queryParams['anio'] = anio.toString();
    if (categoriaId != null) queryParams['categoria_id'] = categoriaId;

    final uri = Uri.parse('${AppConstants.baseUrl}/api/budgets').replace(queryParameters: queryParams);
    final response = await client.get(uri, headers: await _authHeaders());

    if (response.statusCode == 200) {
      final List<dynamic> list = jsonDecode(response.body)['data'];
      return list.map((e) => BudgetDto.fromJson(e).toEntity()).toList();
    }
    throw Exception('Error al obtener presupuestos');
  }

  @override
  Future<Budget> createBudget(String usuarioId, String categoriaId, int mes, int anio, double montoLimite) async {
    final request = CreateBudgetRequest(
      categoriaId: categoriaId,
      mes: mes,
      anio: anio,
      montoLimite: montoLimite,
    );
    final response = await client.post(
      Uri.parse('${AppConstants.baseUrl}/api/budgets'),
      headers: await _authHeaders(),
      body: jsonEncode(request.toJson()),
    );
    if (response.statusCode == 201) {
      final data = jsonDecode(response.body)['data'];
      return BudgetDto.fromJson(data).toEntity();
    }
    throw Exception('Error al crear presupuesto');
  }

  @override
  Future<Budget> updateBudget(String usuarioId, String budgetId, {double? montoLimite}) async {
    final request = UpdateBudgetRequest(montoLimite: montoLimite!);
    final response = await client.put(
      Uri.parse('${AppConstants.baseUrl}/api/budgets/$budgetId'),
      headers: await _authHeaders(),
      body: jsonEncode(request.toJson()),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      return BudgetDto.fromJson(data).toEntity();
    }
    throw Exception('Error al actualizar presupuesto');
  }

  @override
  Future<void> deleteBudget(String usuarioId, String budgetId) async {
    final response = await client.delete(
      Uri.parse('${AppConstants.baseUrl}/api/budgets/$budgetId'),
      headers: await _authHeaders(),
    );
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Error al eliminar presupuesto');
    }
  }

  @override
  Future<Budget?> getBudgetByCategoryAndMonth(String usuarioId, String categoriaId, int mes, int anio) async {
    final response = await getBudgets(usuarioId, mes: mes, anio: anio, categoriaId: categoriaId);
    return response.isNotEmpty ? response.first : null;
  }
}