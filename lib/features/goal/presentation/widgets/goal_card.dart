import 'package:flutter/material.dart';
import '../../domain/entities/goal.dart';

class GoalCard extends StatelessWidget {
  final Goal goal;
  final VoidCallback onAddProgress;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const GoalCard({
    super.key,
    required this.goal,
    required this.onAddProgress,
    required this.onEdit,
    required this.onDelete,
  });

  Color _getProgressColor(double progreso) {
    if (progreso >= 100) return Colors.green;
    if (progreso >= 50) return Colors.orange;
    return Colors.blue;
  }

  @override
  Widget build(BuildContext context) {
    final progreso = goal.progreso ?? 0;
    final color = _getProgressColor(progreso);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(goal.nombre, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.flag, size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(goal.montoObjetivo.toStringAsFixed(2), style: const TextStyle(fontSize: 14)),
                          const SizedBox(width: 16),
                          Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text('${goal.fechaLimite.day}/${goal.fechaLimite.month}/${goal.fechaLimite.year}', style: const TextStyle(fontSize: 14)),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: goal.estado == 'completada' ? Colors.green : (goal.estado == 'cancelada' ? Colors.red : Colors.blue),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        goal.estado == 'activa' ? 'Activa' : (goal.estado == 'completada' ? 'Completada' : 'Cancelada'),
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        IconButton(icon: const Icon(Icons.add_circle, size: 20), onPressed: onAddProgress, tooltip: 'Agregar progreso'),
                        IconButton(icon: const Icon(Icons.edit, size: 20), onPressed: onEdit),
                        IconButton(icon: const Icon(Icons.delete, size: 20), onPressed: onDelete),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(value: (progreso / 100).clamp(0.0, 1.0), backgroundColor: Colors.grey[200], color: color),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${goal.montoActual.toStringAsFixed(2)} / ${goal.montoObjetivo.toStringAsFixed(2)}'),
                Text('${progreso.toStringAsFixed(0)}%', style: TextStyle(color: color, fontWeight: FontWeight.bold)),
              ],
            ),
            if (goal.diasRestantes != null && goal.diasRestantes! > 0 && goal.estado == 'activa')
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text('${goal.diasRestantes} días restantes', style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ),
          ],
        ),
      ),
    );
  }
}