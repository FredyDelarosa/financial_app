import 'package:http/http.dart' as http;
import '../data/repositories/goal_repository_impl.dart';
import '../domain/repositories/goal_repository.dart';
import '../domain/usecases/get_goals_usecase.dart';
import '../domain/usecases/create_goal_usecase.dart';
import '../domain/usecases/update_goal_usecase.dart';
import '../domain/usecases/delete_goal_usecase.dart';
import '../domain/usecases/update_goal_progress_usecase.dart';
import '../presentation/providers/goal_provider.dart';

class GoalModule {
  late final GoalRepository _repository;
  late final GetGoalsUseCase _getGoalsUseCase;
  late final CreateGoalUseCase _createGoalUseCase;
  late final UpdateGoalUseCase _updateGoalUseCase;
  late final DeleteGoalUseCase _deleteGoalUseCase;
  late final UpdateGoalProgressUseCase _updateGoalProgressUseCase;
  late final GoalProvider _goalProvider;

  GoalModule({
    required http.Client httpClient,
    required String Function() getToken,
  }) {
    _repository = GoalRepositoryImpl(client: httpClient, getToken: getToken);
    _getGoalsUseCase = GetGoalsUseCase(_repository);
    _createGoalUseCase = CreateGoalUseCase(_repository);
    _updateGoalUseCase = UpdateGoalUseCase(_repository);
    _deleteGoalUseCase = DeleteGoalUseCase(_repository);
    _updateGoalProgressUseCase = UpdateGoalProgressUseCase(_repository);

    _goalProvider = GoalProvider(
      getGoalsUseCase: _getGoalsUseCase,
      createGoalUseCase: _createGoalUseCase,
      updateGoalUseCase: _updateGoalUseCase,
      deleteGoalUseCase: _deleteGoalUseCase,
      updateGoalProgressUseCase: _updateGoalProgressUseCase,
    );
  }

  GoalProvider get goalProvider => _goalProvider;
}