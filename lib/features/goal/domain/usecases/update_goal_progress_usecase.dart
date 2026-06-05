import '../entities/goal.dart';
import '../repositories/goal_repository.dart';

class UpdateGoalProgressUseCase {
  final GoalRepository repository;

  const UpdateGoalProgressUseCase(this.repository);

  Future<Goal> execute(String usuarioId, String goalId, double montoAdicional) async {
    if (montoAdicional <= 0) throw Exception('El monto adicional debe ser positivo');

    // Primero obtener la meta actual para conocer el montoActual
    final goals = await repository.getGoals(usuarioId);
    final goal = goals.firstWhere((g) => g.id == goalId, orElse: () => throw Exception('Meta no encontrada'));
    if (goal.estado != 'activa') throw Exception('Solo se puede progresar en metas activas');

    final nuevoMontoActual = goal.montoActual + montoAdicional;
    if (nuevoMontoActual > goal.montoObjetivo) {
      throw Exception('El monto adicional excede el objetivo restante');
    }

    return await repository.updateProgress(usuarioId, goalId, nuevoMontoActual);
  }
}