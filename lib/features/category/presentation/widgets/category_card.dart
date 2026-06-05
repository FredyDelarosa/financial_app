import 'package:flutter/material.dart';
import '../../domain/entities/category.dart';

class CategoryCard extends StatelessWidget {
  final Category category;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CategoryCard({
    super.key,
    required this.category,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final color = Color(int.parse(category.color.substring(1, 7), radix: 16));
    final icon = IconData(category.icono.codeUnitAt(0), fontFamily: 'MaterialIcons');

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(backgroundColor: color, child: Icon(icon, color: Colors.white)),
        title: Text(category.nombre),
        subtitle: Text(category.tipo == 'ingreso' ? 'Ingreso' : 'Gasto'),
        trailing: category.esSistema
            ? null
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(icon: const Icon(Icons.edit), onPressed: onEdit),
                  IconButton(icon: const Icon(Icons.delete), onPressed: onDelete),
                ],
              ),
      ),
    );
  }
}