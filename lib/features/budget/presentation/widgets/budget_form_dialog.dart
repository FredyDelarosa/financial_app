import 'package:flutter/material.dart';
import '../../../category/domain/entities/category.dart';

class BudgetFormDialog extends StatefulWidget {
  final List<Category> categories;
  final int? initialMes;
  final int? initialAnio;
  final String? initialCategoriaId;
  final double? initialMontoLimite;

  const BudgetFormDialog({
    super.key,
    required this.categories,
    this.initialMes,
    this.initialAnio,
    this.initialCategoriaId,
    this.initialMontoLimite,
  });

  @override
  State<BudgetFormDialog> createState() => _BudgetFormDialogState();
}

class _BudgetFormDialogState extends State<BudgetFormDialog> {
  late int _mes;
  late int _anio;
  late String _categoriaId;
  late final TextEditingController _montoCtrl;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _mes = widget.initialMes ?? now.month;
    _anio = widget.initialAnio ?? now.year;
    _categoriaId = widget.initialCategoriaId ?? (widget.categories.isNotEmpty ? widget.categories.first.id : '');
    _montoCtrl = TextEditingController(text: widget.initialMontoLimite?.toString() ?? '');
  }

  @override
  void dispose() {
    _montoCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.initialMontoLimite == null ? 'Nuevo presupuesto' : 'Editar presupuesto'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<int>(
              initialValue: _mes,
              decoration: const InputDecoration(labelText: 'Mes'),
              items: List.generate(12, (i) => DropdownMenuItem(value: i + 1, child: Text(_nombreMes(i + 1)))),
              onChanged: (v) => setState(() => _mes = v!),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<int>(
              initialValue: _anio,
              decoration: const InputDecoration(labelText: 'Año'),
              items: List.generate(5, (i) => DropdownMenuItem(value: 2024 + i, child: Text((2024 + i).toString()))),
              onChanged: (v) => setState(() => _anio = v!),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: _categoriaId,
              decoration: const InputDecoration(labelText: 'Categoría'),
              items: widget.categories.map((c) => DropdownMenuItem(value: c.id, child: Text(c.nombre))).toList(),
              onChanged: (v) => setState(() => _categoriaId = v!),
              validator: (v) => v == null ? 'Seleccione una categoría' : null,
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _montoCtrl,
              decoration: const InputDecoration(labelText: 'Monto límite'),
              keyboardType: TextInputType.number,
              validator: (v) {
                if (v == null || v.isEmpty) return 'Requerido';
                if (double.tryParse(v) == null) return 'Número válido';
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
        TextButton(
          onPressed: () {
            if (_montoCtrl.text.isNotEmpty && double.tryParse(_montoCtrl.text) != null) {
              Navigator.pop(context, {
                'categoriaId': _categoriaId,
                'mes': _mes,
                'anio': _anio,
                'montoLimite': double.parse(_montoCtrl.text),
              });
            }
          },
          child: const Text('Guardar'),
        ),
      ],
    );
  }

  String _nombreMes(int mes) {
    const meses = ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'];
    return meses[mes - 1];
  }
}