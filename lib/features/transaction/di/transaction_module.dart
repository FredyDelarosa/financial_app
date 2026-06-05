import 'package:http/http.dart' as http;
import '../data/repositories/transaction_repository_impl.dart';
import '../domain/repositories/transaction_repository.dart';
import '../domain/usecases/get_transactions_usecase.dart';
import '../domain/usecases/create_transaction_usecase.dart';
import '../domain/usecases/update_transaction_usecase.dart';
import '../domain/usecases/delete_transaction_usecase.dart';
import '../domain/usecases/get_monthly_summary_usecase.dart';
import '../presentation/providers/transaction_provider.dart';
import '../infrastructure/category_service_adapter.dart';
import '../../category/domain/repositories/category_repository.dart';

class TransactionModule {
  late final TransactionRepository _repository;
  late final GetTransactionsUseCase _getTransactionsUseCase;
  late final CreateTransactionUseCase _createTransactionUseCase;
  late final UpdateTransactionUseCase _updateTransactionUseCase;
  late final DeleteTransactionUseCase _deleteTransactionUseCase;
  late final GetMonthlySummaryUseCase _getMonthlySummaryUseCase;
  late final TransactionProvider _transactionProvider;

  TransactionModule({
    required http.Client httpClient,
    required String Function() getToken,
    required CategoryRepository categoryRepository,
  }) {
    _repository = TransactionRepositoryImpl(client: httpClient, getToken: getToken);
    final categoryService = CategoryServiceAdapter(categoryRepository);

    _getTransactionsUseCase = GetTransactionsUseCase(_repository);
    _createTransactionUseCase = CreateTransactionUseCase(_repository, categoryService);
    _updateTransactionUseCase = UpdateTransactionUseCase(_repository);
    _deleteTransactionUseCase = DeleteTransactionUseCase(_repository);
    _getMonthlySummaryUseCase = GetMonthlySummaryUseCase(_repository);

    _transactionProvider = TransactionProvider(
      getTransactionsUseCase: _getTransactionsUseCase,
      createTransactionUseCase: _createTransactionUseCase,
      updateTransactionUseCase: _updateTransactionUseCase,
      deleteTransactionUseCase: _deleteTransactionUseCase,
      getMonthlySummaryUseCase: _getMonthlySummaryUseCase,
    );
  }

  TransactionProvider get transactionProvider => _transactionProvider;
}