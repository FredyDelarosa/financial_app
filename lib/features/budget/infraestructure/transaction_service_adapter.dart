import '../domain/ports/transaction_service.dart';
import '../../../../core/constants/app_constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TransactionServiceAdapter implements TransactionService {
  final http.Client client;
  final String Function() getToken;

  TransactionServiceAdapter({required this.client, required this.getToken});

  Future<Map<String, String>> _authHeaders() async {
    final token = getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  @override
  Future<double> getGastosPorCategoria(String usuarioId, String categoriaId, int mes, int anio) async {
    final uri = Uri.parse('${AppConstants.baseUrl}/api/transactions/summary').replace(
      queryParameters: {
        'year': anio.toString(),
        'month': mes.toString().padLeft(2, '0'),
      },
    );
    final response = await client.get(uri, headers: await _authHeaders());
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      final List<dynamic> topGastos = data['top_gastos'] ?? [];
      final categoriaGasto = topGastos.firstWhere(
        (g) => g['categoria_id'] == categoriaId,
        orElse: () => null,
      );
      return categoriaGasto != null ? (categoriaGasto['total'] as num).toDouble() : 0.0;
    }
    return 0.0;
  }

  @override
  Future<Map<String, double>> getGastosPorCategorias(String usuarioId, int mes, int anio) async {
    final uri = Uri.parse('${AppConstants.baseUrl}/api/transactions/summary').replace(
      queryParameters: {
        'year': anio.toString(),
        'month': mes.toString().padLeft(2, '0'),
      },
    );
    final response = await client.get(uri, headers: await _authHeaders());
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      final List<dynamic> topGastos = data['top_gastos'] ?? [];
      return {
        for (var g in topGastos) g['categoria_nombre'] as String: (g['total'] as num).toDouble()
      };
    }
    return {};
  }
}