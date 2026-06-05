import '../entities/transaction.dart';

abstract class TransactionRepository {
  Future<List<Transaction>> getTransactions(
    String usuarioId, {
    DateTime? startDate,
    DateTime? endDate,
    String? tipo,
    String? categoriaId,
    int? limit,
    int? offset,
  });
  Future<Transaction> createTransaction(
    String usuarioId,
    String categoriaId,
    double monto,
    String descripcion,
    DateTime fecha,
    String tipo,
    String metodoPago, {
    bool esRecurrente,
    String? frecuencia,
  });
  Future<Transaction> updateTransaction(
    String usuarioId,
    String transactionId, {
    String? categoriaId,
    double? monto,
    String? descripcion,
    DateTime? fecha,
    String? metodoPago,
  });
  Future<void> deleteTransaction(String usuarioId, String transactionId);
  Future<Map<String, dynamic>> getMonthlySummary(String usuarioId, int year, int month);
}