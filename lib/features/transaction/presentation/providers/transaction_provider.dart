import 'package:flutter/material.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/usecases/get_transactions_usecase.dart';
import '../../domain/usecases/create_transaction_usecase.dart';
import '../../domain/usecases/update_transaction_usecase.dart';
import '../../domain/usecases/delete_transaction_usecase.dart';
import '../../domain/usecases/get_monthly_summary_usecase.dart';

enum TransactionState { initial, loading, loaded, error }

class TransactionProvider with ChangeNotifier {
  final GetTransactionsUseCase _getTransactionsUseCase;
  final CreateTransactionUseCase _createTransactionUseCase;
  final UpdateTransactionUseCase _updateTransactionUseCase;
  final DeleteTransactionUseCase _deleteTransactionUseCase;
  final GetMonthlySummaryUseCase _getMonthlySummaryUseCase;

  TransactionProvider({
    required GetTransactionsUseCase getTransactionsUseCase,
    required CreateTransactionUseCase createTransactionUseCase,
    required UpdateTransactionUseCase updateTransactionUseCase,
    required DeleteTransactionUseCase deleteTransactionUseCase,
    required GetMonthlySummaryUseCase getMonthlySummaryUseCase,
  })  : _getTransactionsUseCase = getTransactionsUseCase,
        _createTransactionUseCase = createTransactionUseCase,
        _updateTransactionUseCase = updateTransactionUseCase,
        _deleteTransactionUseCase = deleteTransactionUseCase,
        _getMonthlySummaryUseCase = getMonthlySummaryUseCase;

  TransactionState _state = TransactionState.initial;
  List<Transaction> _transactions = [];
  String? _errorMessage;
  Map<String, dynamic>? _monthlySummary;

  TransactionState get state => _state;
  List<Transaction> get transactions => List.unmodifiable(_transactions);
  String? get errorMessage => _errorMessage;
  Map<String, dynamic>? get monthlySummary => _monthlySummary;

  Future<void> loadTransactions(
    String usuarioId, {
    DateTime? startDate,
    DateTime? endDate,
    String? tipo,
    String? categoriaId,
  }) async {
    _state = TransactionState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _transactions = await _getTransactionsUseCase.execute(
        usuarioId,
        startDate: startDate,
        endDate: endDate,
        tipo: tipo,
        categoriaId: categoriaId,
      );
      _state = TransactionState.loaded;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _state = TransactionState.error;
      notifyListeners();
    }
  }

  Future<bool> createTransaction(
    String usuarioId,
    String categoriaId,
    double monto,
    String descripcion,
    DateTime fecha,
    String tipo,
    String metodoPago, {
    bool esRecurrente = false,
    String? frecuencia,
  }) async {
    try {
      final newTransaction = await _createTransactionUseCase.execute(
        usuarioId,
        categoriaId,
        monto,
        descripcion,
        fecha,
        tipo,
        metodoPago,
        esRecurrente: esRecurrente,
        frecuencia: frecuencia,
      );
      _transactions = [newTransaction, ..._transactions];
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateTransaction(
    String usuarioId,
    String transactionId, {
    String? categoriaId,
    double? monto,
    String? descripcion,
    DateTime? fecha,
    String? metodoPago,
  }) async {
    try {
      final updated = await _updateTransactionUseCase.execute(
        usuarioId,
        transactionId,
        categoriaId: categoriaId,
        monto: monto,
        descripcion: descripcion,
        fecha: fecha,
        metodoPago: metodoPago,
      );
      final index = _transactions.indexWhere((t) => t.id == transactionId);
      if (index != -1) {
        _transactions[index] = updated;
        notifyListeners();
      }
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteTransaction(String usuarioId, String transactionId) async {
    try {
      await _deleteTransactionUseCase.execute(usuarioId, transactionId);
      _transactions = _transactions.where((t) => t.id != transactionId).toList();
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<void> loadMonthlySummary(String usuarioId, int year, int month) async {
    try {
      _monthlySummary = await _getMonthlySummaryUseCase.execute(usuarioId, year, month);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  void clearError() {
    if (_state == TransactionState.error) {
      _state = TransactionState.loaded;
      _errorMessage = null;
      notifyListeners();
    }
  }
}