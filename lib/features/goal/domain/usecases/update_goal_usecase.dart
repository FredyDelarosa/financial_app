import '../entities/goal.dart';
import '../repositories/goal_repository.dart';

class UpdateGoalUseCase {
  final GoalRepository repository;

  const UpdateGoalUseCase(this.repository);

  Future<Goal> execute(String usuarioId, String goalId, {String? nombre, double? montoObjetivo, DateTime? fechaLimite, int? prioridad, String? estado}) async {
    if (montoObjetivo != null && montoObjetivo <= 0) throw Exception('El monto objetivo debe ser positivo');
    if (prioridad != null && (prioridad < 1 || prioridad > 5)) throw Exception('Prioridad inválida');
    if (estado != null && !['activa', 'completada', 'cancelada'].contains(estado)) throw Exception('Estado inválido');

    return await repository.updateGoal(usuarioId, goalId, nombre: nombre, montoObjetivo: montoObjetivo, fechaLimite: fechaLimite, prioridad: prioridad, estado: estado);
  }
}