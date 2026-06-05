import '../repositories/budget_repository.dart';

class DeleteBudgetUseCase {
  final BudgetRepository repository;

  const DeleteBudgetUseCase(this.repository);

  Future<void> execute(String usuarioId, String budgetId) async {
    await repository.deleteBudget(usuarioId, budgetId);
  }
}