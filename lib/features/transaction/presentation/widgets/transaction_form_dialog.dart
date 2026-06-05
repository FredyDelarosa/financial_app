import 'package:flutter/material.dart';
import '../../../category/domain/entities/category.dart';
import '../../domain/entities/transaction.dart';

class TransactionFormDialog extends StatefulWidget {
  final List<Category> categories;
  final Transaction? initialTransaction;
  
  const TransactionFormDialog({
    super.key,
    required this.categories,
    this.initialTransaction,
  });

  @override
  State<TransactionFormDialog> createState() => _TransactionFormDialogState();
}

class _TransactionFormDialogState extends State<TransactionFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _montoCtrl;
  late final TextEditingController _descripcionCtrl;
  late DateTime _fecha;
  late String _tipo;
  late String _categoriaId;
  late String _metodoPago;

  final List<String> _metodosPago = ['efectivo', 'tarjeta', 'transferencia'];

  @override
  void initState() {
    super.initState();
    final initial = widget.initialTransaction;
    _montoCtrl = TextEditingController(text: initial?.monto.toString() ?? '');
    _descripcionCtrl = TextEditingController(text: initial?.descripcion ?? '');
    _fecha = initial?.fecha ?? DateTime.now();
    _tipo = initial?.tipo ?? 'gasto';
    _categoriaId = initial?.categoriaId ?? (widget.categories.isNotEmpty ? widget.categories.first.id : '');
    _metodoPago = initial?.metodoPago ?? 'efectivo';
  }

  @override
  void dispose() {
    _montoCtrl.dispose();
    _descripcionCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categoriesFiltered = widget.categories.where((c) => c.tipo == _tipo).toList();
    if (categoriesFiltered.isNotEmpty && !categoriesFiltered.any((c) => c.id == _categoriaId)) {
      _categoriaId = categoriesFiltered.first.id;
    }

    return AlertDialog(
      title: Text(widget.initialTransaction == null ? 'Nueva transacción' : 'Editar transacción'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                initialValue: _tipo,
                decoration: const InputDecoration(labelText: 'Tipo'),
                items: const [
                  DropdownMenuItem(value: 'gasto', child: Text('Gasto')),
                  DropdownMenuItem(value: 'ingreso', child: Text('Ingreso')),
                ],
                onChanged: (v) => setState(() => _tipo = v!),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: _categoriaId,
                decoration: const InputDecoration(labelText: 'Categoría'),
                items: categoriesFiltered.map((c) {
                  return DropdownMenuItem(value: c.id, child: Text(c.nombre));
                }).toList(),
                onChanged: (v) => setState(() => _categoriaId = v!),
                validator: (v) => v == null ? 'Seleccione una categoría' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _montoCtrl,
                decoration: const InputDecoration(labelText: 'Monto'),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || double.tryParse(v) == null ? 'Monto válido' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descripcionCtrl,
                decoration: const InputDecoration(labelText: 'Descripción'),
                validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
              ),
              const SizedBox(height: 8),
              ListTile(
                title: const Text('Fecha'),
                subtitle: Text(_fecha.toLocal().toString().split(' ')[0]),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _fecha,
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) setState(() => _fecha = picked);
                },
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: _metodoPago,
                decoration: const InputDecoration(labelText: 'Método de pago'),
                items: _metodosPago.map((m) => DropdownMenuItem(value: m, child: Text(m.toUpperCase()))).toList(),
                onChanged: (v) => setState(() => _metodoPago = v!),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.pop(context, {
                'categoriaId': _categoriaId,
                'monto': double.parse(_montoCtrl.text),
                'descripcion': _descripcionCtrl.text,
                'fecha': _fecha,
                'tipo': _tipo,
                'metodoPago': _metodoPago,
              });
            }
          },
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}