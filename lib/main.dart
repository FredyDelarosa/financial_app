import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'injection_container.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/auth/presentation/screens/register_screen.dart';
import 'features/dashboard/presentation/screens/dashboard_screen.dart';
import 'features/category/presentation/screens/categories_screen.dart';
import 'features/transaction/presentation/screens/transactions_screen.dart';
import 'features/budget/presentation/screens/budgets_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await InjectionContainer.init();
  runApp(
    DevicePreview(
      enabled: kIsWeb,
      builder: (context) => MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: InjectionContainer.authModule.authProvider),
          ChangeNotifierProvider.value(value: InjectionContainer.categoryModule.categoryProvider),
          ChangeNotifierProvider(create: (_) => InjectionContainer.transactionModule.transactionProvider),
          ChangeNotifierProvider(create: (_) => InjectionContainer.budgetModule.budgetProvider),
        ],
        child: App(
          initialRoute: '/login',
          routes: {
            '/login': (context) => const LoginScreen(),
            '/register': (context) => const RegisterScreen(),
            '/dashboard': (context) => const DashboardScreen(),
            '/categories': (context) => const CategoriesScreen(),
            '/transactions': (context) => const TransactionsScreen(),
            '/budgets': (context) => const BudgetsScreen(),
          },
        ),
      ),
    ),
  );
}