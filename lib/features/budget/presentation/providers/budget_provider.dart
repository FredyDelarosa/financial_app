import 'package:flutter/material.dart';
import '../../domain/entities/budget.dart';
import '../../domain/usecases/get_budgets_usecase.dart';
import '../../domain/usecases/create_budget_usecase.dart';
import '../../domain/usecases/update_budget_usecase.dart';
import '../../domain/usecases/delete_budget_usecase.dart';
import '../../domain/usecases/get_budget_progress_usecase.dart';

enum BudgetState { initial, loading, loaded, error }

class BudgetProvider with ChangeNotifier {
  final GetBudgetsUseCase _getBudgetsUseCase;
  final CreateBudgetUseCase _createBudgetUseCase;
  final UpdateBudgetUseCase _updateBudgetUseCase;
  final DeleteBudgetUseCase _deleteBudgetUseCase;
  final GetBudgetProgressUseCase _getBudgetProgressUseCase;

  BudgetProvider({
    required GetBudgetsUseCase getBudgetsUseCase,
    required CreateBudgetUseCase createBudgetUseCase,
    required UpdateBudgetUseCase updateBudgetUseCase,
    required DeleteBudgetUseCase deleteBudgetUseCase,
    required GetBudgetProgressUseCase getBudgetProgressUseCase,
  })  : _getBudgetsUseCase = getBudgetsUseCase,
        _createBudgetUseCase = createBudgetUseCase,
        _updateBudgetUseCase = updateBudgetUseCase,
        _deleteBudgetUseCase = deleteBudgetUseCase,
        _getBudgetProgressUseCase = getBudgetProgressUseCase;

  BudgetState _state = BudgetState.initial;
  List<Budget> _budgets = [];
  String? _errorMessage;

  BudgetState get state => _state;
  List<Budget> get budgets => List.unmodifiable(_budgets);
  String? get errorMessage => _errorMessage;

  Future<void> loadBudgets(String usuarioId, {int? mes, int? anio, String? categoriaId}) async {
    _state = BudgetState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _budgets = await _getBudgetsUseCase.execute(usuarioId, mes: mes, anio: anio, categoriaId: categoriaId);
      _state = BudgetState.loaded;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _state = BudgetState.error;
      notifyListeners();
    }
  }

  Future<bool> createBudget(String usuarioId, String categoriaId, int mes, int anio, double montoLimite) async {
    try {
      final newBudget = await _createBudgetUseCase.execute(usuarioId, categoriaId, mes, anio, montoLimite);
      _budgets = [..._budgets, newBudget];
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateBudget(String usuarioId, String budgetId, double montoLimite) async {
    try {
      final updated = await _updateBudgetUseCase.execute(usuarioId, budgetId, montoLimite);
      final index = _budgets.indexWhere((b) => b.id == budgetId);
      if (index != -1) {
        _budgets[index] = updated;
        notifyListeners();
      }
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteBudget(String usuarioId, String budgetId) async {
    try {
      await _deleteBudgetUseCase.execute(usuarioId, budgetId);
      _budgets = _budgets.where((b) => b.id != budgetId).toList();
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<List<Budget>> getBudgetProgress(String usuarioId, int mes, int anio) async {
    try {
      return await _getBudgetProgressUseCase.execute(usuarioId, mes, anio);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return [];
    }
  }

  void clearError() {
    if (_state == BudgetState.error) {
      _state = BudgetState.loaded;
      _errorMessage = null;
      notifyListeners();
    }
  }
}