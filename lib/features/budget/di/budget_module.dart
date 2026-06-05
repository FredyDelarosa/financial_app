import 'package:http/http.dart' as http;
import '../data/repositories/budget_repository_impl.dart';
import '../domain/repositories/budget_repository.dart';
import '../domain/usecases/get_budgets_usecase.dart';
import '../domain/usecases/create_budget_usecase.dart';
import '../domain/usecases/update_budget_usecase.dart';
import '../domain/usecases/delete_budget_usecase.dart';
import '../domain/usecases/get_budget_progress_usecase.dart';
import '../presentation/providers/budget_provider.dart';
import '../infraestructure/transaction_service_adapter.dart';

class BudgetModule {
  late final BudgetRepository _repository;
  late final GetBudgetsUseCase _getBudgetsUseCase;
  late final CreateBudgetUseCase _createBudgetUseCase;
  late final UpdateBudgetUseCase _updateBudgetUseCase;
  late final DeleteBudgetUseCase _deleteBudgetUseCase;
  late final GetBudgetProgressUseCase _getBudgetProgressUseCase;
  late final BudgetProvider _budgetProvider;

  BudgetModule({
    required http.Client httpClient,
    required String Function() getToken,
  }) {
    _repository = BudgetRepositoryImpl(client: httpClient, getToken: getToken);
    final transactionService = TransactionServiceAdapter(client: httpClient, getToken: getToken);

    _getBudgetsUseCase = GetBudgetsUseCase(_repository, transactionService);
    _createBudgetUseCase = CreateBudgetUseCase(_repository);
    _updateBudgetUseCase = UpdateBudgetUseCase(_repository);
    _deleteBudgetUseCase = DeleteBudgetUseCase(_repository);
    _getBudgetProgressUseCase = GetBudgetProgressUseCase(_repository, transactionService);

    _budgetProvider = BudgetProvider(
      getBudgetsUseCase: _getBudgetsUseCase,
      createBudgetUseCase: _createBudgetUseCase,
      updateBudgetUseCase: _updateBudgetUseCase,
      deleteBudgetUseCase: _deleteBudgetUseCase,
      getBudgetProgressUseCase: _getBudgetProgressUseCase,
    );
  }

  BudgetProvider get budgetProvider => _budgetProvider;
}