import '../../domain/ports/transaction_service.dart';
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
  Future<double> getAhorroDisponible(String usuarioId) async {
    // Ejemplo: obtener el balance neto del último mes
    final uri = Uri.parse('${AppConstants.baseUrl}/api/transactions/summary/last-month');
    final response = await client.get(uri, headers: await _authHeaders());
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      return (data['ahorro_disponible'] as num).toDouble();
    }
    return 0.0;
  }
}