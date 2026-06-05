import '../entities/budget.dart';
import '../repositories/budget_repository.dart';
import '../ports/transaction_service.dart';

class GetBudgetProgressUseCase {
  final BudgetRepository repository;
  final TransactionService transactionService;

  const GetBudgetProgressUseCase(this.repository, this.transactionService);

  Future<List<Budget>> execute(String usuarioId, int mes, int anio) async {
    // Obtener todos los presupuestos del mes
    final budgets = await repository.getBudgets(usuarioId, mes: mes, anio: anio);
    if (budgets.isEmpty) return [];

    final gastosMap = await transactionService.getGastosPorCategorias(usuarioId, mes, anio);

    return budgets.map((b) {
      final gastado = gastosMap[b.categoriaId] ?? 0.0;
      final porcentaje = b.montoLimite > 0 ? (gastado / b.montoLimite) * 100 : 0.0;
      String estado = 'normal';
      if (porcentaje >= 100) {
        estado = 'excedido';
      } else if (porcentaje >= 80) {
        estado = 'advertencia';
      }

      return Budget(
        id: b.id,
        usuarioId: b.usuarioId,
        categoriaId: b.categoriaId,
        mes: b.mes,
        anio: b.anio,
        montoLimite: b.montoLimite,
        categoriaNombre: b.categoriaNombre,
        categoriaIcono: b.categoriaIcono,
        categoriaColor: b.categoriaColor,
        gastado: gastado,
        porcentaje: porcentaje,
        estado: estado,
      );
    }).toList();
  }
}