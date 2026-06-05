import '../entities/budget.dart';
import '../repositories/budget_repository.dart';

class UpdateBudgetUseCase {
  final BudgetRepository repository;

  const UpdateBudgetUseCase(this.repository);

  Future<Budget> execute(String usuarioId, String budgetId, double montoLimite) async {
    if (montoLimite <= 0) throw Exception('El monto límite debe ser positivo');
    return await repository.updateBudget(usuarioId, budgetId, montoLimite: montoLimite);
  }
}