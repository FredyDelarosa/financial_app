import '../entities/goal.dart';
import '../repositories/goal_repository.dart';

class CreateGoalUseCase {
  final GoalRepository repository;

  const CreateGoalUseCase(this.repository);

  Future<Goal> execute(String usuarioId, String nombre, double montoObjetivo, double montoActual, DateTime fechaLimite, int prioridad) async {
    if (nombre.trim().isEmpty) throw Exception('El nombre es requerido');
    if (montoObjetivo <= 0) throw Exception('El monto objetivo debe ser positivo');
    if (montoActual < 0) throw Exception('El monto actual no puede ser negativo');
    if (montoActual > montoObjetivo) throw Exception('El monto actual no puede superar el objetivo');
    if (fechaLimite.isBefore(DateTime.now())) throw Exception('La fecha límite debe ser futura');
    if (prioridad < 1 || prioridad > 5) throw Exception('Prioridad debe ser entre 1 y 5');

    return await repository.createGoal(usuarioId, nombre, montoObjetivo, montoActual, fechaLimite, prioridad);
  }
}