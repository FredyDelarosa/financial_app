import '../repositories/transaction_repository.dart';

class DeleteTransactionUseCase {
  final TransactionRepository repository;
  const DeleteTransactionUseCase(this.repository);

  Future<void> execute(String usuarioId, String transactionId) async {
    await repository.deleteTransaction(usuarioId, transactionId);
  }
}