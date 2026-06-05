import '../entities/budget.dart';

abstract class BudgetRepository {
  Future<List<Budget>> getBudgets(String usuarioId, {int? mes, int? anio, String? categoriaId});
  Future<Budget> createBudget(String usuarioId, String categoriaId, int mes, int anio, double montoLimite);
  Future<Budget> updateBudget(String usuarioId, String budgetId, {double? montoLimite});
  Future<void> deleteBudget(String usuarioId, String budgetId);
  Future<Budget?> getBudgetByCategoryAndMonth(String usuarioId, String categoriaId, int mes, int anio);
}