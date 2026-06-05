import '../entities/budget.dart';
import '../repositories/budget_repository.dart';

class CreateBudgetUseCase {
  final BudgetRepository repository;

  const CreateBudgetUseCase(this.repository);

  Future<Budget> execute(String usuarioId, String categoriaId, int mes, int anio, double montoLimite) async {
    if (mes < 1 || mes > 12) throw Exception('Mes inválido');
    if (anio < 2020 || anio > 2030) throw Exception('Anio inválido');
    if (montoLimite <= 0) throw Exception('El monto límite debe ser positivo');

    final existing = await repository.getBudgetByCategoryAndMonth(usuarioId, categoriaId, mes, anio);
    if (existing != null) throw Exception('Ya existe un presupuesto para esta categoría en el período indicado');

    return await repository.createBudget(usuarioId, categoriaId, mes, anio, montoLimite);
  }
}