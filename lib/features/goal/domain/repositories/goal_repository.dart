import '../entities/goal.dart';

abstract class GoalRepository {
  Future<List<Goal>> getGoals(String usuarioId, {String? estado, int? prioridad});
  Future<Goal> createGoal(String usuarioId, String nombre, double montoObjetivo, double montoActual, DateTime fechaLimite, int prioridad);
  Future<Goal> updateGoal(String usuarioId, String goalId, {String? nombre, double? montoObjetivo, DateTime? fechaLimite, int? prioridad, String? estado});
  Future<void> deleteGoal(String usuarioId, String goalId);
  Future<Goal> updateProgress(String usuarioId, String goalId, double nuevoMontoActual);
}