import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';
import '../widgets/transaction_card.dart';
import '../widgets/transaction_form_dialog.dart';
import '../widgets/transaction_filter_bar.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../category/domain/entities/category.dart';
import '../../domain/entities/transaction.dart';
import '../../../../injection_container.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Category> _categories = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final usuarioId = context.read<AuthProvider>().user!.id;
      // Cargar categorías para el formulario
      try {
        final categoryRepo = InjectionContainer.categoryModule.repository;
        _categories = await categoryRepo.getCategories(usuarioId);
        setState(() {});
      } catch (_) {}
      // Cargar transacciones
      if (mounted) {
        await context.read<TransactionProvider>().loadTransactions(usuarioId);
      }
    });
  }

  Future<void> _showCreateDialog() async {
    if (_categories.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Primero crea categorías')),
      );
      return;
    }
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => TransactionFormDialog(categories: _categories),
    );
    if (result != null && mounted) {
      final usuarioId = context.read<AuthProvider>().user!.id;
      await context.read<TransactionProvider>().createTransaction(
            usuarioId,
            result['categoriaId'],
            result['monto'],
            result['descripcion'],
            result['fecha'],
            result['tipo'],
            result['metodoPago'],
          );
    }
  }

  Future<void> _showEditDialog(Transaction transaction) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => TransactionFormDialog(
        categories: _categories,
        initialTransaction: transaction,
      ),
    );
    if (result != null && mounted) {
      final usuarioId = context.read<AuthProvider>().user!.id;
      await context.read<TransactionProvider>().updateTransaction(
            usuarioId,
            transaction.id,
            categoriaId: result['categoriaId'],
            monto: result['monto'],
            descripcion: result['descripcion'],
            fecha: result['fecha'],
            metodoPago: result['metodoPago'],
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TransactionProvider>();

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: const Text('Transacciones')),
      body: Column(
        children: [
          TransactionFilterBar(
            onFilterChanged: (start, end, tipo, categoriaId) {
              final usuarioId = context.read<AuthProvider>().user!.id;
              provider.loadTransactions(
                usuarioId,
                startDate: start,
                endDate: end,
                tipo: tipo,
                categoriaId: categoriaId,
              );
            },
          ),
          Expanded(
            child: switch (provider.state) {
              TransactionState.loading => const Center(child: CircularProgressIndicator()),
              TransactionState.error => Center(child: Text('Error: ${provider.errorMessage}')),
              _ => provider.transactions.isEmpty
                  ? const Center(child: Text('No hay transacciones'))
                  : ListView.builder(
                      itemCount: provider.transactions.length,
                      itemBuilder: (context, index) {
                        final t = provider.transactions[index];
                        return TransactionCard(
                          transaction: t,
                          onEdit: () => _showEditDialog(t),
                          onDelete: () async {
                            final usuarioId = context.read<AuthProvider>().user!.id;
                            await provider.deleteTransaction(usuarioId, t.id);
                          },
                        );
                      },
                    ),
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}