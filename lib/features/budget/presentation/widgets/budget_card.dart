import 'package:flutter/material.dart';
import '../../domain/entities/budget.dart';

class BudgetCard extends StatelessWidget {
  final Budget budget;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const BudgetCard({
    super.key,
    required this.budget,
    required this.onEdit,
    required this.onDelete,
  });

  Color _getProgressColor(double porcentaje) {
    if (porcentaje >= 100) return Colors.red;
    if (porcentaje >= 80) return Colors.orange;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    final porcentaje = budget.porcentaje ?? 0;
    final gastado = budget.gastado ?? 0;
    final limite = budget.montoLimite;
    final color = _getProgressColor(porcentaje);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.category, color: budget.categoriaColor != null ? Color(int.parse(budget.categoriaColor!.substring(1), radix: 16)) : Colors.grey),
                const SizedBox(width: 8),
                Expanded(child: Text(budget.categoriaNombre ?? 'Categoría', style: const TextStyle(fontWeight: FontWeight.bold))),
                Text('\$${limite.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                IconButton(icon: const Icon(Icons.edit, size: 20), onPressed: onEdit),
                IconButton(icon: const Icon(Icons.delete, size: 20), onPressed: onDelete),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(value: (porcentaje / 100).clamp(0.0, 1.0), backgroundColor: Colors.grey[200], color: color),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Gastado: \$${gastado.toStringAsFixed(2)}'),
                Text('${porcentaje.toStringAsFixed(0)}%', style: TextStyle(color: color)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}