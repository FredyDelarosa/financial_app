import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/budget_provider.dart';
import '../widgets/budget_card.dart';
import '../widgets/budget_form_dialog.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../category/domain/entities/category.dart';
import '../../../../injection_container.dart';

class BudgetsScreen extends StatefulWidget {
  const BudgetsScreen({super.key});

  @override
  State<BudgetsScreen> createState() => _BudgetsScreenState();
}

class _BudgetsScreenState extends State<BudgetsScreen> {
  List<Category> _categories = [];
  int _selectedMes = DateTime.now().month;
  int _selectedAnio = DateTime.now().year;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final usuarioId = context.read<AuthProvider>().user!.id;
      try {
        final categoryRepo = InjectionContainer.categoryModule.repository;
        _categories = await categoryRepo.getCategories(usuarioId);
        setState(() {});
      } catch (_) {}
      if (mounted) {
        await context.read<BudgetProvider>().loadBudgets(usuarioId, mes: _selectedMes, anio: _selectedAnio);
      }
    });
  }

  Future<void> _showCreateDialog() async {
    final auth = context.read<AuthProvider>();
    final budgetProvider = context.read<BudgetProvider>();
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final localContext = context;
    if (_categories.isEmpty) {
      scaffoldMessenger.showSnackBar(const SnackBar(content: Text('Primero crea categorías de gasto')));
      return;
    }
    // ignore: use_build_context_synchronously
    final result = await showDialog<Map<String, dynamic>>(
      context: localContext,
      builder: (_) => BudgetFormDialog(categories: _categories),
    );
    if (result != null && mounted) {
      final usuarioId = auth.user!.id;
      await budgetProvider.createBudget(
            usuarioId,
            result['categoriaId'],
            result['mes'],
            result['anio'],
            result['montoLimite'],
          );
      // Recargar presupuestos del mes actual
      if (mounted) {
        await budgetProvider.loadBudgets(usuarioId, mes: _selectedMes, anio: _selectedAnio);
      }
    }
  }

  Future<void> _changeMonth(int increment) async {
    setState(() {
      _selectedMes += increment;
      if (_selectedMes > 12) {
        _selectedMes = 1;
        _selectedAnio++;
      } else if (_selectedMes < 1) {
        _selectedMes = 12;
        _selectedAnio--;
      }
    });
    final usuarioId = context.read<AuthProvider>().user!.id;
    if (mounted) {
      await context.read<BudgetProvider>().loadBudgets(usuarioId, mes: _selectedMes, anio: _selectedAnio);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BudgetProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Presupuestos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month),
            onPressed: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime(_selectedAnio, _selectedMes),
                firstDate: DateTime(2020),
                lastDate: DateTime(2030),
              );
              if (date != null && mounted) {
                setState(() {
                  _selectedMes = date.month;
                  _selectedAnio = date.year;
                });
                final usuarioId = context.read<AuthProvider>().user!.id;
                await provider.loadBudgets(usuarioId, mes: _selectedMes, anio: _selectedAnio);
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(onPressed: () => _changeMonth(-1), icon: const Icon(Icons.chevron_left)),
              Text('$_nombreMes $_selectedAnio', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              IconButton(onPressed: () => _changeMonth(1), icon: const Icon(Icons.chevron_right)),
            ],
          ),
          Expanded(
            child: switch (provider.state) {
              BudgetState.loading => const Center(child: CircularProgressIndicator()),
              BudgetState.error => Center(child: Text('Error: ${provider.errorMessage}')),
              _ => provider.budgets.isEmpty
                  ? const Center(child: Text('No hay presupuestos para este mes'))
                  : ListView.builder(
                      itemCount: provider.budgets.length,
                      itemBuilder: (context, index) {
                        final b = provider.budgets[index];
                        return BudgetCard(
                          budget: b,
                          onEdit: () async {
                            final auth = context.read<AuthProvider>();
                            final result = await showDialog<Map<String, dynamic>>(
                              context: context,
                              builder: (_) => BudgetFormDialog(
                                categories: _categories,
                                initialMes: b.mes,
                                initialAnio: b.anio,
                                initialCategoriaId: b.categoriaId,
                                initialMontoLimite: b.montoLimite,
                              ),
                            );
                            if (result != null && mounted) {
                              final usuarioId = auth.user!.id;
                              await provider.updateBudget(usuarioId, b.id, result['montoLimite']);
                              if (mounted) {
                                await provider.loadBudgets(usuarioId, mes: _selectedMes, anio: _selectedAnio);
                              }
                            }
                          },
                          onDelete: () async {
                            final auth = context.read<AuthProvider>();
                            final usuarioId = auth.user!.id;
                            await provider.deleteBudget(usuarioId, b.id);
                            if (mounted) {
                              await provider.loadBudgets(usuarioId, mes: _selectedMes, anio: _selectedAnio);
                            }
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

  String get _nombreMes {
    const meses = ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'];
    return meses[_selectedMes - 1];
  }
}