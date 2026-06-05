import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../datasources/remote/model/transaction_dto.dart';
import '../datasources/remote/model/create_transaction_request.dart';
import '../datasources/remote/model/update_transaction_request.dart';
import '../datasources/remote/model/monthly_summary_dto.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final http.Client client;
  final String Function() getToken;

  TransactionRepositoryImpl({required this.client, required this.getToken});

  Future<Map<String, String>> _authHeaders() async {
    final token = getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  @override
  Future<List<Transaction>> getTransactions(
    String usuarioId, {
    DateTime? startDate,
    DateTime? endDate,
    String? tipo,
    String? categoriaId,
    int? limit,
    int? offset,
  }) async {
    final queryParams = <String, String>{};
    if (startDate != null) queryParams['start_date'] = startDate.toIso8601String().split('T').first;
    if (endDate != null) queryParams['end_date'] = endDate.toIso8601String().split('T').first;
    if (tipo != null) queryParams['tipo'] = tipo;
    if (categoriaId != null) queryParams['categoria_id'] = categoriaId;
    if (limit != null) queryParams['limit'] = limit.toString();
    if (offset != null) queryParams['offset'] = offset.toString();

    final uri = Uri.parse('${AppConstants.baseUrl}/api/transactions').replace(queryParameters: queryParams);
    final response = await client.get(uri, headers: await _authHeaders());

    if (response.statusCode == 200) {
      final List<dynamic> list = jsonDecode(response.body)['data'];
      return list.map((e) => TransactionDto.fromJson(e).toEntity()).toList();
    }
    throw Exception('Error al obtener transacciones');
  }

  @override
  Future<Transaction> createTransaction(
    String usuarioId,
    String categoriaId,
    double monto,
    String descripcion,
    DateTime fecha,
    String tipo,
    String metodoPago, {
    bool esRecurrente = false,
    String? frecuencia,
  }) async {
    final request = CreateTransactionRequest(
      categoriaId: categoriaId,
      monto: monto,
      descripcion: descripcion,
      fecha: fecha.toIso8601String().split('T').first,
      tipo: tipo,
      esRecurrente: esRecurrente,
      frecuencia: frecuencia,
      metodoPago: metodoPago,
    );
    final response = await client.post(
      Uri.parse('${AppConstants.baseUrl}/api/transactions'),
      headers: await _authHeaders(),
      body: jsonEncode(request.toJson()),
    );
    if (response.statusCode == 201) {
      final data = jsonDecode(response.body)['data'];
      return TransactionDto.fromJson(data).toEntity();
    }
    throw Exception('Error al crear transacción');
  }

  @override
  Future<Transaction> updateTransaction(
    String usuarioId,
    String transactionId, {
    String? categoriaId,
    double? monto,
    String? descripcion,
    DateTime? fecha,
    String? metodoPago,
  }) async {
    final request = UpdateTransactionRequest(
      categoriaId: categoriaId,
      monto: monto,
      descripcion: descripcion,
      fecha: fecha?.toIso8601String().split('T').first,
      metodoPago: metodoPago,
    );
    final response = await client.put(
      Uri.parse('${AppConstants.baseUrl}/api/transactions/$transactionId'),
      headers: await _authHeaders(),
      body: jsonEncode(request.toJson()),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      return TransactionDto.fromJson(data).toEntity();
    }
    throw Exception('Error al actualizar transacción');
  }

  @override
  Future<void> deleteTransaction(String usuarioId, String transactionId) async {
    final response = await client.delete(
      Uri.parse('${AppConstants.baseUrl}/api/transactions/$transactionId'),
      headers: await _authHeaders(),
    );
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Error al eliminar transacción');
    }
  }

  @override
  Future<Map<String, dynamic>> getMonthlySummary(String usuarioId, int year, int month) async {
    final uri = Uri.parse('${AppConstants.baseUrl}/api/transactions/summary?year=$year&month=$month');
    final response = await client.get(uri, headers: await _authHeaders());
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      final summary = MonthlySummaryDto.fromJson(data);
      return {
        'mes': summary.mes,
        'anio': summary.anio,
        'totalIngresos': summary.totalIngresos,
        'totalGastos': summary.totalGastos,
        'balance': summary.balance,
      };
    }
    throw Exception('Error al obtener resumen mensual');
  }
}