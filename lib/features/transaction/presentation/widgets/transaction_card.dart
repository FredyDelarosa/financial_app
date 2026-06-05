import 'package:flutter/material.dart';
import '../../domain/entities/transaction.dart';

class TransactionCard extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TransactionCard({
    super.key,
    required this.transaction,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.tipo == 'ingreso';
    final color = isIncome ? Colors.green : Colors.red;
    final icon = isIncome ? Icons.trending_up : Icons.trending_down;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(backgroundColor: color.withValues(alpha: 0.2), child: Icon(icon, color: color)),
        title: Text(transaction.descripcion),
        subtitle: Text('${transaction.categoriaNombre ?? ''} • ${transaction.fecha.toLocal().toString().split(' ')[0]}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '\$${transaction.monto.toStringAsFixed(2)}',
              style: TextStyle(fontWeight: FontWeight.bold, color: color),
            ),
            const SizedBox(width: 8),
            IconButton(icon: const Icon(Icons.edit, size: 20), onPressed: onEdit),
            IconButton(icon: const Icon(Icons.delete, size: 20), onPressed: onDelete),
          ],
        ),
      ),
    );
  }
}