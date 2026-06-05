import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'features/auth/di/auth_module.dart';
import 'features/category/di/category_module.dart';
import 'features/transaction/di/transaction_module.dart';
import 'features/budget/di/budget_module.dart';

class InjectionContainer {
  static late final http.Client httpClient;
  static late final SharedPreferences prefs;
  static late final AuthModule authModule;
  static late final CategoryModule categoryModule;
  static late final TransactionModule transactionModule;
  static late final BudgetModule budgetModule;

  static Future<void> init() async {
    httpClient = http.Client();
    prefs = await SharedPreferences.getInstance();

    authModule = AuthModule(httpClient: httpClient, prefs: prefs);
    categoryModule = CategoryModule(
      httpClient: httpClient,
      getToken: () => prefs.getString('auth_token') ?? '',
    );
    transactionModule = TransactionModule(
      httpClient: httpClient,
      getToken: () => prefs.getString('auth_token') ?? '',
      categoryRepository: categoryModule.repository,
    );
    budgetModule = BudgetModule(
      httpClient: httpClient,
      getToken: () => prefs.getString('auth_token') ?? '',
    );
  }
  static void dispose() {
    httpClient.close();
  }
}