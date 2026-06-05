import '../repositories/goal_repository.dart';

class DeleteGoalUseCase {
  final GoalRepository repository;

  const DeleteGoalUseCase(this.repository);

  Future<void> execute(String usuarioId, String goalId) async {
    await repository.deleteGoal(usuarioId, goalId);
  }
}