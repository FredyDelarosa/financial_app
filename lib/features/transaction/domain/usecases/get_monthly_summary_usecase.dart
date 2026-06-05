import '../repositories/transaction_repository.dart';

class GetMonthlySummaryUseCase {
  final TransactionRepository repository;
  const GetMonthlySummaryUseCase(this.repository);

  Future<Map<String, dynamic>> execute(String usuarioId, int year, int month) async {
    if (year < 2000 || year > 2100) throw Exception('Año inválido');
    if (month < 1 || month > 12) throw Exception('Mes inválido');
    return await repository.getMonthlySummary(usuarioId, year, month);
  }
}