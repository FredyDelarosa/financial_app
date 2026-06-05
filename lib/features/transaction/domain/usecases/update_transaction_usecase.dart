import '../entities/transaction.dart';
import '../repositories/transaction_repository.dart';

class UpdateTransactionUseCase {
  final TransactionRepository repository;
  const UpdateTransactionUseCase(this.repository);

  Future<Transaction> execute(
    String usuarioId,
    String transactionId, {
    String? categoriaId,
    double? monto,
    String? descripcion,
    DateTime? fecha,
    String? metodoPago,
  }) async {
    return await repository.updateTransaction(
      usuarioId,
      transactionId,
      categoriaId: categoriaId,
      monto: monto,
      descripcion: descripcion,
      fecha: fecha,
      metodoPago: metodoPago,
    );
  }
}