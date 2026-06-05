import 'package:flutter/material.dart';
import '../../domain/entities/goal.dart';
import '../../domain/usecases/get_goals_usecase.dart';
import '../../domain/usecases/create_goal_usecase.dart';
import '../../domain/usecases/update_goal_usecase.dart';
import '../../domain/usecases/delete_goal_usecase.dart';
import '../../domain/usecases/update_goal_progress_usecase.dart';

enum GoalState { initial, loading, loaded, error }

class GoalProvider with ChangeNotifier {
  final GetGoalsUseCase _getGoalsUseCase;
  final CreateGoalUseCase _createGoalUseCase;
  final UpdateGoalUseCase _updateGoalUseCase;
  final DeleteGoalUseCase _deleteGoalUseCase;
  final UpdateGoalProgressUseCase _updateGoalProgressUseCase;

  GoalProvider({
    required GetGoalsUseCase getGoalsUseCase,
    required CreateGoalUseCase createGoalUseCase,
    required UpdateGoalUseCase updateGoalUseCase,
    required DeleteGoalUseCase deleteGoalUseCase,
    required UpdateGoalProgressUseCase updateGoalProgressUseCase,
  })  : _getGoalsUseCase = getGoalsUseCase,
        _createGoalUseCase = createGoalUseCase,
        _updateGoalUseCase = updateGoalUseCase,
        _deleteGoalUseCase = deleteGoalUseCase,
        _updateGoalProgressUseCase = updateGoalProgressUseCase;

  GoalState _state = GoalState.initial;
  List<Goal> _goals = [];
  String? _errorMessage;

  GoalState get state => _state;
  List<Goal> get goals => List.unmodifiable(_goals);
  String? get errorMessage => _errorMessage;

  Future<void> loadGoals(String usuarioId, {String? estado, int? prioridad}) async {
    _state = GoalState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _goals = await _getGoalsUseCase.execute(usuarioId, estado: estado, prioridad: prioridad);
      _state = GoalState.loaded;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _state = GoalState.error;
      notifyListeners();
    }
  }

  Future<bool> createGoal(String usuarioId, String nombre, double montoObjetivo, double montoActual, DateTime fechaLimite, int prioridad) async {
    try {
      final newGoal = await _createGoalUseCase.execute(usuarioId, nombre, montoObjetivo, montoActual, fechaLimite, prioridad);
      _goals = [..._goals, newGoal];
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateGoal(String usuarioId, String goalId, {String? nombre, double? montoObjetivo, DateTime? fechaLimite, int? prioridad, String? estado}) async {
    try {
      final updated = await _updateGoalUseCase.execute(usuarioId, goalId, nombre: nombre, montoObjetivo: montoObjetivo, fechaLimite: fechaLimite, prioridad: prioridad, estado: estado);
      final index = _goals.indexWhere((g) => g.id == goalId);
      if (index != -1) {
        _goals[index] = updated;
        notifyListeners();
      }
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteGoal(String usuarioId, String goalId) async {
    try {
      await _deleteGoalUseCase.execute(usuarioId, goalId);
      _goals = _goals.where((g) => g.id != goalId).toList();
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> addProgress(String usuarioId, String goalId, double montoAdicional) async {
    try {
      final updated = await _updateGoalProgressUseCase.execute(usuarioId, goalId, montoAdicional);
      final index = _goals.indexWhere((g) => g.id == goalId);
      if (index != -1) {
        _goals[index] = updated;
        notifyListeners();
      }
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    if (_state == GoalState.error) {
      _state = GoalState.loaded;
      _errorMessage = null;
      notifyListeners();
    }
  }
}