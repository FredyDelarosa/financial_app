import '../entities/goal.dart';
import '../repositories/goal_repository.dart';

class GetGoalsUseCase {
  final GoalRepository repository;

  const GetGoalsUseCase(this.repository);

  Future<List<Goal>> execute(String usuarioId, {String? estado, int? prioridad}) async {
    return await repository.getGoals(usuarioId, estado: estado, prioridad: prioridad);
  }
}