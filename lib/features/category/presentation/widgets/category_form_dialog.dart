import 'package:flutter/material.dart';

class CategoryFormDialog extends StatefulWidget {
  final String? initialNombre;
  final String? initialIcono;
  final String? initialColor;
  final String? initialTipo;

  const CategoryFormDialog({
    super.key,
    this.initialNombre,
    this.initialIcono,
    this.initialColor,
    this.initialTipo,
  });

  @override
  State<CategoryFormDialog> createState() => _CategoryFormDialogState();
}

class _CategoryFormDialogState extends State<CategoryFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nombreCtrl;
  late final TextEditingController _iconoCtrl;
  late final TextEditingController _colorCtrl;
  late String _tipo;

  @override
  void initState() {
    super.initState();
    _nombreCtrl = TextEditingController(text: widget.initialNombre ?? '');
    _iconoCtrl = TextEditingController(text: widget.initialIcono ?? 'category');
    _colorCtrl = TextEditingController(text: widget.initialColor ?? '#4CAF50');
    _tipo = widget.initialTipo ?? 'gasto';
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _iconoCtrl.dispose();
    _colorCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.initialNombre == null ? 'Nueva categoría' : 'Editar categoría'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nombreCtrl,
              decoration: const InputDecoration(labelText: 'Nombre'),
              validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _iconoCtrl,
              decoration: const InputDecoration(labelText: 'Icono (Material Icon name)'),
              validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _colorCtrl,
              decoration: const InputDecoration(labelText: 'Color (hex, ej. #4CAF50)'),
              validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: _tipo,
              decoration: const InputDecoration(labelText: 'Tipo'),
              items: const [
                DropdownMenuItem(value: 'gasto', child: Text('Gasto')),
                DropdownMenuItem(value: 'ingreso', child: Text('Ingreso')),
              ],
              onChanged: (v) => setState(() => _tipo = v!),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.pop(context, {
                'nombre': _nombreCtrl.text,
                'icono': _iconoCtrl.text,
                'color': _colorCtrl.text,
                'tipo': _tipo,
              });
            }
          },
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}