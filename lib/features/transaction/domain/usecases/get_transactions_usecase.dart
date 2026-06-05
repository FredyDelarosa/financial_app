import '../entities/transaction.dart';
import '../repositories/transaction_repository.dart';

class GetTransactionsUseCase {
  final TransactionRepository repository;
  const GetTransactionsUseCase(this.repository);

  Future<List<Transaction>> execute(
    String usuarioId, {
    DateTime? startDate,
    DateTime? endDate,
    String? tipo,
    String? categoriaId,
  }) async {
    return await repository.getTransactions(
      usuarioId,
      startDate: startDate,
      endDate: endDate,
      tipo: tipo,
      categoriaId: categoriaId,
    );
  }
}