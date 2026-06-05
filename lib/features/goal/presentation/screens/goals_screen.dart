import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/goal.dart';
import '../providers/goal_provider.dart';
import '../widgets/goal_card.dart';
import '../widgets/goal_form_dialog.dart';
import '../widgets/add_progress_dialog.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  String _filterEstado = 'activa';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final usuarioId = context.read<AuthProvider>().user!.id;
      context.read<GoalProvider>().loadGoals(usuarioId, estado: _filterEstado);
    });
  }

  Future<void> _showCreateDialog() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => const GoalFormDialog(),
    );
    if (result != null && mounted) {
      final usuarioId = context.read<AuthProvider>().user!.id;
      await context.read<GoalProvider>().createGoal(
            usuarioId,
            result['nombre'],
            result['montoObjetivo'],
            result['montoActual'],
            result['fechaLimite'],
            result['prioridad'],
          );
    }
  }

  Future<void> _showEditDialog(Goal goal) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => GoalFormDialog(initialGoal: goal),
    );
    if (result != null && mounted) {
      final usuarioId = context.read<AuthProvider>().user!.id;
      await context.read<GoalProvider>().updateGoal(
            usuarioId,
            goal.id,
            nombre: result['nombre'],
            montoObjetivo: result['montoObjetivo'],
            fechaLimite: result['fechaLimite'],
            prioridad: result['prioridad'],
          );
    }
  }

  Future<void> _showAddProgress(Goal goal) async {
    final montoRestante = (goal.montoObjetivo - goal.montoActual);
    if (montoRestante <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Meta ya completada')));
      return;
    }
    final monto = await showDialog<double>(
      context: context,
      builder: (_) => AddProgressDialog(goalName: goal.nombre, montoRestante: montoRestante),
    );
    if (monto != null && mounted) {
      final usuarioId = context.read<AuthProvider>().user!.id;
      await context.read<GoalProvider>().addProgress(usuarioId, goal.id, monto);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GoalProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Metas de ahorro'),
        actions: [
          DropdownButton<String>(
            value: _filterEstado,
            items: const [
              DropdownMenuItem(value: 'activa', child: Text('Activas')),
              DropdownMenuItem(value: 'completada', child: Text('Completadas')),
              DropdownMenuItem(value: 'cancelada', child: Text('Canceladas')),
              DropdownMenuItem(value: null, child: Text('Todas')),
            ],
            onChanged: (v) {
              setState(() => _filterEstado = v ?? '');
              final usuarioId = context.read<AuthProvider>().user!.id;
              provider.loadGoals(usuarioId, estado: v);
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: switch (provider.state) {
        GoalState.loading => const Center(child: CircularProgressIndicator()),
        GoalState.error => Center(child: Text('Error: ${provider.errorMessage}')),
        _ => provider.goals.isEmpty
            ? const Center(child: Text('No hay metas'))
            : ListView.builder(
                itemCount: provider.goals.length,
                itemBuilder: (context, index) {
                  final g = provider.goals[index];
                  return GoalCard(
                    goal: g,
                    onAddProgress: () => _showAddProgress(g),
                    onEdit: () => _showEditDialog(g),
                    onDelete: () async {
                      final usuarioId = context.read<AuthProvider>().user!.id;
                      await provider.deleteGoal(usuarioId, g.id);
                    },
                  );
                },
              ),
      },
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}