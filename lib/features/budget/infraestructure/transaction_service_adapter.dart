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
    final uri = Uri.parse('${AppConstants.baseUrl}/api/transactions/summary/category/$categoriaId?mes=$mes&anio=$anio');
    final response = await client.get(uri, headers: await _authHeaders());
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      return (data['total'] as num).toDouble();
    }
    return 0.0;
  }

  @override
  Future<Map<String, double>> getGastosPorCategorias(String usuarioId, int mes, int anio) async {
    final uri = Uri.parse('${AppConstants.baseUrl}/api/transactions/summary/gastos?mes=$mes&anio=$anio');
    final response = await client.get(uri, headers: await _authHeaders());
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body)['data'];
      return data.map((key, value) => MapEntry(key, (value as num).toDouble()));
    }
    return {};
  }
}